{%- from tpldir ~ '/map.jinja' import oscap with context %}

include:
  - scap.oscap

create oscap output directory:
  file.directory:
    - name: '{{ oscap.outputdir }}'
    - makedirs: True
    - require_in:
      - cmd: install oscap packages

manage scap content:
  file.recurse:
    - name: '{{ oscap.contentdir }}'
    - source: {{ oscap.content_source }}
    - makedirs: True
    - require_in:
      - cmd: install oscap packages

run oscap scan:
  cmd.run:
    - name: '(oscap xccdf eval --profile {{ oscap.profile }} --report {{ oscap.report }} --results {{ oscap.results }} --cpe {{ oscap.cpe }} {{ oscap.xccdf }}) || true'
    - cwd: '/root'
    - require:
      - file: manage scap content
      - file: create oscap output directory
