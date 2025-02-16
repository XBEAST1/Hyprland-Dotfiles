#!/usr/bin/env sh

#// set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"
fastfetchConf="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/config.jsonc"

#// set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 3 ))

#// scale for monitor
mon_x_res=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
mon_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed "s/\.//")
mon_x_res=$(( mon_x_res * 100 / mon_scale ))

#// generate config
elm_width=$(( (28 + 8 + 5) * rofiScale ))
max_avail=$(( mon_x_res - (4 * rofiScale) ))
col_count=$(( max_avail / elm_width ))
r_override="window{width:100%;} listview{columns:${col_count};spacing:5em;} element{border-radius:${elem_border}px;orientation:vertical;} element-icon{size:28em;border-radius:0em;} element-text{padding:1em;}"

#// launch rofi menu
currentWall="$(basename "$(readlink "${hydeThemeDir}/wall.set")")"
wallPathArray=("${hydeThemeDir}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"

# Prepare wallpapers and clean names
wallpapers=()
wallpaper_names=()
thumbnails=()

for i in "${!wallList[@]}"; do
    cleaned_name=$(basename "${wallList[$i]}" | sed 's/\(-Black\|-Black2\|-Blue\|-Purple\|-Grey\|-Yellow\|-Blue2\|-Silver\|-Red\)\(\.jpg\|\.png\)$//' | sed 's/\(\.jpg\|\.png\|\.jpeg\|\.bmp\|\.webp\)$//')
    wallpapers+=("${wallList[$i]}")
    wallpaper_names+=("${cleaned_name}")
    thumbnails+=("${thmbDir}/$(set_hash "${wallList[$i]}").sqre")
done

# Sort wallpaper names and preserve original order in wallList and thumbnails
sorted_indices=$(for idx in "${!wallpaper_names[@]}"; do echo "${wallpaper_names[$idx]}|$idx"; done | sort -t'|' -k1,1V | cut -d'|' -f2)

sorted_wallpapers=()
sorted_wallpaper_names=()
sorted_thumbnails=()

for idx in $sorted_indices; do
    sorted_wallpapers+=("${wallpapers[$idx]}")
    sorted_wallpaper_names+=("${wallpaper_names[$idx]}")
    sorted_thumbnails+=("${thumbnails[$idx]}")
done

wallpapers=("${sorted_wallpapers[@]}")
wallpaper_names=("${sorted_wallpaper_names[@]}")
thumbnails=("${sorted_thumbnails[@]}")


rofiSel=$(parallel --link echo -en "\$(basename "{1}")"'\\x00icon\\x1f'"{2}"'\\n' ::: "${wallpaper_names[@]}" ::: "${thumbnails[@]}" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${currentWall}")

wallNameWithExt=""
for i in "${!wallpaper_names[@]}"; do
    if [[ "${wallpaper_names[$i]}" == "${rofiSel}" ]]; then
        wallNameWithExt="${wallpapers[$i]}"
        break
    fi
done

if [ -z "${wallNameWithExt}" ]; then
    echo "Error: Unable to find the selected wallpaper in the list!"
    echo "Selected: ${rofiSel}"
    echo "Available names: ${wallpaper_names[@]}"
    exit 1
fi

case "${wallNameWithExt}" in
    *Black2*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Black2.png" ;;
    *Black*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Black.png" ;;
    *Grey*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Grey.png" ;;
    *Purple*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Purple.png" ;;
    *Blue2*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Blue2.png" ;;
    *Blue*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Blue.png" ;;
    *Yellow*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Yellow.png" ;;
    *Silver*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Silver.png" ;;
    *Red*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Red.png" ;;
    *)
        fastfetchLogo="" ;;
esac

echo "Fastfetch logo path: ${fastfetchLogo}"

#// apply wallpaper
if [ ! -z "${rofiSel}" ] ; then
    for i in "${!wallpaper_names[@]}" ; do
        if [ "${wallpaper_names[$i]}" = "${rofiSel}" ]; then
            setWall="${wallpapers[$i]}"
            echo "Wallpaper path: ${setWall}"
            break
        fi
    done

    if [ -z "${setWall}" ]; then
        echo "Error: Wallpaper not found"
    fi

    if [ ! -z "${setWall}" ]; then
        echo "Applying wallpaper: ${setWall}"
        "${scrDir}/swwwallpaper.sh" -s "${setWall}"
        notify-send -a "t1" -i "${thmbDir}/$(set_hash "${setWall}").sqre" " ${rofiSel}"

    # Update Fastfetch config
    if [ -n "${fastfetchLogo}" ]; then
        jq --arg logo "$fastfetchLogo" '.logo.source = $logo' "$fastfetchConf" > "${fastfetchConf}.tmp" && mv "${fastfetchConf}.tmp" "$fastfetchConf"
    fi
    else
        echo "Error: Wallpaper not found or applied."
    fi
fi
