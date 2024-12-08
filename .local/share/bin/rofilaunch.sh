#!/usr/bin/env sh

# Set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
roconf="${confDir}/rofi/styles/style_${rofiStyle}.rasi"

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10

if [ ! -f "${roconf}" ]; then
    roconf="$(find "${confDir}/rofi/styles" -type f -name "style_*.rasi" | sort -t '_' -k 2 -n | head -1)"
fi

# Base directory for fzf filebrowser
baseDir="/mnt/01D96A3A94461A90/Musics/"

# Rofi action
case "${1}" in
    d|--drun) r_mode="drun" ;;
    w|--window) r_mode="window" ;;
    f|--filebrowser) r_mode="filebrowser" ;;
    fzf|--filebrowserfzf) r_mode="filebrowserfzf" ;;
    h|--help) echo -e "$(basename "${0}") [action]"
        echo "d :  drun mode"
        echo "w :  window mode"
        echo "f :  filebrowser mode,"
        echo "fzf :  filebrowser mode with fzf,"
        exit 0 ;;
    *) r_mode="drun" ;;
esac

# Set overrides
wind_border=$(( hypr_border * 3 ))
[ "${hypr_border}" -eq 0 ] && elem_border="10" || elem_border=$(( hypr_border * 2 ))
r_override="window {border: ${hypr_width}px; border-radius: ${wind_border}px;} element {border-radius: ${elem_border}px;}"
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
i_override="$(gsettings get org.gnome.desktop.interface icon-theme | sed "s/'//g")"
i_override="configuration {icon-theme: \"${i_override}\";}"

# Function to generate the file and directory list with icons for rofi
generate_file_list_with_icons() {
    # List directories first
    find "${baseDir}" -type d ! -path '*/.*' 2>/dev/null | while read -r dir; do
        icon="folder"
        base_name=$(basename "$dir")
        echo -e "${base_name}\0icon\x1f${icon}"
    done

    # Then, list files and assign predefined icons
    find "${baseDir}" -type f 2>/dev/null | while read -r file; do
        base_name=$(basename "$file")  # Extract only the file name
        # Predefine icons based on file extensions
        case "${file}" in
            *.mp3) icon="audio-x-generic" ;;   # Icon for MP3 files
            *.txt) icon="text-x-generic" ;;    # Icon for TXT files
            *.jpg|*.jpeg|*.png) icon="image-x-generic" ;;  # Icon for JPG/JPEG files
            *.png) icon="image-x-generic" ;;   # Icon for PNG files
            *.pdf) icon="application-pdf" ;;   # Icon for PDF files
            *) icon="application-x-generic" ;; # Default icon for other files
        esac
        echo -e "${base_name}\0icon\x1f${icon}"
    done
}

# Launch fzf filebrowser if mode is filebrowserfzf
if [ "${r_mode}" = "filebrowserfzf" ]; then
    if ! command -v fzf >/dev/null 2>&1; then
        echo "Error: fzf is not installed. Please install it and try again." >&2
        exit 1
    fi

    if [ ! -d "${baseDir}" ]; then
        echo "Error: Base directory '${baseDir}' does not exist." >&2
        exit 1
    fi

    selected_file=$(generate_file_list_with_icons | rofi -dmenu -i -p "File Browser" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -theme "${roconf}" -markup-rows)

    if [ -n "${selected_file}" ]; then
        # Find the full path of the selected file
        full_path=$(find "${baseDir}" -name "${selected_file}" 2>/dev/null | head -1)
        [ -n "${full_path}" ] && xdg-open "${full_path}" >/dev/null 2>&1 &
    fi

    exit 0
fi

# Launch rofi
rofi -show "${r_mode}" -theme-str "${r_scale}" -theme-str "${r_override}" -theme-str "${i_override}" -config "${roconf}"