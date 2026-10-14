/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "FFTProcessor.hpp"

//==============================================================================
/**
*/

namespace Params
{
const juce::ParameterID vocoder { "vocoder", 1 };
const juce::ParameterID pitch_shift { "pitch shift", 1 };
const juce::ParameterID spectral_gate { "spectral gate", 1 };
const juce::ParameterID harmonizer { "harmonizer", 1 };
const juce::ParameterID spectral_blur { "spectral blur", 1 };
}

class FFT_ProcessorAudioProcessor  : public juce::AudioProcessor
{
public:
    //==============================================================================
    FFT_ProcessorAudioProcessor();
    ~FFT_ProcessorAudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

   #ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;
   #endif

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;
    
    juce::AudioProcessorValueTreeState pluginTreeState;

private:
    //==============================================================================
    juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout()
    {
        return {
            std::make_unique<juce::AudioParameterInt> (Params::vocoder, "Vocoder", 0, 1, 0),
            std::make_unique<juce::AudioParameterFloat> (Params::pitch_shift, "Pitch Schifting", juce::NormalisableRange<float>(-12.0f, 12.0f, 0.5f), 0.0f),
            std::make_unique<juce::AudioParameterFloat> (Params::spectral_gate, "Spectral Gate", juce::NormalisableRange<float>(0.0f, 1.0f, 0.01f), 0.0f),
            std::make_unique<juce::AudioParameterFloat>(Params::harmonizer, "Harmonizer", juce::NormalisableRange<float>(0.0f, 12.0f, 0.5f), 0.0f),
            std::make_unique<juce::AudioParameterInt> (Params::spectral_blur, "Spectral Blur", 0, 5, 0),
        };
    }

    juce::AudioParameterInt* VocoderParam = nullptr;
    juce::AudioParameterFloat* PitchShiftParam = nullptr;
    juce::AudioParameterFloat* SpectralGateParam = nullptr;
    juce::AudioParameterFloat* HarmonizerParam = nullptr;
    juce::AudioParameterInt* SpectralBlurParam = nullptr;
    
    FFTProcessor fft[2];
    
    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (FFT_ProcessorAudioProcessor)
};
