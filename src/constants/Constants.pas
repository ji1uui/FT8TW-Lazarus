{ FT8TW - Lazarus Edition
  Constants and Protocol Definitions
  Platform: Windows, macOS
  Author: ji1uui
}

unit Constants;

interface

const
  // Application Info
  APP_NAME = 'FT8TW-Lazarus';
  APP_VERSION = '1.0.0';
  APP_AUTHOR = 'ji1uui';

  // FT8 Protocol Constants
  FT8_SYMBOL_RATE = 6.25;      // Baud rate (symbols/sec)
  FT8_TONE_SPACING = 6.25;     // Hz spacing between tones
  FT8_NUM_TONES = 8;           // GFSK modulation (8 FSK states)
  FT8_DURATION = 12.64;        // Duration of FT8 transmission (seconds)
  FT8_BANDWIDTH = 200;         // Maximum bandwidth (Hz)
  FT8_SAMPLE_RATE = 12000;     // Audio sample rate (Hz)
  FT8_FFT_SIZE = 4096;         // FFT size for analysis
  FT8_SYMBOLS_PER_MSG = 79;    // Symbols per FT8 message
  FT8_BITS_PER_MSG = 77;       // Data bits per message (with CRC)

  // Audio Constants
  AUDIO_BUFFER_SIZE = 4096;    // Audio buffer size
  AUDIO_CHANNELS = 1;          // Mono
  AUDIO_BIT_DEPTH = 16;        // 16-bit PCM
  AUDIO_NUM_BUFFERS = 2;       // Number of audio buffers

  // Display Constants
  WATERFALL_WIDTH = 200;       // Pixels
  WATERFALL_HEIGHT = 300;      // Pixels
  WATERFALL_UPDATE_MS = 100;   // Update interval (ms)
  SPECTRUM_HISTORY_SIZE = 100; // Number of spectrum lines to keep

  // Frequency Bands (Hz) - Center frequencies
  BAND_160M_FREQ = 1838000;    // 160m band
  BAND_80M_FREQ = 3573000;     // 80m band (default FT8 frequency)
  BAND_60M_FREQ = 5357000;     // 60m band
  BAND_40M_FREQ = 7074000;     // 40m band
  BAND_30M_FREQ = 10136000;    // 30m band
  BAND_20M_FREQ = 14074000;    // 20m band
  BAND_17M_FREQ = 18100000;    // 17m band
  BAND_15M_FREQ = 21074000;    // 15m band
  BAND_12M_FREQ = 24915000;    // 12m band
  BAND_10M_FREQ = 28074000;    // 10m band
  BAND_6M_FREQ = 50318000;     // 6m band
  BAND_2M_FREQ = 144074000;    // 2m band

  // Default Configuration
  DEFAULT_CALLSIGN = ''; 
  DEFAULT_LOCATOR = ''; 
  DEFAULT_TX_POWER = 10;       // Watts
  DEFAULT_MONITOR_ONLY = True; // RX only by default 
  DEFAULT_THEME = 'Default';

  // SNR Thresholds (dB)
  MIN_SNR_FOR_DECODE = -26;    // Minimum SNR for FT8 decode
  GOOD_SNR_THRESHOLD = -10;
  EXCELLENT_SNR_THRESHOLD = 0;

  // Message Types
  MSG_TYPE_CQ = 0;
  MSG_TYPE_QSO = 1;
  MSG_TYPE_GRID = 2;
  MSG_TYPE_SIGNAL_REPORT = 3;
  MSG_TYPE_RRR = 4;            // Roger-Roger-Roger
  MSG_TYPE_73 = 5;             // End of QSO

  // Error Codes
  ERR_NO_ERROR = 0;
  ERR_DECODE_FAILED = 1;
  ERR_AUDIO_DEVICE_NOT_FOUND = 2;
  ERR_INVALID_FREQUENCY = 3;
  ERR_INVALID_CALLSIGN = 4;
  ERR_CONFIG_LOAD_FAILED = 5;
  ERR_FFT_FAILED = 6;

  // UI Refresh Rates (ms)
  SPECTRUM_REFRESH_MS = 50;
  STATUS_REFRESH_MS = 100;
  CLOCK_REFRESH_MS = 1000;

implementation

end.