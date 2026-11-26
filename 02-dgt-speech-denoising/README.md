# Speech denoising in the Gabor domain

MATLAB script for denoising by soft thresholding of the coefficients of a discrete Gabor transform (DGT).

## Method

1. Gaussian white noise is added to a speech signal.
2. DGT with a Gaussian window (`a = 20`, `M = 4000`).
3. Robust estimation of the noise level on the real and imaginary parts of the coefficients: standard deviation estimated by the median absolute deviation (MAD) divided by 0.6745.
4. Universal threshold `alpha · sigma · sqrt(2 log N)` (adjustable alpha), followed by soft thresholding.
5. Reconstruction with the dual window (`gabdual`, `idgtreal`) and display of the SNR before/after denoising.

## Dependencies

- MATLAB
- [LTFAT](https://ltfat.github.io), to be placed in `ltfat/`
- A file `sounds/mspeech.wav` (not provided)

Paths are relative to the current folder.
