/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
FFT_ProcessorAudioProcessor::FFT_ProcessorAudioProcessor()
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       )
, pluginTreeState (*this, nullptr, "PluginState", createParameterLayout())
{
    VocoderParam = dynamic_cast<juce::AudioParameterInt*> (pluginTreeState.getParameter (Params::vocoder.getParamID()));
    PitchShiftParam = dynamic_cast<juce::AudioParameterFloat*> (pluginTreeState.getParameter (Params::pitch_shift.getParamID()));
    SpectralGateParam = dynamic_cast<juce::AudioParameterFloat*> (pluginTreeState.getParameter (Params::spectral_gate.getParamID()));
    HarmonizerParam = dynamic_cast<juce::AudioParameterFloat*> (pluginTreeState.getParameter (Params::harmonizer.getParamID()));
    SpectralBlurParam = dynamic_cast<juce::AudioParameterInt*> (pluginTreeState.getParameter (Params::spectral_blur.getParamID()));
}

FFT_ProcessorAudioProcessor::~FFT_ProcessorAudioProcessor()
{
}

//==============================================================================
const juce::String FFT_ProcessorAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool FFT_ProcessorAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool FFT_ProcessorAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool FFT_ProcessorAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double FFT_ProcessorAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int FFT_ProcessorAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int FFT_ProcessorAudioProcessor::getCurrentProgram()
{
    return 0;
}

void FFT_ProcessorAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String FFT_ProcessorAudioProcessor::getProgramName (int index)
{
    return {};
}

void FFT_ProcessorAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

//==============================================================================
void FFT_ProcessorAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{    
    fft[0].reset();
    fft[1].reset();
    // Use this method as the place to do any pre-playback
    // initialisation that you need..
}

void FFT_ProcessorAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool FFT_ProcessorAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    juce::ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    // Some plugin hosts, such as certain GarageBand versions, will only
    // load plugins that support stereo bus layouts.
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void FFT_ProcessorAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    // In case we have more outputs than inputs, this code clears any output
    // channels that didn't contain input data, (because these aren't
    // guaranteed to be empty - they may contain garbage).
    // This is here to avoid people getting screaming feedback
    // when they first compile a plugin, but obviously you don't need to keep
    // this code if your algorithm always overwrites all the output channels.
    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    // This is the place where you'd normally do the guts of your plugin's
    // audio processing...
    // Make sure to reset the state if your inner loop is processing
    // the samples and the outer loop is handling the channels.
    // Alternatively, you can process the samples with the channels
    // interleaved by keeping the same state.
    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer(channel);

        fft[channel].setPitchShift(PitchShiftParam->get());
        fft[channel].setVocoder(VocoderParam->get() == 1);
        fft[channel].setSpectralGate(SpectralGateParam->get());
        fft[channel].setHarmonizer(HarmonizerParam->get());
        fft[channel].setSpectralBlur(SpectralBlurParam->get());

        bool vocoder    = (VocoderParam->get() == 1);
        bool pitchShift = (PitchShiftParam->get() != 0.0f);
        bool threshold = (SpectralGateParam->get() != 0.0f);
        bool harmonizer = (HarmonizerParam->get() != 0.0f);
        bool spectralblur = (SpectralBlurParam->get() > 0);

        if (vocoder || pitchShift || threshold || harmonizer || spectralblur)
            fft[channel].processBlock(channelData, buffer.getNumSamples());
    }
}

//==============================================================================
bool FFT_ProcessorAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* FFT_ProcessorAudioProcessor::createEditor()
{
    return new FFT_ProcessorAudioProcessorEditor (*this);
}

//==============================================================================
void FFT_ProcessorAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void FFT_ProcessorAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new FFT_ProcessorAudioProcessor();
}
