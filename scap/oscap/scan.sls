{%- from tpldir ~ '/map.jinja' import oscap with context %}

include:
  - scap.oscap
  - scap.content

create oscap output directory:
  file.directory:
    - name: '{{ oscap.output_dir }}'
    - makedirs: True
    - require_in:
      - pkg: install oscap packages

run oscap scan:
  cmd.run:
    - name: 'oscap xccdf eval --profile {{ oscap.profile }} --report {{ oscap.report }} --results {{ oscap.results }} {{ oscap.ds }}'
    - cwd: '/root'
    - success_retcodes:
      - 2
    - require:
      - file: manage scap content
      - file: create oscap output directory
