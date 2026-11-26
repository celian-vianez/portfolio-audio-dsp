# Lossy delay-line synthesis

Two MATLAB scripts from the course "Numerical methods and acoustics of musical instruments".

- `SynthesePiano.m`: piano string sound. The delay `m` between two reflections is computed from the properties of the string (diameter, tension, density, length). The hammer is modelled by a 2 ms raised-cosine force pulse. The recurrence `y[n] = x[n-m] + G·filter(y)[n-m]` applies a loss `G` at each reflection, with a 5-sample moving average in the loop (low-pass filter, in the spirit of Karplus-Strong), which further attenuates the high frequencies.
- `SyntheseEchoFlottant.m`: room echo ("flutter echo") between two walls. A clap is fed into the recurrence `y[n] = x[n-m] + G·y[n-m]`, with a delay derived from the distance between the walls and the speed of sound.

## Dependencies

MATLAB. `SyntheseEchoFlottant.m` reads a file `Clap_mono.wav` (not provided).
