# Débruitage de parole dans le domaine de Gabor

Script MATLAB de débruitage par seuillage doux des coefficients d'une transformée de Gabor discrète (DGT).

## Méthode

1. Ajout d'un bruit blanc gaussien à un signal de parole.
2. DGT avec fenêtre gaussienne (`a = 20`, `M = 4000`).
3. Estimation robuste du niveau de bruit sur les parties réelle et imaginaire des coefficients : écart-type estimé par la médiane (MAD) divisée par 0,6745.
4. Seuil universel `alpha · sigma · sqrt(2 log N)` (alpha ajustable), puis seuillage doux.
5. Reconstruction avec la fenêtre duale (`gabdual`, `idgtreal`) et affichage du SNR avant/après débruitage.

## Dépendances

- MATLAB
- [LTFAT](https://ltfat.github.io), à placer dans `ltfat/`
- Un fichier `sounds/mspeech.wav` (non fourni)

Les chemins sont relatifs au dossier courant.
