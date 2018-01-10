# data-collection
MATLAB scripts for collecting data from test equipment. Run 'pathtool' to include this directory.

Tested with NI USB-GPIB-HS on Mac OSX.

Written for collecting data for SPAD cryogenic temperature characterization.

Instruments:

AQC = Linear Active Quenching Circuit Rev. 2 (see Eagle-Public github repo. for design files)

COUNTER = Keysight 53220A Univ. Counter

SMU = Keysight B2902A Source Measure Unit

TEMP (old) = Lakeshore 331 Temp. Controller

TEMP (new) = Lakeshore 336 Temp. Controller

Each function opens and closes the GPIB or serial instrument. This adds overhead, but means that data collection scripts don't need to pass around instrument objects.