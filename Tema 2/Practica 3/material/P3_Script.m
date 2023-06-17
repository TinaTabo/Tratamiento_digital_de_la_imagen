%%%%%%% PRÁCTICA 3 %%%%%%%
%%
%% I. Representación de la imagen en el dominio transformado.
clear all, close all, clc
% Cargamos la imagen.
X = imread('triangulo.bmp');
figure,imshow(X)

% Realizamos la FFT de X
X_FFT = fftshift(fft2(double(X),256,256)); % Calcula la FFT de la imagen
FFT_modulo = abs(X_FFT); % Calcula el modulo del resultado de la FFT
FFT_fase = angle(X_FFT); % Calcula la fase del resultado de la FFT

% Visualizamos la fase y el módulo con el comando mesh (permite representar
% en 3D variables que sean del tipo double).
figure,mesh(FFT_modulo)
figure,mesh(FFT_fase)
% Para poder visualizar el modulo con el comando imshow, debemos calcular
% el: log10(1+modulo)
figure,subplot(1,2,1),imshow(log10(1+FFT_modulo),[]),title('modulo')
subplot(1,2,2),imshow(FFT_fase),title('fase')

% Calculo del valor asociado a la componente continua (altura de la delta
% amarilla dividida entre el numero de pixels)
Comp_Continua = 1851300/(256*256)

% Calculo del valor medio de la imagen utilizando el comando mean2
VM = mean2(X)

% Observamos que de ambas formas, a traves de la FFT o con el calculo
% directo del valor medio de la imagen, obtenemos el mismo valor. Esto
% ocurre porque...
%%
%% II. Propiedades de la Transformada de Fourier.
clear all, close all, clc

%% X de la imagen triangulo.bmp en el apartado I.
%% X de la imagen triangulodesp.bmp
clear all, close all, clc
% Cargamos la imagen.
X = imread('triangulodesp.bmp');

% Realizamos la FFT de X
X_FFT = fftshift(fft2(double(X),256,256)); % Calcula la FFT de la imagen
FFT_modulo = abs(X_FFT); % Calcula el modulo del resultado de la FFT
FFT_fase = angle(X_FFT); % Calcula la fase del resultado de la FFT

% Visualizamos la fase y el módulo con el comando mesh (permite representar
% en 3D variables que sean del tipo double).
figure,mesh(FFT_modulo)
figure,mesh(FFT_fase)
% Para poder visualizar el modulo con el comando imshow, debemos calcular
% el: log10(1+modulo)
figure,subplot(1,2,1),imshow(log10(1+FFT_modulo),[]),title('modulo')
subplot(1,2,2),imshow(FFT_fase),title('fase')
%% X de la imagen triangulozoom.bmp
clear all, close all, clc
% Cargamos la imagen.
X = imread('triangulozoom.bmp');

% Realizamos la FFT de X
X_FFT = fftshift(fft2(double(X),256,256)); % Calcula la FFT de la imagen
FFT_modulo = abs(X_FFT); % Calcula el modulo del resultado de la FFT
FFT_fase = angle(X_FFT); % Calcula la fase del resultado de la FFT

% Visualizamos la fase y el módulo con el comando mesh (permite representar
% en 3D variables que sean del tipo double).
figure,mesh(FFT_modulo)
figure,mesh(FFT_fase)
% Para poder visualizar el modulo con el comando imshow, debemos calcular
% el: log10(1+modulo)
figure,subplot(1,2,1),imshow(log10(1+FFT_modulo),[]),title('modulo')
subplot(1,2,2),imshow(FFT_fase),title('fase')
%% X de la imagen triangulogirado.desp
clear all, close all, clc
% Cargamos la imagen.
X = imread('triangulogirado.bmp');

% Realizamos la FFT de X
X_FFT = fftshift(fft2(double(X),256,256)); % Calcula la FFT de la imagen
FFT_modulo = abs(X_FFT); % Calcula el modulo del resultado de la FFT
FFT_fase = angle(X_FFT); % Calcula la fase del resultado de la FFT

% Visualizamos la fase y el módulo con el comando mesh (permite representar
% en 3D variables que sean del tipo double).
figure,mesh(FFT_modulo)
figure,mesh(FFT_fase)
% Para poder visualizar el modulo con el comando imshow, debemos calcular
% el: log10(1+modulo)
figure,subplot(1,2,1),imshow(log10(1+FFT_modulo),[]),title('modulo')
subplot(1,2,2),imshow(FFT_fase),title('fase')
%%
%% III. Filtrado Paso Bajo en el dominio frecuencial.
clear all, close all, clc

