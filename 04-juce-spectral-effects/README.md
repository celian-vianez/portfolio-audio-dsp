# Plugin d'effets spectraux (C++ / JUCE)

Plugin audio temps réel qui traite le signal dans le domaine fréquentiel par STFT (FFT de 1024 points, recouvrement de 4, fenêtre de Hann, overlap-add).

## Effets

- **Robotisation** : mise à zéro de la phase de chaque bin (on ne garde que le module).
- **Pitch shift** en demi-tons : redistribution des bins avec le rapport `2^(n/12)`.
- **Spectral gate** : mise à zéro des bins dont le module est sous un seuil.
- **Harmonizer** : ajout d'une voix décalée en demi-tons au spectre d'origine.
- **Spectral blur** : lissage du spectre sur un rayon réglable.

Les paramètres sont exposés via `AudioProcessorValueTreeState`.

## Fichiers

- `FFTProcessor.hpp/.cpp` : moteur STFT et traitement du spectre
- `PluginProcessor.h/.cpp` : paramètres et traitement par canal
- `PluginEditor.h/.cpp` : interface

## Compilation

Le projet Projucer et le module JUCE ne sont pas inclus : créer un projet de plugin audio JUCE vide et remplacer les fichiers source par ceux de ce dossier.

## Limites

Approche pédagogique : le décalage de hauteur est fait par simple remapping de bins, sans suivi de phase (pas de phase vocoder complet), donc la qualité est limitée.
