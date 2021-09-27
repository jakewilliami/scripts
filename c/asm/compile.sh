set -xe
nasm -f macho64 "$1"
# nasm -felf64 "$1" # Linux
ld -macosx_version_min 10.7.0 -lSystem -o "${1%%.*}" "${1%%.*}.o"
rm "${1%%.*}.o"
