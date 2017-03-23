{%- from tpldir ~ '/map.jinja' import scc with context %}

include:
  - scap.scc

{%- if scc.outputdir %}
'create directory {{ scc.outputdir }}':
  file.directory:
    - name: '{{ scc.outputdir }}'
    - makedirs: True
    - require_in:
      - pkg: 'install scc'
{%- endif %}

{%- for content in scc.get('content', []) %}
{%- set name = content.source.split('/')[-1] %}
{%- set fullname = scc.cachedir ~ scc.ossep ~ name %}
'manage file {{ name }}':
  file.managed:
    - name: '{{ fullname }}'
    - source: {{ content.source }}
    - source_hash: {{ content.source_hash }}
    - makedirs: True
    - require:
      - pkg: 'install scc'

'disable content other than {{ name }}':
  cmd.run:
    - name: '"{{ scc.cmd }}" -da -q'
    - require:
      - pkg: 'install scc'

'analyze {{ name }}':
  cmd.script:
    - name: {{ scc.retry_script }}
    - args: '5 "{{ scc.cmd }}" -isr {{ fullname }} -q {% if scc.outputdir -%} -u "{{ scc.outputdir }}" {%- endif %}'
    - require:
      - cmd: 'disable content other than {{ name }}'
      - file: 'manage file {{ name }}'
{%- if scc.outputdir %}
      - file: 'create directory {{ scc.outputdir }}'
{%- endif %}
{%- endfor %}
