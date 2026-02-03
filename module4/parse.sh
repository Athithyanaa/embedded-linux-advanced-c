
if [ $# -lt 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

inp_file="$1"
out_file="output.txt"


frame_time=""
wlan_type=""
wlan_subtype=""

while IFS= read -r line; do

    if [[ $line =~ \"frame.time\"\ *:\ *\"([^\"]+)\" ]]; then
        frame_time="${BASH_REMATCH[1]}"
    fi

    if [[ $line =~ \"wlan.fc.type\"\ *:\ *\"([^\"]+)\" ]]; then
        wlan_type="${BASH_REMATCH[1]}"
    fi

    if [[ $line =~ \"wlan.fc.subtype\"\ *:\ *\"([^\"]+)\" ]]; then
        wlan_subtype="${BASH_REMATCH[1]}"
    fi

    if [[ -n $frame_time && -n $wlan_type && -n $wlan_subtype ]]; then
        echo "\"frame.time\": \"$frame_time\"," >> "$out_file"
        echo "\"wlan.fc.type\": \"$wlan_type\"," >> "$out_file"
        echo "\"wlan.fc.subtype\": \"$wlan_subtype\"" >> "$out_file"
        echo >> "$out_file"
        frame_time=""
        wlan_type=""
        wlan_subtype=""
    fi
done < "$inp_file"
