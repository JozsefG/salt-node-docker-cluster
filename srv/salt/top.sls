base:
  '*':
    - global.deps
    - nodejs.deps
    - python.deps

  'minion-*':
    - docker.deps

  'node':
    - node.deps
