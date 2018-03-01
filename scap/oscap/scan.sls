{%- from tpldir ~ '/map.jinja' import oscap with context %}

include:
  - scap.oscap
  - scap.content

create oscap output directory:
  file.directory:
    - name: '{{ oscap.output_dir }}'
    - makedirs: True
    - require_in:
      - cmd: install oscap packages

run oscap scan:
  cmd.run:
    - name: '(oscap xccdf eval --profile {{ oscap.profile }} --report {{ oscap.report }} --results {{ oscap.results }} {% if not oscap.scap1_2 -%} --cpe {{ oscap.cpe }} {%- endif %} {{ oscap.xccdf }}) || true'
    - cwd: '/root'
    - require:
      - file: manage scap content
      - file: create oscap output directory
