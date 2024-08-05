#!/bin/bash

# Variables
TMP_DIR="$HOME/RickPi/tmp_files"
LOG_FILE="/tmp/rife_transmission.log"
RPITX_PATH="$HOME/rpitx"
OUTPUT_FREQ=31000000
GAIN_AMPLITUDE=8.0

# Ensure the tmp_files directory exists
mkdir -p "$TMP_DIR"

# List imported WAV files
list_imported_wav_files() {
    wav_files=()
    while IFS= read -r wav_file; do
        wav_files+=("$(basename "$wav_file")" "")
    done < <(find "$HOME/RickPi" -name '*.wav')

    wav_choice=$(whiptail --title "RickPi - Imported WAV Files" --menu "Choose a WAV file to transmit:" 20 78 10 "${wav_files[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        exit 0
    fi

    echo "$HOME/RickPi/$wav_choice" > "$TMP_DIR/generated_files.txt"
    transmit_files
}

transmit_files() {
    TRANSMIT_SCRIPT="$TMP_DIR/transmit.sh"
    echo "#!/bin/bash" > $TRANSMIT_SCRIPT
    echo "while true; do" >> $TRANSMIT_SCRIPT

    while IFS= read -r wav_path; do
        sample_rate=$(soxi -r "$wav_path")
        duration=$(soxi -D "$wav_path")

        echo "echo 'Transmitting \$(basename $wav_path .wav) using $wav_path at sample rate $sample_rate' | tee -a $LOG_FILE" >> $TRANSMIT_SCRIPT
        echo "screen -dmS rpitx_session bash -c \"cat '$wav_path' | csdr convert_i16_f | csdr gain_ff $GAIN_AMPLITUDE | csdr dsb_fc | sudo $RPITX_PATH/rpitx -i - -m IQFLOAT -f '$OUTPUT_FREQ' -s $sample_rate\"" >> $TRANSMIT_SCRIPT
        echo "sleep $duration" >> $TRANSMIT_SCRIPT
        echo "sudo killall rpitx" >> $TRANSMIT_SCRIPT
        echo "sleep 1" >> $TRANSMIT_SCRIPT
    done < "$TMP_DIR/generated_files.txt"

    echo "done" >> $TRANSMIT_SCRIPT
    chmod +x $TRANSMIT_SCRIPT

    screen -dmS rpitx_session bash -c "$TRANSMIT_SCRIPT"
}

# Main script execution
list_imported_wav_files
