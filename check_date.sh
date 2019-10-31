#!/bin/bash


log_file="${1}/rename_log_$(date +%F).txt"

#all acceptable extensions
exts=(
    "3gp"
    "AVI"
    "JPEG"
    "JPG"
    "MOV"
    "mp3"
    "mp4"
    "mpeg"
    "MPG"
    "MTS"
    "png"
)

#all filename patterns
regexes=(
    "O\d{3}"
    "20\d{2}-\d{2}-\d{2} \d{2}\.\d{2}\.\d{2}"
    "\d{2}-\d{2}-\d{4} \d{3}"
    "\d{3}"
    "\d{3}_\d{4}"
    "\d{4}"
    "A\d{3}"
    "A\d{7}"
    "B\d{7}"
    "DCP_\d{4}"
    "DSC\d{5}"
    "DSC_\d{4}"
    "DSCF\d{4}"
    "DSCF\d{5}"
    "DSCN\d{4}"
    "FILE\d{4}"
    "File\d{4}"
    "HPIM\d{4}"
    "IMG_\d{4}"
    "img_\d{4}"
    "IMGP\d{4}"
    "m2u\d{5}"
    "M4H\d{5}"
    "marzec\d{2} \d{3}"
    "MOV\d{5}"
    "Obraz \d{3}"
    "OPAQ\d{4}"
    "P\d{7}"
    "p\d{7}"
    "PC\d{6}"
    "Photo \d{2}-\d{2}-\d{2} \d{2} \d{2} \d{2}"
    "Photo\d{2}_\d\d?A?"
    "PICT\d{4}"
    "S\d{7}"
    "SUNP\d{4}"
    "Video \d{2}-\d{2}-\d{2} \d{2} \d{2} \d{2}"
    "Zdjęcie\(\d+\)"
    "Zdjęcie\d{4}"
)

combine_regexes(){
    oIFS=$IFS
    IFS="|"
    echo "$*"
    IFS=$oIFS
}

check_path(){
    if [ ! -f "$1" ]; then
        echo "$1"
    else
        ext=${1##*.}
        extless=${1%.*}
        for i in $(seq 1 20); do
            new_path="${extless}-$i.$ext"
            if [ ! -f "$new_path" ]; then
                echo "$new_path"
                break
            fi
        done
    fi
}

file_name_regular_expression=$(combine_regexes "${regexes[@]}")
extension_regular_expression=$(combine_regexes "${exts[@]}")

while read -r line ; do
    #echo "Processing $line"
    dirpath=$(dirname "$line")
    file_name=$(basename "$line")
    ext=${file_name//*.}
    potential_aae_path="${line%.*}.AAE"
    if echo "$ext" | grep -qiE "$extension_regular_expression"; then
        file_name_date=$(echo "$line" | grep -oE "\d{4}-\d{2}-\d{2} \d{2}.\d{2}.\d{2}")
        stB="$(stat -f %SB -t "%Y-%m-%d %H.%M.%S" "$line")"
        sta="$(stat -f %Sa -t "%Y-%m-%d %H.%M.%S" "$line")"
        stm="$(stat -f %Sm -t "%Y-%m-%d %H.%M.%S" "$line")"
        stc="$(stat -f %Sc -t "%Y-%m-%d %H.%M.%S" "$line")"
        if [ -z "$file_name_date" ]; then
            oldest=$(printf "%s\n%s\n%s\n%s\n" "$stB" "$sta" "$stc" "$stm" | sort -nr | tail -n 1)
        else
            oldest=$(printf "%s\n%s\n%s\n%s\n%s\n" "$stB" "$sta" "$stc" "$stm" "$file_name_date" | sort -nr | tail -n 1)
        fi
        if [ "$oldest" != "$file_name_date" ]; then
            dest=$(check_path "$dirpath/$oldest.$ext")
            if [ -f "$potential_aae_path" ]; then
                if [ "$ext" == "MOV" ] || [ "$ext" == "mov" ]; then
                    aae_dest="${dest%.*}.AAE"
                    #echo "AAE : $aae_dest"
                    echo "mv" "$potential_aae_path" "$aae_dest" >> "$log_file"
                    if [ "$2" == "hard" ]; then
                        mv "$potential_aae_path" "$aae_dest"
                    fi
                fi
            fi
            #echo "      $line"
            #echo "Dest: $dest"
            #echo "aae?: $potential_aae_path"
            #printf "%s\t%s\n" "${line##*/}" "${dest##*/}"
            echo "mv" "$line" "$dest" >> "$log_file"
            if [ "$2" == "hard" ]; then
                mv "$line" "$dest"
            fi
#        else
#            echo "stB $stB"
#            echo "sta $sta"
#            echo "stm $stm"
#            echo "stc $stc"
#            echo "oldes: $oldest"
#            echo "fn   : $file_name_date"
        fi
#    else
#        echo "Bad extension $ext"
    fi
done < <(find "$1" -type f | grep -E "^.*/($file_name_regular_expression)[^/]+$")
