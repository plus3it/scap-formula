{%- from tpldir ~ '/map.jinja' import scc with context %}

include:
  - scap.scc
  - scap.content

create scc output directory:
  file.directory:
    - name: '{{ scc.output_dir }}'
    - makedirs: True

{#- Cache the content locally, so we can use file.find to get a list of local
    file paths that match the guide_pattern. Then loop over all the patterns,
    creating a zip archive for each to be used by scc.
#}
{%- do salt.cp.cache_dir(scc.content_source) %}

{%- for pattern in scc.get('guide_patterns', []) %}

{%- set guide_parent = pattern.split('/')[0] %}
{%- set guides = salt.file.find(salt.file.join(scc.content_cache, guide_parent), type='f', name=pattern.split('/')[-1] ~ '*') %}
{%- set archive = salt.temp.file(suffix='.zip', prefix=pattern | replace('/', '.') ~ '-') %}
{%- do salt.archive.zip(zip_file=archive, sources=guides) %}

'uninstall all content before analyzing {{ pattern }}':
  cmd.run:
    - name: '"{{ scc.cmd }}" -ua -q'

'analyze {{ pattern }}':
  cmd.run:
    - name: '"{{ scc.cmd }}" -isr {{ archive }} -q -u "{{ scc.output_dir }}"'
    - require:
      - cmd: 'uninstall all content before analyzing {{ pattern }}'
      - file: 'create scc output directory'
    - retry:
        attempts: 5
        interval: 1
        splay: 3

{%- endfor %}
