# Spectral effects plugin (C++ / JUCE)

Real-time audio plugin that processes the signal in the frequency domain using an STFT (1024-point FFT, overlap factor of 4, Hann window, overlap-add).

## Effects

- **Robotization**: the phase of each bin is set to zero (only the magnitude is kept).
- **Pitch shift** in semitones: redistribution of the bins with the ratio `2^(n/12)`.
- **Spectral gate**: bins whose magnitude is below a threshold are set to zero.
- **Harmonizer**: a voice shifted by a number of semitones is added to the original spectrum.
- **Spectral blur**: smoothing of the spectrum over an adjustable radius.

The parameters are exposed through `AudioProcessorValueTreeState`.

## Files

- `FFTProcessor.hpp/.cpp`: STFT engine and spectrum processing
- `PluginProcessor.h/.cpp`: parameters and per-channel processing
- `PluginEditor.h/.cpp`: user interface

## Building

The Projucer project and the JUCE module are not included: create an empty JUCE audio plugin project and replace its source files with the ones in this folder.

## Limitations

Educational approach: pitch shifting is done by simple bin remapping, without phase tracking (no full phase vocoder), so the quality is limited.
