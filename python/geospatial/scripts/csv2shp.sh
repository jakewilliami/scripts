ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:4326 -oo X_POSSIBLE_NAMES=NZTM_Easting -oo Y_POSSIBLE_NAMES=NZTM_Northing  -f "ESRI Shapefile" out/ ../data/NZRiverMaps_data/NZRiverMaps_data_water_quality_2021-04-17.csv