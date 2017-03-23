install oscap packages:
  pkg.installed:
    - pkgs:
      - openscap
      - openscap-scanner
{%- if salt.grains.get('os') == 'CentOS' %}
      - openscap-engine-sce
{%- endif %}
      - scap-security-guide
