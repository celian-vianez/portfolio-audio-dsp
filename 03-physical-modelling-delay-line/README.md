# Synthèse par ligne à retard avec pertes

Deux scripts MATLAB issus du cours « Méthodes numériques et acoustique des instruments de musique ».

- `SynthesePiano.m` : son de corde de piano. Le retard `m` entre deux réflexions est calculé à partir des propriétés de la corde (diamètre, tension, masse volumique, longueur). Le marteau est modélisé par une impulsion de force en cosinus surélevé de 2 ms. La récurrence `y[n] = x[n-m] + G·filtre(y)[n-m]` applique une perte `G` à chaque réflexion, avec un moyennage sur 5 échantillons dans la boucle (filtre passe-bas, dans l'esprit de Karplus-Strong), ce qui atténue davantage les hautes fréquences.
- `SyntheseEchoFlottant.m` : écho de salle (« flutter echo ») entre deux murs. Un clap est injecté dans la récurrence `y[n] = x[n-m] + G·y[n-m]`, avec un retard déduit de la distance entre murs et de la vitesse du son.

## Dépendances

MATLAB. `SyntheseEchoFlottant.m` lit un fichier `Clap_mono.wav` (non fourni).
