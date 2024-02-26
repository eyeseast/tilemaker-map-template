UNAME := $(shell uname)

ifeq ($(UNAME), Darwin))
	RELEASE = https://github.com/systemed/tilemaker/releases/download/v3.0.0/tilemaker-macos-latest.zip
else
	RELEASE = https://github.com/systemed/tilemaker/releases/download/v3.0.0/tilemaker-ubuntu-22.04.zip
endif

LANDCOVER = landcover/ne_10m_antarctic_ice_shelves_polys/ne_10m_antarctic_ice_shelves_polys.shp \
	landcover/ne_10m_urban_areas/ne_10m_urban_areas.shp \
	landcover/ne_10m_glaciated_areas/ne_10m_glaciated_areas.shp

zip/ne_10m_glaciated_areas.zip:
	mkdir -p $(dir $@)
	wget -O $@ https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_glaciated_areas.zip

zip/ne_10m_urban_areas.zip:
	mkdir -p $(dir $@)
	wget -O $@ https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_urban_areas.zip

zip/ne_10m_antarctic_ice_shelves_polys.zip:
	mkdir -p $(dir $@)
	wget -O $@ https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/physical/ne_10m_antarctic_ice_shelves_polys.zip

zip/water-polygons-split-4326.zip:
	mkdir -p $(dir $@)
	wget -O $@ https://osmdata.openstreetmap.de/download/water-polygons-split-4326.zip

coastline/water_polygons.shp: zip/water-polygons-split-4326.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $^
	touch $@

coastline: coastline/water_polygons.shp

landcover/ne_10m_antarctic_ice_shelves_polys/ne_10m_antarctic_ice_shelves_polys.shp: zip/ne_10m_antarctic_ice_shelves_polys.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $^
	touch $@

landcover/ne_10m_urban_areas/ne_10m_urban_areas.shp: zip/ne_10m_urban_areas.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $^
	touch $@

landcover/ne_10m_glaciated_areas/ne_10m_glaciated_areas.shp: zip/ne_10m_glaciated_areas.zip
	mkdir -p $(dir $@)
	unzip -d $(dir $@) $^
	touch $@

landcover: $(LANDCOVER)

# this will also get the resources folder with configs
build/tilemaker:
	wget $(RELEASE)
	unzip $(notdir $(RELEASE))
	rm $(notdir $(RELEASE))
	chmod +x $@

config.json: build/tilemaker
	ln -s resources/config-openmaptiles.json $@

process.lua: build/tilemaker
	ln -s resources/process-openmaptiles.lua $@

tilemaker: build/tilemaker config.json process.lua

clean:
	rm -rf build resources zip coastline landcover