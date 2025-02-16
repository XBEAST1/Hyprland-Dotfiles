#!/usr/bin/env sh

#// set variables

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"
fastfetchConf="${XDG_CONFIG_HOME:-$HOME/.config}/fastfetch/config.jsonc"

#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 5 ))
icon_border=$(( elem_border - 5 ))

#// scale for monitor

mon_x_res=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
mon_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed "s/\.//")
mon_x_res=$(( mon_x_res * 100 / mon_scale ))

#// generate config

case "${themeSelect}" in
2) # adapt to style 2
    elm_width=$(( (20 + 12) * rofiScale * 2 ))
    max_avail=$(( mon_x_res - (4 * rofiScale) ))
    col_count=$(( max_avail / elm_width ))
    r_override="window{width:100%;background-color:#00000003;} listview{columns:${col_count};} element{border-radius:${elem_border}px;background-color:@main-bg;} element-icon{size:20em;border-radius:${icon_border}px 0px 0px ${icon_border}px;}"
    thmbExtn="quad" ;;
*) # default to style 1
    elm_width=$(( (23 + 12 + 1) * rofiScale * 2 ))
    max_avail=$(( mon_x_res - (4 * rofiScale) ))
    col_count=$(( max_avail / elm_width ))
    r_override="window{width:100%;} listview{columns:${col_count};} element{border-radius:${elem_border}px;padding:0.5em;} element-icon{size:23em;border-radius:${icon_border}px;}"
    thmbExtn="sqre" ;;
esac

#// launch rofi menu

get_themes

rofiSel=$(for i in ${!thmList[@]} ; do
    echo -en "${thmList[i]}\x00icon\x1f${thmbDir}/$(set_hash "${thmWall[i]}").${thmbExtn}\n"
done | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${hydeTheme}")

#// change logo path based on selected theme

case "${rofiSel}" in
    *"Castle Dimitrescu"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Purple.png" ;;
    *"Gruvbox"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Yellow.png" ;;
    *"Misty"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Blue2.png" ;;
    *"Electra"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Grey.png" ;;
    *"Asylums"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Black.png" ;;
    *"Obscura"*) 
        fastfetchLogo="${HOME}/.config/fastfetch/png/Black.png" ;;
    *"Cyber"*)
        fastfetchLogo="${HOME}/.config/fastfetch/png/Purple.png" ;;
    *) 
        fastfetchLogo="" ;;
esac

#// apply theme

if [ ! -z "${rofiSel}" ] ; then
    "${scrDir}/themeswitch.sh" -s "${rofiSel}"
    notify-send -a "t1" -i "$fastfetchLogo" " ${rofiSel}"

    # Update Fastfetch config
    if [ -n "${fastfetchLogo}" ]; then
        jq --arg logo "$fastfetchLogo" '.logo.source = $logo' "$fastfetchConf" > "${fastfetchConf}.tmp" && mv "${fastfetchConf}.tmp" "$fastfetchConf"
    fi
fi