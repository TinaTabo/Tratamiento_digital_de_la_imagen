% Integrante-1: Ana Poveda García Herrero
% Integrante-2: Cristina Taboada Mayo.
%% -------------------- PARTE OBLIGATORIA --------------------
clear all, close all, clc
% Cargamos la imagen.
I = imread('G15.jpeg');
figure,imshow(I),title('Imagen original')

% Transformamos la imagen a escala de grises.
X = rgb2gray(I);
figure,imshow(X),title('Imagen original en escala de grises')

% Calculo de la FFT de la imagen original.
X_FFT = fftshift(fft2(double(X),1600,1200));

% Calculo del módulo y la fase de la FFT(esto lo calculamos para poder
% visualizarlos, ya que la FFT no puede visualizarse directamente)

FFT_modulo = abs(X_FFT); % Calcula el modulo del resultado de la FFT
FFT_fase = angle(X_FFT); % Calcula la fase del resultado de la FFT

% Visualizamos el modulo y la fase de la FFT.
% Para poder visualizar el modulo debemos hacer la siguiente
% transformación: log10(1+FFT_modulo), para aumentar el contraste, y
% visualizar mejor la imagen resultante.
figure,subplot(1,2,1),imshow(log10(1+FFT_modulo),[]),title('modulo')
subplot(1,2,2),imshow(FFT_fase),title('fase')

%% Obtener imagen binaria donde solo aparecen como primer plano los píxeles asociados a los cambios espaciales de intensidad.
clear all, close all, clc

% Filtrado paso alto con el filtro ideal.

% Creamos el FPB.
H = lpfilter('ideal',1600,1200,100);

H = 1-H; % Con este comando, transformamos el FPB en el FPA.
FFT_moduloH = abs(H); 
FFT_faseH = angle(H);
figure,mesh(FFT_moduloH),title('Mesh del FFT Modulo del FPA')
figure,mesh(FFT_faseH),title('Mesh del FFT Fase del FPA')
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH),[]),title('modulo FPA')
subplot(1,2,2),imshow(FFT_faseH),title('fase FPA')

% Cargamos la imagen
I = imread('G15.jpeg');

% Transformamos la imagen a escala de grises.
X = rgb2gray(I);

% Aplicamos el filtro paso alto a la imagen original.
F = fft2(double(X));
Filtrada_freq= H.*F;
FPA_ideal = abs(real(ifft2(Filtrada_freq)));
figure,imshow(FPA_ideal,[]),title('Imagen Filtrada Paso Alto')

% Aplicamos umbralización para visualizar la imagen.
X_U = im2bw(FPA_ideal,230/255);
figure, imshow(X_U), title('Imagen Binaria')

%% -------------------- PARTE CREATIVA --------------------
clear all, close all, clc

% Cargamos la imagen y la pasamos a tipo double.
I = im2double(imread('G15.jpeg'));

% Simulamos un efecto de movimiento (desenfoque) en la imagen original.
LEN = 50; % Número de pixel con movimiento lineal.
THETA = 45; % Angulo de desenfoque
PSF = fspecial('motion', LEN, THETA); % Point Spread Function (Respuesta al impulso espacial, nuestra H)
desenfoque = imfilter(I, PSF, 'conv', 'circular'); % Aplica el filtro como una convolucion circular.

% Restauramos la imagen desenfocada utilizando un filtro de Wiener.
F_Wiener = deconvwnr(desenfoque, PSF, 0);

% Visualizamos el resultado.
figure,subplot(1,3,1),imshow(I),title('Imagen original')
subplot(1,3,2),imshow(desenfoque),title('Imagen desenfocada')
subplot(1,3,3),imshow(F_Wiener),title('Imagen Restaurada')

