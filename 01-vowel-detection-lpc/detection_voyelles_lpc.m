%% Devoir détection de voyelles

% Chemin vers le dossier des fichiers audio
snd_path = fullfile(pwd, 'audio');  % dossier contenant male_fr.wav
% Copier le chemin vers le dossier contenant les audios à analyser

% Fonctions pour gérer la correspondance entre pôles, fréquences et largeurs de bande
pole2freq =  @(p,fs) (angle(p)*fs/(2*pi));
pole2bw = @(p,fs) -(fs/(4*pi)) * log(abs(p));

%% 

snd_fname = strcat(snd_path,'/male_fr.wav'); % Sélectionner l'audio à traiter
[sig,fs] = audioread(snd_fname);
L = length(sig); % Récupérer la longueur en échantillon du signal
temps = (0:L-1)/fs; % Permet de traduire le nombre d'échantillon total en seconde

figure(1);
plot(temps,sig); axis tight; grid on;
xlabel('Temps (sec.)'); ylabel('Amplitude');
title('Signal Audio Complet');
% soundsc(sig,fs) % Pour écouter le signal entier

%% Spectrogramme

% Parametres
a = 20; % Pas temporel
M = 4000; % Pas fréquentiel

% --- Choix de la fenêtre temporelle (en secondes) ---
t_debut = 0.6; % A partir de ... secondes
t_fin   = 0.75; % Jusqu'à ... secondes

t_debut_echant = t_debut * fs;
t_fin_echant = t_fin * fs;

sig_zoom = sig(t_debut_echant + 1:t_fin_echant);

% soundsc(sig_zoom,fs) % Pour écouter le signal segmenté

% 2. On définit une longueur compatible (multiple de M = 4000) pour le
% signal zoomé
L_zoom = ceil(length(sig_zoom) / M) * M;

% On s'assure que sig_zoom fait exactement cette taille
if length(sig_zoom) < L_zoom
    sig_zoom(end+1:L_zoom) = 0; % On complète avec des zéros si besoin
end

% 3. Calcul du spectrogramme
g_zoom = gabwin({'gauss', 1/10}, a, M, L_zoom); % On met 1/10 comme ca on voit précisément les formants
V_zoom = dgtreal(sig_zoom, g_zoom, a, M, L_zoom);

% 4. Affichage avec une dynamique ajustée pour mieux voir
figure(3);
plotdgtreal(V_zoom, a, M, fs, 60, 'nocolorbar'); % 60 pour avoir un bon niveau de contraste
title(['Zoom Formants de ', num2str(t_debut), 's à ', num2str(t_fin), 's']);

soundsc(sig_zoom)

%% 

