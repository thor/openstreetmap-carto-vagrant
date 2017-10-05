# openstreetmap-vagrant
#  - Shared state for all machines
# See README.md for more information

# Install basic tools that are useful to have for installing this and that.
base:
  pkg.installed:
    - install_recommends: False
    - pkgs:
      # just some basic packages, not specific to the carto setup.
      - git 
      - unzip
      - curl
      - build-essential
      - software-properties-common
    - refresh: True
    - aggregate: True

