# Shared state for all machines



# Install basic tools that are useful to have for installing this and that.
base:
  pkg.installed:
    - install_recommends: false
    - pkgs:
      # just some basic packages, not specific to the carto setup.
      - git 
      - unzip
      - curl
      - build-essential
      - software-properties-common
    - refresh: true

