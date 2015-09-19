{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}

include:
  - makina-states.localsettings.jdk

{% for mod, ext in data.get('php_exts', {}).items() %}
{{ macros.toggle_ext(ext, True) }}
{% endfor %}

prepreqs-{{cfg.name}}:
  pkgrepo.managed:
    - humanname: jenkins apt
    - name: deb http://pkg.jenkins-ci.org/debian binary/
    - file: /etc/apt/sources.list.d/jenkins.list
    - key_url: http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key
    - watch_in:
      - pkg: prepreqs-{{cfg.name}}
  pkg.installed:
    - pkgs:
      - unzip
      - xsltproc
      - curl
      - sqlite3
      - libsqlite3-dev
      - mysql-client
      - apache2-utils
      - autoconf
      - automake
      - build-essential
      - bzip2
      - gettext
      - git
      - groff
      - libbz2-dev
      - libcurl4-openssl-dev
      - libdb-dev
      - libgdbm-dev
      - libreadline-dev
      - libfreetype6-dev
      - libsigc++-2.0-dev
      - libsqlite0-dev
      - libsqlite3-dev
      - libtiff5
      - libtiff5-dev
      - libwebp5
      - libwebp-dev
      - libssl-dev
      - libtool
      - libxml2-dev
      - libxslt1-dev
      - libopenjpeg-dev
      - m4
      - man-db
      - pkg-config
      - poppler-utils
      - python-dev
      - python-imaging
      - python-setuptools
      - zlib1g-dev

{{cfg.name}}-create_root:
  file.directory:
    - names:
      - "{{data.builds}}"
    - user: {{cfg.user}}
    - group: {{cfg.group}}
    - mode: 750
