{%- from tpldir ~ '/map.jinja' import oscap with context %}

create directory {{ oscap.outputdir }}:
  file.directory:
    - name: '{{ oscap.outputdir }}'
    - makedirs: True
    - require_in:
      - cmd: run oscap scan

run oscap scan:
  cmd.run:
    - name: '(oscap xccdf eval --profile {{ oscap.profile }} --report {{ oscap.report }} --results {{ oscap.results }} --cpe {{ oscap.cpe }} {{ oscap.xccdf }}); true'
    - cwd: '/root'
