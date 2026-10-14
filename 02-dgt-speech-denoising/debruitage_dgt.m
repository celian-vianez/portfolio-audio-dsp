%% Débruitage de signal de parole
% Version avec estimation automatique du seuil et seuillage doux.

%% Préparation
Ici = pwd;
sound_path = fullfile(pwd, 'sounds');  % dossier contenant mspeech.wav
ltfat_path = fullfile(pwd, 'ltfat');    % toolbox LTFAT (https://ltfat.github.io)
cd(ltfat_path);
ltfatstart;
cd(Ici);

%% Chargement du fichier son
[mspeech, Fs] = audioread([sound_path, 'mspeech.wav']);
plot(mspeech); axis tight; grid on;

%% DGT
L = length(mspeech);
a = 20;
M = 4000;
g = gabwin('gauss', a, M, L);
V = dgtreal(mspeech, g, a, M, L);
plotdgtreal(V, a, M, Fs, 60);

%% Bruitage
amplitude = 1/2;
mspeech_bruit = mspeech + amplitude * randn(size(mspeech));
figure;
subplot(2,1,1); plot(mspeech); axis tight; title('Signal propre');
subplot(2,1,2); plot(mspeech_bruit); axis tight; title('Signal bruité');

%% Spectrogramme bruité
V_bruit = dgtreal(mspeech_bruit, g, a, M, L);
plotdgtreal(V_bruit, a, M, Fs, 60);

%% Masquage et débruitage automatique
figure;
histogram(abs(V_bruit(:)));
title('Distribution des amplitudes des coefficients DGT');
grid on;

% Estimation robuste du bruit dans le domaine DGT (méthode MAD)
coeffs_reels = [real(V_bruit(:)); imag(V_bruit(:))];
sigma_est = median(abs(coeffs_reels)) / 0.6745;

% Seuil universel, ajustable avec alpha
alpha = 0.6;
seuil = alpha * sigma_est * sqrt(2 * log(numel(V_bruit)));
fprintf('Seuil automatique : %.4f\n', seuil);

% Seuillage doux : réduit les coefficients proches du bruit
V_rec = max(abs(V_bruit) - seuil, 0) ./ max(abs(V_bruit), eps) .* V_bruit;

% Reconstruction du signal débruité
h = gabdual(g, a, M);
mspeech_rec = idgtreal(V_rec, h, a, M, L);

% Vérification quantitative du débruitage
snr_avant = 20 * log10(norm(mspeech) / norm(mspeech - mspeech_bruit));
snr_apres = 20 * log10(norm(mspeech) / norm(mspeech - mspeech_rec));
fprintf('SNR avant débruitage : %.2f dB\n', snr_avant);
fprintf('SNR après débruitage : %.2f dB\n', snr_apres);

figure;
subplot(2,1,1); plot(mspeech_bruit); axis tight; grid on;
title('Signal bruité');
subplot(2,1,2); plot(mspeech_rec); axis tight; grid on;
title('Signal débruité');

soundsc(mspeech_rec, Fs);
