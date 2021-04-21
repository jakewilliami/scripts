# This script will merge shape files.  To merge tiff files, consider using `gdal_merge.py`

FILE1_TO_MERGE="../data/lds-nz-river-polygons-topo-150k-SHP/nz-river-polygons-topo-150k.shp"
FILE2_TO_MERGE="../data/lds-nz-river-centrelines-topo-150k-SHP/nz-river-centrelines-topo-150k.shp"
FILE3_TO_MERGE="../data/nz-property-titles/nz-property-titles-2.shp"
OUT_FILE="all_external/all_external.shp"

[[ -d "${OUT_FILE%%/*}" ]] || mkdir "${OUT_FILE%%/*}"
[[ -z "$(ls -A "${OUT_FILE%%/*}")" ]] || rm "${OUT_FILE%%/*}"/*

ogr2ogr -f 'ESRI Shapefile' "$OUT_FILE" "$FILE1_TO_MERGE"
ogr2ogr -f 'ESRI Shapefile' -update -append "$OUT_FILE" "$FILE2_TO_MERGE" -nln "$(basename "${OUT_FILE}" ".${OUT_FILE##*.}")"
# ogr2ogr -f 'ESRI Shapefile' -update -append "$OUT_FILE" "$FILE3_TO_MERGE" -nln "$(basename "${OUT_FILE}" ".${OUT_FILE##*.}")"

