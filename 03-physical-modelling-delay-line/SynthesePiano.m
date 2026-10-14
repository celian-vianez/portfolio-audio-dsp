
% SYNTHESE DE SON DE PIANO

% ------------------- Entrée utilisateur
%Fonda = 440;                         % Fréquence fondamentale voulue
%L = 1.2;                             % Longueur de la corde
%v = Fonda * 2 * L;                   %
%d = sqrt(tension/(rho*pi*v^2));      %

% -------------------- Paramètres

fech = 44100;

% Corde
d = 15 * 10^-4;                       % diamètre de la corde 

tension = 80 * 9.81 ;                 % Tension de la corde
rho = 7800 ;                          % masse volumique de la corde (acier)
v = sqrt(tension/(rho * pi * d^2 ));  % vitesse du son dans la corde 
L = 1;                                % longueur de la corde de piano

m = round( L * fech /  v);              % retard en nombre d'échantillon, lié à la réflexion de l'onde sur une extrémité de la corde
G = 0.98 ;                                   % perte d'énergie à chaque réflexion

% vecteur temps
T = 5;                                       % durée du vecteur t
n = fech * T;                                % nombre de point du vecteur t
t = (0:n-1)/fech;                            % vecteur temps %t = linspace(0, T, n); 

% impact
T1 = 2*10^-3;                                % durée de l'impact
f = 1/T1;                                    % "fréquence" du cosinus surélevé représentant l'impact
n1 = fech * T1;                              % nombre de points de l'impact
A = 5;                                       % Amplitude

% signal d'entrée
input = zeros(size(t));                     % Initialisation du signal d'entrée
for i = 1:round(n1)                         % Remplissage du vecteur input uniquement pendant la durée de l'impact, le reste est constitué de 0 
    input(i) =  A * (1-cos(2*pi*f*t(i)));   % Force en entrée: une période du cosinus surélevé de durée T1
end

% Filtrage
filtre = zeros(size(t));

%---------------------- Calcul du signal de sortie (modèle compact)
output = zeros(size(t));                              % initialisation du signal de sortie            
for i = m+5:n                                         % la boucle commence uniquement pour les échantillons > à m
    % output(i) = input(i-m) + G*output(i-m);          % récurrence sans filtrer

     filtre(i) = (output(i-m)+output(i-m-1)+output(i-m-2)+output(i-m-3)+output(i-m-4))/5;
     output(i) = input(i-m) + G*filtre(i);           % récurrence en filtrant 
end
    
output = output / max(abs(output));                % Normalisation

% --------------------  Résultats

%affichage du spectre
Y = abs(fft(output)); 
freq = (0:length(t)/2-1)/length(t)*fech;   % Axe des fréquences

plot(freq, Y(1:length(t)/2))
xlabel('Fréquence (Hz)')
ylabel('Amplitude')
title('Spectre FFT')

% affichage du signal temporel
plot(t,output); 
soundsc(output, fech);
Fonda = v/2*L                       % calcul de la fréquence fondamentale


















