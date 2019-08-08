{%- from tpldir ~ '/map.jinja' import scc with context %}

{%- set os_family = salt.grains.get('os_family') %}

install scc:
  pkg.installed:
    - name: {{ scc.name }}
{%- if scc.version %}
    - version: {{ scc.version }}
{%- endif %}
{%- if scc.pkg %}
    - sources:
      - {{ scc.name }}: {{ scc.pkg.source }}
{%- endif %}
    - allow_updates: True
    - skip_verify: True

{%- if os_family == 'Windows' %}
set permissions option:
  file.replace:
    - name: 'C:\\Program Files\\SCAP Compliance Checker {{ scc.version }}\\options.xml'
    - pattern: '<setRestrictedPermissions>1</setRestrictedPermissions>'
    - repl: '<setRestrictedPermissions>0</setRestrictedPermissions>'
    - ignore_if_missing: True
    - require:
      - pkg: 'install scc'
{%- endif %}
