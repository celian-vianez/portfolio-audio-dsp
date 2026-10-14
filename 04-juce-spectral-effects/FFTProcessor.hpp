#ifndef FFTProcessor_hpp
#define FFTProcessor_hpp

#pragma once
#include <JuceHeader.h>

class FFTProcessor {
    static constexpr int fftOrder = 10;
    static constexpr int fftSize = 1 << fftOrder;
    static constexpr int overlap = 4;
    static constexpr int hopSize = fftSize / overlap;
    
    bool vocoder = 0;
    float currentPitchShift = 0.0f;
    float currentSpectralGate = 0.0f;
    float currentHarmonizer = 0.0f;
    int currentSpectralBlur = 0;

    
    
    std::array<float, fftSize> inputRingBuffer;
    std::array<float, fftSize> outputRingBuffer;
    std::array<float, fftSize * 2> fftData;
    
    int pos = 0;
    int count = 0;
    
    juce::dsp::FFT fft;
    juce::dsp::WindowingFunction<float> window;
    

    float processSample(float sample);
    void processFrame();
    void processSpectrum(float* f);

    
public:
    FFTProcessor();
    int getLatencyInSamples() const { return fftSize; }
    void reset();
    void processBlock(float* input, int numInput);
    
    void setVocoder(bool enabled) { vocoder = enabled; }
    void setPitchShift(float demi_tons) { currentPitchShift = demi_tons; }
    void setSpectralGate(float threshold) { currentSpectralGate = threshold; }
    void setHarmonizer(float harmonizer) { currentHarmonizer = harmonizer; }
    void setSpectralBlur(int radius) { currentSpectralBlur = radius; }

};

#endif /* FFTProcessor_hpp */
