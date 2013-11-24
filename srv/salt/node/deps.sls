supervisor:
  pkg:
    - installed
  service:
    - running

/opt/src:
  file.recurse:
    - source: salt://node/src
    - include_empty: true

/etc/supervisor/conf.d/node-web-skel.conf:
  file.managed:
    - template: jinja
    - source: salt://node/node-web-skel.conf
