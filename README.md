# Tilemaker starter kit

[tilemaker](https://github.com/systemed/tilemaker) will build vector tiles from OSM extracts. It needs a config and processing script, and it _can_ use landcover and coastline shapefiles. This is a workflow that automates gathering all of that.

`make` all the things:

```sh
make tilemaker # get the latest tilemaker release
make landcover # get landcover from Natural Earth
make coastline # get coastline files
```

Download an OpenStreetMap extract from [Geofabrik](https://download.geofabrik.de/). Put it here or anywhere. For example:

```sh
# Massachusetts
wget https://download.geofabrik.de/north-america/us/massachusetts-latest.osm.pbf
```

Point `tilemaker` at your new OSM PBF:

```sh
./build/tilemaker massachusetts-latest.osm.pbf massachusetts.mbtiles
```
