# openstreetmap-vagrant
*An easy, yet customizeable, way to get a OpenStreetMap PostGIS database and renderer up on your local machine.*

## Use-cases

* You want to have a local PostGIS database with OSM data
* You want to develop a CartoCSS stylesheet for Mapnik rendering
* You want immediate re-rendering when you update anything

## Requirements
* You *need* to have **[Vagrant](http://www.vagrantup.com/)** on your system
  * *Windows, Mac OS X and Linux distributions are all supported*
* You *currently need* **[VirtualBox](http://www.virtualbox.org/)** as well
* You *need* a CartoCSS project to work on, this one defaults to **[openstreetmap-carto](https://github.com/gravitystorm/openstreetmap-carto)**
* You *should* have between **4GB to 8GB of memory**
* You *should* have virtualization extensions

## Features Checklist & Todos
- [X] VMs with Vagrantfile
- [X] Automatic PostGIS install & configuration
 - [X] Changing PostGIS username and password
- [X] Automatic Kosmtik install & configuration
 - [X] Pointing Kosmtik to any other PostGIS database
 - [X] Configure Kosmtik plugins
- [ ] Provisioned updating of OSM sources on-demand
 - [ ] Include **furry-sansa** for usage
 - [ ] Expose **furry-sansa** via its own configuration

## Usage
### Getting Started
1. Make sure you've covered the requirements.
2. Run the following from the command line
  
  ```
$ vagrant up
  ```

3. SSH into the PostGIS VM and **import maps into the PostgreSQL database**.
  
  ```
$ vagrant ssh gis
  ```

4. Make cool changes to the CartoCSS, preferably in its own branch!
5. Open up [the instance of Kosmtik at http://127.0.0.1:6789](http://127.0.0.1:6789).

### Getting Updated Map Data
*Not added yet!*

