# Audio signal processing & acoustics — personal work

Work done during my **Master's in Acoustics and Musicology, Sound Engineering and Design track** (Aix-Marseille University), in MATLAB and C++/JUCE.

The projects are organised by topic. Each folder contains a short README (goal, method, dependencies).

| Folder | Content | Tools |
|---|---|---|
| [`01-vowel-detection-lpc`](01-vowel-detection-lpc) | Vowel detection: autoregressive model (LPC), formants F1–F3, comparison with reference tables (French, UK/US English) | MATLAB, LTFAT |
| [`02-dgt-speech-denoising`](02-dgt-speech-denoising) | Speech denoising by soft thresholding in the Gabor domain, with an automatically estimated threshold (MAD) | MATLAB, LTFAT |
| [`03-physical-modelling-delay-line`](03-physical-modelling-delay-line) | Lossy delay-line synthesis: piano string and room echo | MATLAB |
| [`04-juce-spectral-effects`](04-juce-spectral-effects) | Real-time audio plugin: STFT-based spectral effects (pitch shift, spectral gate, harmonizer, spectral blur) | C++, JUCE |

## About

- Master's student (M2, Sound Engineering and Design) looking for a research internship in 2027.
- M1 research internship at the Laboratoire de Mécanique et d'Acoustique (LMA – CNRS, Sons team): data processing in MATLAB and statistical analysis in R.
- Contact: celian.vianez@gmail.com

## Notes

- The audio recordings used by the scripts are not provided.
- These repositories gather course and learning projects; they are not intended for production use.
- Third-party dependencies (LTFAT, JUCE) are not included and keep their own licences.
