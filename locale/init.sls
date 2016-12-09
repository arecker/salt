locale-en-us:
  locale.present:
    - name: en_US.UTF-8

locale-default:
  locale.system:
    - name: en_US.UTF-8
    - require:
        - locale: locale-en-us
