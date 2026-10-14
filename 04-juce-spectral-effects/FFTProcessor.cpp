#include "FFTProcessor.hpp"

FFTProcessor::FFTProcessor() : fft(fftOrder),
window(fftSize + 1, juce::dsp::WindowingFunction<float>::WindowingMethod::hann, false) {}

void FFTProcessor::reset() {
    std::fill(inputRingBuffer.begin(), inputRingBuffer.end(), .0f);
    std::fill(outputRingBuffer.begin(), outputRingBuffer.end(), .0f);
    
    pos = 0;
    count = 0;
}

void FFTProcessor::processBlock(float* input, int numInput) {
    for (int i = 0; i < numInput; ++i) {
        input[i] = processSample(input[i]);
    }
}

float FFTProcessor::processSample(float sample) {
    inputRingBuffer[pos] = sample;
    sample = outputRingBuffer[pos];
    outputRingBuffer[pos] = 0.0f;

    pos = (pos + 1) % fftSize;
    count = (count + 1) % hopSize;
    if (count == 0) {
        processFrame(); // Perform FFT processing on the last 1024 samples
    }
    return sample;
}

void FFTProcessor::processFrame() {

    // Dérouler le buffer circulaire dans fftData
    float* inputPtr = inputRingBuffer.data();
    float* fftPtr = fftData.data();

    memcpy(fftPtr, inputPtr + pos, (fftSize - pos) * sizeof(float));
    if (pos > 0) memcpy(fftPtr + fftSize - pos, inputPtr, pos * sizeof(float));

    // Appliquer la fenetre ‡ notre signal
    window.multiplyWithWindowingTable(fftPtr, fftSize);
    
    // Calculer fft
    fft.performRealOnlyForwardTransform(fftPtr);
    // Traitement dans le domaine fréquentiel
    processSpectrum(fftPtr);
    // Transformée inverse
    fft.performRealOnlyInverseTransform(fftPtr);

    window.multiplyWithWindowingTable(fftPtr, fftSize);

    // Ré-enrouler les donnÈes traitées dans outputRingBuffer
    for (int i = 0; i < pos; ++i) {
        outputRingBuffer[i] += fftData[fftSize - pos + i] * 2.f/3.f;
    }
    for (int i = 0; i < fftSize - pos; ++i) {
        outputRingBuffer[pos + i] += fftData[i] * 2.f/3.f;
    }
}

void FFTProcessor::processSpectrum(float* data) {
    auto* cdata = reinterpret_cast<std::complex<float>*>(data);
    
    if (vocoder == 1)
    {
        for (int i = 0; i <= fftSize / 2; ++i)
        {
            float magnitude = std::abs(cdata[i]);
            cdata[i] = std::complex<float>(magnitude, 0.0f);
        }
    }

    if (currentPitchShift != 0.0f)
    {
        std::vector<std::complex<float>> temp(fftSize / 2 + 1, {0.f, 0.f});
        float ratio = std::pow(2.0f, currentPitchShift / 12.0f);

        for (int i = 0; i <= fftSize / 2; ++i)
        {
            int nouveau_bin = (int)std::round(i * ratio);
            if (nouveau_bin >= 0 && nouveau_bin <= fftSize / 2)
                temp[nouveau_bin] = temp[nouveau_bin] + cdata[i];
        }

        for (int i = 0; i <= fftSize / 2; ++i)
            cdata[i] = temp[i];
    }
    
    if (currentSpectralGate > 0.0f)
    {
        for (int i = 0; i <= fftSize / 2; ++i)
        {
            float magnitude = std::abs(cdata[i]);

            if (magnitude < currentSpectralGate)
                cdata[i] = 0.0f;
        }
    }
    
    if (currentHarmonizer > 0.0f)
    {
        std::vector<std::complex<float>> temp(fftSize / 2 + 1, {0.f, 0.f});
        float ratio = std::pow(2.0f, currentHarmonizer / 12.0f);

        for (int i = 0; i <= fftSize / 2; ++i)
        {
            temp[i] = temp[i] + cdata[i];

            int nouveau_bin = (int)std::round(i * ratio);
            if (nouveau_bin >= 0 && nouveau_bin <= fftSize / 2)
                temp[nouveau_bin] = temp[nouveau_bin] + cdata[i];
        }

        for (int i = 0; i <= fftSize / 2; ++i)
            cdata[i] = temp[i];
    }
    
    if (currentSpectralBlur > 0)
    {
        std::vector<std::complex<float>> temp(fftSize / 2 + 1, {0.f, 0.f});
        int radius = currentSpectralBlur;

        for (int i = 0; i <= fftSize / 2; ++i)
        {
            int count = 0;
            for (int j = i - radius; j <= i + radius; ++j)
            {
                if (j >= 0 && j <= fftSize / 2)
                {
                    temp[i] = temp[i] + cdata[j];
                    count++;
                }
            }
            temp[i] = temp[i] / (float)count;
        }

        for (int i = 0; i <= fftSize / 2; ++i)
            cdata[i] = temp[i];
    }
}

