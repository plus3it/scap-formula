{%- from tpldir ~ '/map.jinja' import scap with context %}

{%- if scap.driver %}

include:
  - .{{ scap.driver }}

{%- else %}

print scap help:
  test.show_notification:
    - text: |
        No SCAP `driver` was found. Available drivers include:
            oscap
            scc

        Please set a grain or pillar with the desired driver to apply to this
        system (the grain takes precedence):
            grain:  scap:driver
            pillar: scap:lookup:driver

        Alternatively, call the SCAP driver states directly:
            scap.oscap
            scap.oscap.scan
            scap.scc
            scap.scc.scan

        See https://github.com/plus3it/scap-formula for more details.

{%- endif %}