[arcoeffs,E,K]=aryule(sig_zoom,10); % Modèle AR (auto-régressif) % On choisit un ordre 10
pacf = -K;
stem(pacf,'filled')
xlabel('Lag')
ylabel('Partial ACF')
title('Partial Autocorrelation Sequence')
xlim([1 15])
%
alpha = 0.99;
conf = sqrt(2)*erfinv(alpha)/sqrt(length(sig_zoom));
hold on
plot(xlim,[1 1]'*[-conf conf],'r') % Lignes rouges qui permettent de connaitre l'intervalle de confiance
% Entre les lignes rouges on considère que ce que l'on voit n'est que du bruit aléatoire
hold off
grid;

%% 

freqz(1,arcoeffs,[],fs);
[z,p,k]=tf2zp(1,arcoeffs);
zplane(z,p);

%% 

freqs = pole2freq(p,fs);
bws = pole2bw(p,fs);
inds = (freqs>90 & bws<400); % On sélectionne les formants au dessus de 90Hz
% et avec une bande passante infèrieur à 400Hz
freqs = freqs(inds);
disp(freqs);

%% Création des vecteurs des différents dictionnaires

% Dictionnaire des voyelles : Anglais Américain
ref_us.i_see     = [270, 2290, 3010]; % see
ref_us.i_sit     = [390, 1990, 2550]; % sit
ref_us.epsilon   = [530, 1840, 2480]; % set
ref_us.ae_cat    = [660, 1720, 2410]; % cat
ref_us.a_father  = [730, 1090, 2440]; % father
ref_us.open_o    = [570, 840, 2410];  % caught
ref_us.u_foot    = [440, 1020, 2240]; % foot
ref_us.u_food    = [300, 870, 2240];  % food
ref_us.wedge_cup = [640, 1190, 2390]; % cup
ref_us.schwa     = [500, 1500, 2400]; % about
ref_us.bird      = [490, 1350, 1690]; % bird

% Dictionnaire des voyelles : Anglais Britannique
ref_uk.i_see     = [250, 2300, 3100]; % see
ref_uk.i_sit     = [400, 2000, 2600]; % sit
ref_uk.e_set     = [500, 1900, 2500]; % set
ref_uk.ae_cat    = [650, 1700, 2400]; % cat
ref_uk.a_father  = [700, 1100, 2500]; % father
ref_uk.o_lot     = [550, 850, 2400];  % lot
ref_uk.u_foot    = [400, 1000, 2300]; % foot
ref_uk.u_food    = [300, 900, 2300];  % food
ref_uk.wedge_cup = [600, 1200, 2400]; % cup
ref_uk.schwa_1   = [500, 1500, 2400]; % about
ref_uk.bird      = [450, 1400, 1700]; % bird
ref_uk.schwa_2   = [450, 1500, 2400]; % ago

% Dictionnaire des voyelles : Francais
ref_fr.i = [240, 2300, 3100]; % si
ref_fr.e_ferme = [350, 2100, 2800]; % é
ref_fr.epsilon = [500, 1800, 2500]; % fait 
ref_fr.a_pas = [700, 1200, 2600];   % pas 
ref_fr.a_pate = [600, 1600, 2400];  % pâte 
ref_fr.o_peau = [450, 800, 2400]; % peau
ref_fr.o_dos = [400, 800, 2400]; % dos
ref_fr.u_tout = [300, 700, 2300]; % tout 
ref_fr.un = [350, 1000, 2300];   % un 
ref_fr.on = [400, 700, 2300];  % bon
ref_fr.e = [500, 1500, 2400];  % le
ref_fr.u = [250, 1800, 2600];  % tu
ref_fr.oe = [400, 1400, 2400];  % jeune
ref_fr.eu = [400, 1000, 2300];  % deux

fr = ref_fr;
uk = ref_uk;
us = ref_us;

F_mes = freqs(1:3)'; % [F1, F2, F3] Transforme le vecteur colonne en vecteur ligne grâce à '

%% Langue de l'audio

Langue_audio = fr; % Choisir la langue de son audio (fr/us/uk)

%% Calcul des distances

noms = fieldnames(Langue_audio); % Récupère la voyelle après "ref_.."
distances = zeros(length(noms), 1);

for i = 1:length(noms)
    val_ref = Langue_audio.(noms{i});
    % Calcul de la distance euclidienne
    distances(i) = sqrt(sum((val_ref - F_mes).^2));
    % distances(i) = sqrt(((val_ref(1) - F_mes(1)/val_ref(1))).^2 + ((val_ref(2) - F_mes(2)/val_ref(2))).^2 + ((val_ref(3) - F_mes(3)/val_ref(3))).^2);
end

% Résultat
[dist_min, idx] = min(distances);
fprintf('La voyelle la plus proche est : /%s/ (Distance = %.1f) à %s s. \n' , noms{idx}, dist_min, num2str(t_debut));

%% Automatisation de l'indexation de tous les formants

window_time = 0.06; % Durée de chaque fenêtre en s
window_hop = 0.025; % Pas entre chaque fenêtre en s
seuil = 0.01; % Seuil énergie relative (si pas assez de détection augmenter le seuil)

window_time_echan = round(window_time * fs); % Conversion temps (en s) en nombre d'échantillon
window_hop_echan = round(window_hop * fs); % Conversion temps (en s) en nombre d'échantillon
voyelle_prec = ''; % Permet de ne pas répéter la détection d'une même voyelle à la suite

n_trames = floor((length(sig) - window_time_echan) / window_hop_echan);

for i = 1:n_trames
    debut = (i-1) * window_hop_echan + 1;
    seg   = sig(debut : debut + window_time_echan - 1);
    t_centre = (debut + window_time_echan/2) / fs;

    if mean(seg.^2) < seuil * mean(sig.^2) % Si énergie trop faible (silence) 
        continue
    end

    [acoeffs, E, ~] = aryule(seg, 10);
    [z, p, k] = tf2zp(1, acoeffs);

    freqs = pole2freq(p, fs);
    bws   = pole2bw(p, fs);
    inds  = (freqs > 90 & bws < 400);
    freqs = freqs(inds);


    if length(freqs) < 3
        continue  % Pas assez de formants trouvés
    elseif length(freqs) > 5
        continue  % Trop de formants trouvés
    end

    F_mes = freqs(1:3)';
    Langue_audio = fr;
    noms = fieldnames(Langue_audio);
    distances = zeros(length(noms), 1);

    for v = 1:length(noms)
        val_ref = Langue_audio.(noms{v});
        % distances(v) = sqrt(((val_ref(1) - F_mes(1)/val_ref(1))).^2 + ((val_ref(2) - F_mes(2)/val_ref(2))).^2 + ((val_ref(3) - F_mes(3)/val_ref(3))).^2);
        % distances(v) = sqrt(sum((val_ref - F_mes).^2));
        alpha = 2; % facteur de pondération: le premier formant a alpha plus de poids que les deux suivantes
        distances(v) = sqrt((alpha*(val_ref(1) - F_mes(1))).^2 + (val_ref(2) - F_mes(2)).^2 + (val_ref(3) - F_mes(3)).^2);

    end

    [dist_min, idx] = min(distances);
    
    % Ne garder que les détections fiables
    if dist_min > 800
        continue  % Distance trop grande = probablement pas une voyelle pure
    end

    % Petit test
    if strcmp(voyelle_prec, noms{idx}) % Pour comparer du texte
        continue
    end

    
    % Résultats
    fprintf('t = %.2f s  →  /%s/ (distance = %.0f)\n', t_centre, noms{idx}, dist_min);
    voyelle_prec = noms{idx};

    % soundsc(seg,fs)

end

%% Tableau des valeurs corrigées

% Dictionnaire en francais simplifié
ref_alpha_fr.i = [240, 2300, 3100]; % si
ref_alpha_fr.et = [350, 2100, 2800]; % é
ref_alpha_fr.et = [500, 1800, 2500]; % fait 
ref_alpha_fr.a = [700, 1200, 2600];   % pas 
ref_alpha_fr.a = [600, 1600, 2400];  % pâte 
ref_alpha_fr.o = [450, 800, 2400]; % peau
ref_alpha_fr.o = [400, 800, 2400]; % dos
ref_alpha_fr.ou = [300, 700, 2300]; % tout 
ref_alpha_fr.un = [350, 1000, 2300];   % un 
ref_alpha_fr.on = [400, 700, 2300];  % bon
ref_alpha_fr.e = [500, 1500, 2400];  % le
ref_alpha_fr.u = [250, 1800, 2600];  % tu
ref_alpha_fr.oe = [400, 1400, 2400];  % jeune
ref_alpha_fr.e = [400, 1000, 2300];  % deux

noms_alpha = fieldnames(ref_alpha_fr);

% Vecteur Timecode corrigé
tab_timecode_corrige = [2.838 , 4.174 , 5.234 , 5.81 , 6.914, 7.674, 7.984, 9.014, 9.724, 11.014, 12, 16.074, 17.234, 18.204, 19.74, 20.374, 21.624, 21.974, 23.334, 24.034, 25.024, 26.124, 31.704, 32.804, 34.074, 35.374, 36.154,36.484, 37.010, 39.654, 40.324, 41.824, 43.534, 44.654, 45.384, 46.524, 47.244, 48.394,49.174, 50.594, 56.164, 57.184, 58.228, 59.290, 61.578, 62.044, 63.23 ,63.694, 64.354, 65.46, 66.014, 67.404, 68.32, 69.124, 70.544, 71.264, 71.62, 73.104, 73.88, 75.054, 75.654, 77.604, 78.704, 79.554, 80.964, 82.984, 83.974, 84.844, 85.78, 87.014, 93.254, 93.766, 94.154, 95.51, 97.73,  98.684, 99.534, 100.894, 102.194, 103.24,104.364, 105.684, 106.824, 112.024, 113.39, 114.144, 115.444, 116.66, 122.004, 122.814, 123.48, 123.624, 123.83, 124.334, 125.494, 127.284, 128.124,  129.434, 130.284, 131.42, 132.556, 133.984, 134.994, 135.554, 136.21, 140.15, 149.82, 141.444, 142.76, 143.934, 145.464, 146.364, 147.28, 147.784, 149.354, 150.834, 151.48, 152.29, 153.554, 155.364, 156.38, 157.56];

% Vecteur Voyelle corrigé
tab_voyelle_corrige = ["a","i","et","e","o","et","e","i","u","et","e","e","u","et","i","et","et","e","u","o","on","i","i","un","oe","i","a","e","a","on","et","on","e","o","et","on","on","on","o","i","on","et","a","o","e","e","u","i","i","a","i","e","et","e","e","i","et","a","i","et","on","e","et","on","on","o","e","et","e","u","o","a","o","a","i","e","i","o","ou","et","e","ou","et","o","et","u","et","ou","et","u","e","o","a","i","a","oe","et","et","on","on","o","ou","e","u","i","et","a","a","un","a","i","e","e","on","a","a","e","i","et","on","e","et"];


n_reponseJuste = 0; % Nombre de réponses juste que l'on va incrémenter
ecart_fen = 0.04; % Ecart acceptée autour du debut de la fenetre

for i = 1:length(tab_timecode_ordi)
   for j = 1: length(tab_timecode_corrige)
       if   (((tab_timecode_ordi(i) - ecart_fen) < tab_timecode_corrige(j)) && (tab_timecode_corrige(j) < (tab_timecode_ordi(i) + ecart_fen)  ) && strcmp(tab_voyelle_corrige, tab_voyelle_ordi))
           n_reponseJuste = n_reponseJuste +1;
       end
   end
end


n_voyelleDetectees = length(tab_voyelle_ordi);
tdr = n_reponseJuste / n_voyelleDetectees % taux de réussite

n_fausseAlerte = length(tab_voyelle_ordi) - lenght(tab_voyelle_corrige);

fprintf("taux de réponses justes : %.1f (nombre de fausses alertes: %.1f)\n",  n_reponseJuste, n_fausseAlerte);

% 
% tab_timecode_ordi = !!DANS LA BOUCLE!! debut;
% tab_voyelle_ordi = !!DANS LA BOUCLE!! noms_alpha{idx};
