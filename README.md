# FT8TW Lazarus

FT8TW-Lazarus is a compact FreePascal/Lazarus project skeleton for FT8-related audio and protocol experimentation.

## Included modules

- `DataTypes.pas`: Shared records and array types.
- `Constants.pas`: Application and FT8 constants.
- `Configuration.pas`: INI-based configuration manager.
- `AudioDevice.pas`: Audio device abstraction (stub implementation).
- `AudioProcessor.pas`: Tone generation and normalization helpers.
- `SignalProcessor.pas`: RMS and tone power estimation.
- `FT8Protocol.pas`: Simple message encode/decode helpers.
- `FT8TW.lpr`: Runnable entry point.

## Build

```bash
fpc FT8TW.lpr
```

## Run

```bash
./FT8TW
```

This project is intentionally lightweight and ready to be extended with real FT8 DSP/codec logic.


## GUI

Run Lazarus GUI entry point:

```bash
fpc FT8TW_GUI.lpr
./FT8TW_GUI
```

The GUI supports callsign/locator/frequency editing, configuration save, and basic signal/protocol test logging.
