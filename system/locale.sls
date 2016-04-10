locale-packages:
  pkg.installed:
    - name: locales

locales-us:
  locale.present:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages

locales-default:
  locale.system:
    - name: en_US.UTF-8
    - require:
        - pkg: locale-packages
        - locale: locales-us
