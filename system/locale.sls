locale-packages:
  pkg.installed:
    - name: locales

locales-en-us:
  locale.present:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages

locales-default:
  locale.system:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages
        - locale: locales-en-us
