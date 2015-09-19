{% set cfg = opts['ms_project'] %}
{% set data = cfg.data %}

{{cfg.name}}-jenkins:
  user.present:
    - name: jenkins
    - shell: /bin/bash
    - remove_groups: False
    - groups:
      - sshusers
  file.managed:
    - name: /etc/sudoers.d/jenkins
    - contents:
    - mode: 660
    - user: root
    - group: root
    - createhome: true
    - contents: |
                jenkins ALL=(ALL) NOPASSWD: ALL
  cmd.run:
    - name: |
            mkdir ~/.ssh
            touch ~/.ssh/authorized_keys
            chmod -Rf 700 ~/.ssh
            chmod 600 ~/.ssh/authorized_keys
    - user: jenkins
    - watch:
      - file: {{cfg.name}}-jenkins 
  # handle that we dont know jenkins home before
  {% set sshkeys = data.get('sshkeys', []) %}
  {% if sshkeys %}
  ssh_auth.present:
    - names:
    {% for key in sshkeys %}
      - "{{key}}"
    {% endfor %}
    - user: jenkins
    - watch:
      - cmd: {{cfg.name}}-jenkins
  {% endif %}
