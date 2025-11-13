#!/usr/bin/env bash
set -eu

patch_cmd() {
    echo "Applying:: $(basename "$1")"
    patch -Np1 -i "$1"
}

here="$(dirname "$(realpath "$0")")"
    
if [ -d "$here/proton" ] && [ "$(ls -A "$here/proton")" ]; then
    mapfile -t ppatches < <(find "$here/proton" -type f -name "*.patch" | sort)
    for patch in "${ppatches[@]}"; do
        patch_cmd "$patch"
    done
fi

cd wine || exit 1

# Reset to certain commit
git checkout 969de296fed981565ee989f5971d94bba3330696

if [ -d "$here/wine" ] && [ "$(ls -A "$here/wine")" ]; then
    mapfile -t patches < <(find "$here/wine" -type f -name "*.patch" | sort)
    for patch in "${patches[@]}"; do
        patch_cmd "$patch"
    done
fi

cd ..
