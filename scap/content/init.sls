{%- from 'scap/map.jinja' import scap with context %}

manage scap content:
  file.recurse:
    - name: '{{ scap.content.local_dir }}'
    - source: {{ scap.content.source }}
    - makedirs: True
