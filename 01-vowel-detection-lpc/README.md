# Détection de voyelles par prédiction linéaire (LPC)

Script MATLAB qui identifie la voyelle prononcée à partir des formants estimés par un modèle autorégressif.

## Méthode

1. Spectrogramme de Gabor (fenêtre gaussienne) pour repérer visuellement les formants sur un segment.
2. Modèle AR d'ordre 10 (`aryule`, équations de Yule-Walker) ; choix de l'ordre guidé par la fonction d'autocorrélation partielle.
3. Les pôles du filtre sont convertis en fréquences et en largeurs de bande. On garde les pôles au-dessus de 90 Hz avec une largeur de bande inférieure à 400 Hz, soit les trois premiers formants F1–F3.
4. La voyelle est la plus proche (distance euclidienne) dans une table de formants de référence pour le français, l'anglais britannique ou l'anglais américain.
5. Analyse trame par trame (fenêtres de 60 ms, pas de 25 ms) avec rejet des trames silencieuses, pondération de F1 et rejet des détections trop éloignées de la table.

Une annotation manuelle des voyelles (instants et voyelles corrigés) figure en fin de script pour comparer les détections.

## Dépendances

- MATLAB avec Signal Processing Toolbox
- [LTFAT](https://ltfat.github.io) (`gabwin`, `dgtreal`, `plotdgtreal`)
- Un fichier audio `audio/male_fr.wav` (non fourni)

## Limites

La table de formants est indicative (valeurs moyennes) et la comparaison avec l'annotation manuelle est visuelle ; aucune métrique de précision n'est calculée.
