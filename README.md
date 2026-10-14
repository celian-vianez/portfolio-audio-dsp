# Traitement du signal audio & acoustique — travaux personnels

Travaux réalisés pendant ma formation en **Master Acoustique et Musicologie, parcours Ingénierie et Conception Sonore** (Aix-Marseille Université), en MATLAB et C++/JUCE.

Les projets sont rangés par thème. Chaque dossier contient un court README (objectif, méthode, dépendances).

| Dossier | Contenu | Outils |
|---|---|---|
| [`01-vowel-detection-lpc`](01-vowel-detection-lpc) | Détection de voyelles : modèle autorégressif (LPC), formants F1–F3, comparaison à des tables de référence (français, anglais UK/US) | MATLAB, LTFAT |
| [`02-dgt-speech-denoising`](02-dgt-speech-denoising) | Débruitage de parole par seuillage doux dans le domaine de Gabor, seuil estimé automatiquement (MAD) | MATLAB, LTFAT |
| [`03-physical-modelling-delay-line`](03-physical-modelling-delay-line) | Synthèse par ligne à retard avec pertes : corde de piano et écho de salle | MATLAB |
| [`04-juce-spectral-effects`](04-juce-spectral-effects) | Plugin audio temps réel : effets spectraux par STFT (pitch shift, spectral gate, harmonizer, spectral blur) | C++, JUCE |

## À propos

- Étudiant en M2 Ingénierie et Conception Sonore, je recherche un stage de fin d'études à partir de mars 2027.
- Stage de recherche de M1 au Laboratoire de Mécanique et d'Acoustique (LMA – CNRS, équipe Sons) : traitement de données sous MATLAB et analyses statistiques sous R.
- Contact : celian.vianez@gmail.com

## Remarques

- Les enregistrements audio utilisés par les scripts ne sont pas fournis.
- Ces dépôts rassemblent des travaux de cours et d'apprentissage ; ils ne sont pas destinés à être utilisés en production.
- Les dépendances tierces (LTFAT, JUCE) ne sont pas incluses et gardent leurs propres licences.
