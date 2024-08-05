
## RickPi

This project uses RPiTX to generate and transmit Rickrolling frequencies. It includes scripts for installing the necessary software, transmitting the Rickroll song, and stopping transmissions.

## Installation

1. **Clone the Repository:**
   
```sh
git clone https://github.com/CodeMasterCody3D/RickPi.git
cd RickPi
```

2. **Run the Installation Script:**

   The installation script will install the required dependencies, clone the RPiTX repository, and set up the necessary directories and files. Set permissions first with chmod.

```sh
chmod +x rickrollinstall.sh

# Now you can run the script by typing.

./rickrollinstall.sh
```
   
   This script will:
   - Install dependencies (sox, screen).
   - Clone the RPiTX repository if it doesn't already exist.
   - Copy and set up the `rick.sh` script in the appropriate directory.

## Usage

1. **Start the Transmission:**

   Use the `startroll.sh` script to start the transmission process.

```sh
./startroll.sh
```

2. **Stop the Transmission:**

   Use the `stoproll.sh` script to stop the transmission process.

```sh
./stoproll.sh
```

## Configuration

### Customizing Frequencies and Waveforms

You can customize the frequencies and waveforms by modifying the relevant scripts and JSON files.

- `rick.sh`: Main script for transmitting Rickroll frequencies.
- `startroll.sh`: Script to start the transmission process.
- `stoproll.sh`: Script to stop the transmission process.
- `rickrollinstall.sh`: Installation script.

### File Locations

- Imported WAV Files: Stored in `$HOME/RickPi`.

## Troubleshooting

If you encounter any issues, ensure that you have run the installation script as root (sudo). Check the log file at `/tmp/rife_transmission.log` for error messages.

### Common Issues

- **Permission Denied:** Ensure you are running scripts with the necessary permissions.
- **Dependencies Not Installed:** Ensure all dependencies are installed by running the installation script.
- **Incorrect Paths:** Ensure all paths in the scripts are correct and use the `$HOME` environment variable to ensure compatibility with different user directories.

## Contributing

Feel free to fork this repository and submit pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License.
