#!/bin/bash

DEFAULT_OUTPUT_FREQ=3.1e6
TMP_DIR="$HOME/RickPi/tmp_files"
IMPRT_WAV_DIR="$HOME/RickPi/imprt_wav"
AUDIO_AMPLITUDE=0.5
GAIN_AMPLITUDE=8.0
RPITX_PATH="$HOME/rpitx"
LOG_FILE="/tmp/rife_transmission.log"

choose_output_frequency() {
    OUTPUT_FREQ=$(whiptail --inputbox "Enter output Frequency (in Hz). Default is 3.1 MHz" 8 78 $DEFAULT_OUTPUT_FREQ --title "Change Carrier Frequency" 3>&1 1>&2 2>&3)
    OUTPUT_FREQ=${OUTPUT_FREQ:-$DEFAULT_OUTPUT_FREQ}
}

choose_audio_amplitude() {
    AUDIO_AMPLITUDE=$(whiptail --inputbox "Enter audio amplitude for WAV file generation (0.0 - 1.0). Default is 0.5" 8 78 $AUDIO_AMPLITUDE --title "Change Audio Amplitude" 3>&1 1>&2 2>&3)
    AUDIO_AMPLITUDE=${AUDIO_AMPLITUDE:-0.5}
}

choose_gain_amplitude() {
    GAIN_AMPLITUDE=$(whiptail --inputbox "Enter gain amplitude for transmission. Default is 8.0" 8 78 $GAIN_AMPLITUDE --title "Change Gain Amplitude" 3>&1 1>&2 2>&3)
    GAIN_AMPLITUDE=${GAIN_AMPLITUDE:-8.0}
}

stop_transmissions() {
    sudo pkill -f rpitx
    sudo pkill -f tran.sh
    rm -rf "$TMP_DIR/*"
    echo "Stopped all transmissions and cleared the temporary files."
}

list_imported_wav_files() {
    wav_files=()
    while IFS= read -r wav_file; do
        wav_files+=("$(basename "$wav_file")" "")
    done < <(find "$IMPRT_WAV_DIR" -name '*.wav')

    wav_choice=$(whiptail --title "RickPi - Imported WAV Files" --menu "Choose a WAV file to transmit:" 20 78 10 "${wav_files[@]}" 3>&1 1>&2 2>&3)
    if [ $? -ne 0 ]; then
        echo "User cancelled."
        exit 0
    fi

    echo "$IMPRT_WAV_DIR/$wav_choice" > "$TMP_DIR/generated_files.txt"
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
choose_output_frequency
choose_audio_amplitude
choose_gain_amplitude
list_imported_wav_files