% Respuestas en frecuencia de un filtro paso bajo ideal del mismo tamaño
% que la imagen X y tres valores de D0: 50,30 y 10.
%% H1 -> D0=50
H1 = lpfilter('ideal',256,256,50);
%H1 = fftshift(H1);
FFT_moduloH1 = abs(H1); 
FFT_faseH1 = angle(H1);
figure,mesh(FFT_moduloH1)
figure,mesh(FFT_faseH1)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH1),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH1),title('fase')
%% H2 -> D0=30
H2 = lpfilter('ideal',256,256,30);
%H2 = fftshift(H2);
FFT_moduloH2 = abs(H2); 
FFT_faseH2 = angle(H2);
figure,mesh(FFT_moduloH2)
figure,mesh(FFT_faseH2)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH2),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH2),title('fase')
%% H3 -> D0=10
H3 = lpfilter('ideal',256,256,10);
%H3 = fftshift(H3);
FFT_moduloH3 = abs(H3); 
FFT_faseH3 = angle(H3);
figure,mesh(FFT_moduloH3)
figure,mesh(FFT_faseH3)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH3),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH3),title('fase')

% Respuestas en frecuencia de un filtro paso bajo gaussiano del mismo tamaño
% que la imagen X y tres valores de D0: 50,30 y 10.
%% H4 -> D0=50
H4 = lpfilter('gaussian',256,256,50);
%H4 = fftshift(H4);
FFT_moduloH4 = abs(H4); 
FFT_faseH4 = angle(H4);
figure,mesh(FFT_moduloH4)
figure,mesh(FFT_faseH4)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH4),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH4),title('fase')
%% H5 -> D0=30
H5 = lpfilter('gaussian',256,256,30);
%H5 = fftshift(H5);
FFT_moduloH5 = abs(H5); 
FFT_faseH5 = angle(H5);
figure,mesh(FFT_moduloH5)
figure,mesh(FFT_faseH5)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH5),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH5),title('fase')
%% H6 -> D0=10
H6 = lpfilter('gaussian',256,256,10);
%H6 = fftshift(H6);
FFT_moduloH6 = abs(H6); 
FFT_faseH6 = angle(H6);
figure,mesh(FFT_moduloH6)
figure,mesh(FFT_faseH6)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH6),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH6),title('fase')

%% Utilizando los filtros anteriores filtramos la imagen 'triangulo.bmp'.

X = imread('triangulo.bmp');
F = fft2(double(X));
%% Filtrado con H1
Filtrada_freq_1 = H1.*F;
Filtrada_espacio_1 = real(ifft2(Filtrada_freq_1));
figure,imshow(Filtrada_espacio_1,[])

%% Filtrado con H2
Filtrada_freq_2 = H2.*F;
Filtrada_espacio_2 = real(ifft2(Filtrada_freq_2));
figure,imshow(Filtrada_espacio_2,[])

%% Filtrado con H3
Filtrada_freq_3 = H3.*F;
Filtrada_espacio_3 = real(ifft2(Filtrada_freq_3));
figure,imshow(Filtrada_espacio_3,[])

%% Filtrado con H4
Filtrada_freq_4 = H4.*F;
Filtrada_espacio_4 = real(ifft2(Filtrada_freq_4));
figure,imshow(Filtrada_espacio_4,[])

%% Filtrado con H5
Filtrada_freq_5 = H5.*F;
Filtrada_espacio_5 = real(ifft2(Filtrada_freq_5));
figure,imshow(Filtrada_espacio_5,[])

%% Filtrado con H6
Filtrada_freq_6 = H6.*F;
Filtrada_espacio_6 = real(ifft2(Filtrada_freq_6));
figure,imshow(Filtrada_espacio_6,[])
%%
%% IV. Filtrado Paso Alto en el dominio frecuencial.
clear all, close all, clc

% Filtrado paso alto con el filtro ideal.
H1 = lpfilter('ideal',256,256,100);
H1 = 1-H1;
FFT_moduloH1 = abs(H1); 
FFT_faseH1 = angle(H1);
figure,mesh(FFT_moduloH1)
figure,mesh(FFT_faseH1)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH1),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH1),title('fase')

X = imread('triangulo.bmp');
F = fft2(double(X));
Filtrada_freq_1 = H1.*F;
FPA_ideal = abs(real(ifft2(Filtrada_freq_1)));
figure,imshow(FPA_ideal,[])

I_BW = im2bw(FPA_ideal, 1);
figure, imshow(I_BW),title('Imagen umbralizada')
% Filtrado paso alto con el filtro gaussiano.
H2 = lpfilter('gaussian',256,256,100);
H2 = 1-H2;
FFT_moduloH2 = abs(H2); 
FFT_faseH2 = angle(H2);
figure,mesh(FFT_moduloH2)
figure,mesh(FFT_faseH2)
figure,subplot(1,2,1),imshow(log10(1+FFT_moduloH2),[]),title('modulo')
subplot(1,2,2),imshow(FFT_faseH2),title('fase')

X = imread('triangulo.bmp');
F = fft2(double(X));
Filtrada_freq_2 = H2.*F;
FPA_gauss = abs(real(ifft2(Filtrada_freq_2)));
figure,imshow(FPA_gauss,[])




% Lo que sigue a esto no se como hacerlo.

