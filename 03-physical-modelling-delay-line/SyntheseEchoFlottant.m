% SYNTHESE D'écho flottant

% ------------------- Entrée utilisateur
%Fonda = 440;   % fréquence fondamentale voulue
%L = 1.2;
%v = Fonda * 2 * L;
%d = sqrt(tension/(rho*pi*v^2));

[clap, fech] = audioread("Clap_mono.wav");
clap = clap(:,1);

% -------------------- Paramètres

% vecteur temps
T = 5;                        % durée du vecteur t
n = fech * T;                  % nombre de point du vecteur t
t = (0:n-1)/fech;               % vecteur temps %t = linspace(0, T, n); 

% signal d'entrée
input = zeros(size(t));                       % initialisation
input(1:length(clap))=clap;                   % remplissage du vecteur input avec le clap

% Propriétés de l'air entre les murs
v = 342 ;                                               % vitesse du son dans l'air
L = 12 ;                                                % distance entre les murs
m = round( L * fech /  v);                              % retard en nombre d'échantillon, lié à la réflexion de l'onde sur un mur
G = 0.9 ;                                               % perte d'énergie à chaque réflexion

%---------------------- Calcul du signal de sortie (modèle compact)

output = zeros(size(t));                      % initialisation du signal de sortie            
for i = m+1:n                                 % la boucle commence uniquement pour les échantillons > à m
     output(i) = input(i-m) + G*output(i-m);  % récurrence
end
    
output = output / max(abs(output));                % Normalisation

% --------------------  Résultats

plot(t,output); 

Y = abs(fft(output)); %fft
freq = (0:length(t)/2-1)/length(t)*fech;   % Axe des fréquences

plot(freq, Y(1:length(t)/2))
xlabel('Fréquence (Hz)')
ylabel('Amplitude')
title('Spectre FFT')

soundsc(output, fech);


















