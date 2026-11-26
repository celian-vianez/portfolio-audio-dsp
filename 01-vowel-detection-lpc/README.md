# Vowel detection by linear prediction (LPC)

MATLAB script that identifies the spoken vowel from the formants estimated by an autoregressive model.

## Method

1. Gabor spectrogram (Gaussian window) to visually locate the formants on a segment.
2. AR model of order 10 (`aryule`, Yule-Walker equations); the choice of order is guided by the partial autocorrelation function.
3. The filter poles are converted into frequencies and bandwidths. Poles above 90 Hz with a bandwidth below 400 Hz are kept, i.e. the first three formants F1–F3.
4. The vowel is the closest one (Euclidean distance) in a table of reference formants for French, British English or American English.
5. Frame-by-frame analysis (60 ms windows, 25 ms hop) with rejection of silent frames, weighting of F1 and rejection of detections too far from the table.

A manual annotation of the vowels (corrected times and vowels) is included at the end of the script to compare the detections.

## Dependencies

- MATLAB with the Signal Processing Toolbox
- [LTFAT](https://ltfat.github.io) (`gabwin`, `dgtreal`, `plotdgtreal`)
- An audio file `audio/male_fr.wav` (not provided)

## Limitations

The formant table is indicative (average values) and the comparison with the manual annotation is visual; no accuracy metric is computed.
