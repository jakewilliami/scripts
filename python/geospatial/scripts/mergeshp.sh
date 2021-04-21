# This script will merge shape files.  To merge tiff files, consider using `gdal_merge.py`
# Run is as such:
#     bash mergeshp.sh outfile.sh in1.sh in2.sh in3.sh ...

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
	echo "This script will merge shape files.  To merge tiff files, consider using gdal_merge.py"
	echo "Run is as such:"
	echo "    bash mergeshp.sh outfile.sh in1.sh in2.sh in3.sh ..."
	exit 0
fi

OUT_FILE="$1"

[[ -d "${OUT_FILE%%/*}" ]] || mkdir "${OUT_FILE%%/*}"
[[ -z "$(ls -A "${OUT_FILE%%/*}")" ]] || rm "${OUT_FILE%%/*}"/*

for i in "${@:2}"; do
	if [[ -f "${OUT_FILE}" ]]; then
		ogr2ogr -f 'ESRI Shapefile' "$OUT_FILE" "$i"
	else
		ogr2ogr -f 'ESRI Shapefile' -update -append "$OUT_FILE" "$i" -nln "$(basename "${OUT_FILE}" ".${OUT_FILE##*.}")"
	fi
done
