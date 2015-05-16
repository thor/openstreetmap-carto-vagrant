# Salt states for getting kosmtik installed for purposes of
# improving the OpenStreetMap CartoCSS implementation and style.


# A whole bunch of libraries that we'll need, plus a bunch of extra fornts.
package-requirements:
  pkg.installed:
    - install_recommends: false
    - pkgs:
      - git
      - libgtk2.0-dev
      - libwebkitgtk-dev
      - protobuf-compiler
      - libprotobuf-dev
      - libgdal1-dev
      - gdal-bin
      - python-yaml
      # nodejs and npm for kosmtik
      - nodejs
      - nodejs-legacy
      - npm
      # here be the fonts
      - ttf-dejavu
      - ttf-unifont
      - fonts-droid
      - fonts-sipa-arundina
      - fonts-sil-padauk
      - fonts-khmeros

# Getting kosmtik from github, latest version
kosmtik:
  user.present:
    - name: kosmtik
    - empty_password: True
  git.latest:
    - rev: master
    - name: https://github.com/kosmtik/kosmtik.git
    - target: /usr/local/kosmtik
    - force_reset: True
    - depth: 1
    - require:
      - pkg: package-requirements
  npm.bootstrap:
    - name: /usr/local/kosmtik
    - require:
      - git: kosmtik
  # Edited via pillars, shouldn't need any manual overrides here
  # Any improvements should ideally be in rega
  file.managed:
    - name: /home/kosmtik/localconfig.json
    - contents: |
        [
          { 
            "where": "Layer",
            "if": {
              "Datasource.type": "postgis",
              "Datasource.dbname": "gis"
            },
            "then": {
              "Datasource.dbname": "{{ salt['pillar.get']('kosmtik:source:dbname', 'gis') }}",
              "Datasource.password": "{{ salt['pillar.get']('kosmtik:source:password', 'gispassword') }}",
              "Datasource.user": "{{ salt['pillar.get']('kosmtik:source:user', 'gisuser') }}",
              "Datasource.host": "{{ salt['pillar.get']('kosmtik:source:host', '172.22.22.11') }}"
            }
          }
        ]
    - require:
      - user: kosmtik

# Only recommended on your local machine
# -- Do not do in production environments!
/usr/local/kosmtik/:
  file.directory:
    - mode: 0777

# Configure kosmtik upstart service
/etc/init/kosmtik.conf:
  file.managed:
    - contents: |
        description "Kosmtik render service"
        author "Thor M. K. H. <thor@roht.no>"
        start on started postgresql
        stop on runlevel [016]
        env HOME=/home/kosmtik/
        setuid kosmtik
        nice -10
        oom score -500
        respawn
        respawn limit 10 90
        chdir /usr/local/kosmtik
        exec node index.js serve /srv/openstreetmap-carto/project.yaml --host=0.0.0.0 --localconfig /home/kosmtik/localconfig.json
  service.running:
    - name: kosmtik
    - require:
      - file: /etc/init/kosmtik.conf

# Create .config folder to ensure kosmtik won't fail on plugin install
#/home/kosmtik/.config/:
  #  file.directory:
    #    - user: gituser

{% for plugin in salt['pillar.get']('kosmtik:plugins', {}) %}
{{ plugin }}:
  cmd.run:
    - name: node index.js plugins --install {{ plugin }}
    - user: kosmtik
    - cwd: {{ salt['pillar.get']('kosmtik:path', '/usr/local/kosmtik') }}
    - creates: /usr/local/kosmtik/node_modules/{{ plugin }}/package.json
    - require:
      - npm: kosmtik
      - file: kosmtik
    - require_in:
      - service: /etc/init/kosmtik.conf
{% endfor %}
