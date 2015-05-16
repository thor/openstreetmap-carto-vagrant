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

## Usage
1. Make sure you've covered the requirements.
2. Run the following from the command line
  
  ```
$ vagrant up
  ```
3. Open up [the instance of Kosmtik at http://127.0.0.1:6789](http://127.0.0.1:6789).
4. Make cool changes to the CartoCSS, preferably in its own branch!
5. See the changes reflected in step #3.
