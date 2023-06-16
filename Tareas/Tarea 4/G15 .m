% Integrante-1: Ana Poveda García Herrero
% Integrante-2: Cristina Taboada Mayo.
%% -------------------- PARTE OBLIGATORIA--------------------
clear all, close all, clc

% Cargo la imagen
Img = imread('G15.jpeg');
figure, imshow(Img), title('Imagen original');
figure, imhist(Img), title('Imagen original');

% Visualizamos las componentes RGB de la img.
R = Img(:,:,1);
G = Img(:,:,2);
B = Img(:,:,3);
figure, subplot(1,3,1), imshow(R), title('Componente Roja')
subplot(1,3,2), imshow(G), title('Componente Verde')
subplot(1,3,3), imshow(B), title('Componente Azul')

% Ninguna de ellas es mas relevante que la otra, por lo que sera dificil
% utilizar una de ellas como capa de segmentación y obtener el objeto balón.

% Cambiamos la imagen al espacio HSI.
[H,S,I] = rgb2hsi(Img);
figure, subplot(1,3,1), imshow(H), title('Componente H')
subplot(1,3,2), imshow(S), title('Componente S')
subplot(1,3,3), imshow(I), title('Componente I')

% Rango de variación -> lo sabemos visualizando el histograma de cada una.
figure, imhist(H), axis('auto'), title('Histograma Componente H')
figure, imhist(S), axis('auto'), title('Histograma Componente S')
figure, imhist(I), axis('auto'), title('Histograma Componente I')

% Vemos que el rango dinamico esta comprendido entre 0 y 1.

% Escogemos la componente H, ya que destaca más el balon
Componente = H;

% Comprobamos que los valores mas altos, en su mayoria pertenecen al balón.
% Pasamos la imagen correspondiente a la componente H por un filtro paso
% bajo.

% Definimos la máscara y sus coeficientes. 
h = 1/49*ones(7,7);
% Aplicamos el filtro.
H_FPB = imfilter(Componente,h);
figure, imshow(H_FPB), title('Componente H suavizada')
figure, imhist(H_FPB), title('Histograma H suavizada')
figure, mesh(H_FPB), title('H suavizada')


% II. Umbralización y filtrado.

% Visualizamos el histograma de la componente H.
figure, imhist(H_FPB), axis('auto'), title('Histograma Componente H')

% Primero, pasamos a la imagen de la componente H a blanco y negro usando
% segmentación binaria por umbralización.
H_U = im2bw(H_FPB,0.8);
H_U = uint8(H_U*255);
figure, imshow(H_U), title('Img. umbralizada (Componente H) en uint8')


% III. Aplicación de operadores morfológicos.
close all
% Creamos el elemento estructurante.
EE_cuadrado = strel('square', 35);

% Erosión.
Erosion = imerode(H_U, EE_cuadrado);
figure, imshow(Erosion), title('Erosión')

% Dilatación.
Dilatacion = imdilate(H_U, EE_cuadrado);
figure, imshow(Dilatacion), title('Dilatacion')

% Apertura.
Apertura = imopen(H_U, EE_cuadrado);
figure, imshow(Apertura), title('Apertura')

% Cierre.
Cierre = imclose(H_U, EE_cuadrado);
figure, imshow(Cierre), title('Cierre')


% IV. Segmentación y caracterización de objetos.

% Utilizaremos la APERTURA para hacer la segmentación, ya que es donde mejor
% se observa el balon

% Para poder quedarnos el balon en primer plano, hacemos el negativo
% de la imagen apertura.
Negativo_Apertura = 255 - Apertura;
figure, imshow(Negativo_Apertura), title('Negativo del Apertura')

% Vamos a obtener la capa de etiquetas( bwlabel utiliza vecindad a 8)
[IM_Seg,n] = bwlabel(Negativo_Apertura);
figure, imshow(IM_Seg), title('Capa de etiquetas')

% Pasamos la capa de etiquetas a RGB y la pintamos.
RGB_Segment = label2rgb(IM_Seg);
figure, imshow(RGB_Segment), title('Capa de etiquetas en falso color')
% Ahora si obtenemos el balon y no coge el fondo.

% Obtenemos el numero de objetos.
Num_objetos = max(IM_Seg(:));

% Calculamos el tamaño de los objetos.
imtool(IM_Seg,[])
Props = regionprops(IM_Seg, 'Eccentricity');
% Ver el valor del primer objeto.
Props(1).Eccentricity

% Obtenemos las fronteras
% Primero definimos el EE(forma y tamaño).
EE_disco = strel('disk', 9); % Mas grande el tamaño, más se marca

% Aplicamos Dilatacion con el EE.
Dilatacion = imdilate(Negativo_Apertura, EE_disco);
figure, imshow(Dilatacion), title('Dilatacion')

% Aplicamos Erosion con el EE
Erosion = imerode(Negativo_Apertura, EE_disco);
figure, imshow(Erosion), title('Erosión')

% Calculamos el gradiente.
Gradiente = Dilatacion - Erosion;
figure, imshow(Gradiente), title('Gradiente')

% Mapa del gradiente.
Gradiente_map = [0 0 0; 255 0 0];
Gradiente_Rojo = ind2rgb(Gradiente, Gradiente_map);
figure, imshow(Gradiente_Rojo), title('Img. Gradiente Rojo')

% Vemos la marcación del balon sobre la imagen original sumando ambas
% imagenes.
I_Gradiente = uint8(Gradiente_Rojo) + Img;
figure, subplot(1, 2, 1),imshow(Img), title('Imagen original')
subplot(1, 2, 2),imshow(I_Gradiente), title('Imagen segmentada')


%% -------------------- PARTE CREATIVA --------------------
clear all, close all, clc

%Cargo la imagen
Img = imread('G15.jpeg');
figure, imshow(Img), title('Imagen Original');
figure, imhist(Img), title('Imagen Original');

% 1.Preprocesado
% Pasamos a nivel de gris
Img = rgb2gray(Img);
figure, imshow(Img), title('Imagen gris');
figure, imhist(Img), title('Imagen gris');

%Recortamos la imagen
Img = Img(350:800, 350:850, :);
figure, imshow(Img), title('Imagen recortada')

% Hacemos el filtro con radio 1
% Creamos el elemento estructurante.
EE1 = strel('disk', 1);

% Apertura.
Apertura1 = imopen(Img, EE1);
figure, imshow(Apertura1), title('Apertura')

% Cierre.
I_ASF1 = imclose(Apertura1, EE1);
figure, imshow(I_ASF1), title('ASF1')

% Hacemos el filtro con radio 2
EE2 = strel('disk', 2);

% Apertura.
Apertura2 = imopen(I_ASF1, EE2);
figure, imshow(Apertura2), title('Apertura')

% Cierre.
I_ASF2 = imclose(Apertura2, EE2);
figure, imshow(I_ASF2), title('ASF2')

% Hacemos el filtro con radio 20
EE3 = strel('disk', 20);

% Apertura.
Apertura3 = imopen(I_ASF2, EE3);
figure, imshow(Apertura3), title('Apertura')

% Cierre.
I_ASF3 = imclose(Apertura3, EE3);
figure, imshow(I_ASF3), title('ASF3')


% 2.Segmentación por watershed
% a. Obtención de los marcadores de los objetos de interés

% Hago el negativo 
I_neg = imcomplement(I_ASF3);
figure, imshow(I_neg), title('Negativo del filtro')

%Erosionamos el negativo con un un EE_disco con disco 9
% Creamos el elemento estructurante.
EE_disco = strel('disk', 9);

% Erosión.
I_marker = imerode(I_neg, EE_disco);
figure, imshow(I_marker), title('I_marker')

%Reconstruccion morfologica
I_rec = imreconstruct(I_marker, I_neg);
figure, imshow(I_rec), title('Reconstruccion')

%Imagen binaria con los maximos regionales
I_max_reg = imregionalmax(I_rec);
figure, imshow(I_max_reg), title('Máximos regionales');

%Eliminamos los máximos que no zonas de interés
I_max_reg2 = imclearborder(I_max_reg);
figure, imshow(I_max_reg2), title('Máximos regionales buenos');
figure, imtool(I_max_reg2), title('tool maximos regionales');

% Visualizamos la capa de etiquetas en falso color. Blanco en matlab es la etiqueta 0 que
% veíamos en negro en los apuntes.
RGB_I_max_reg2= label2rgb(I_max_reg2);
imtool(RGB_I_max_reg2), title('Capa de etiquetas en falso color')

% Calculamos el tamaño de los objetos.
[I_max_reg3, Nobjetos] = bwlabel(I_max_reg2);
Props = regionprops(I_max_reg3, 'Area');
V_Area = [];
for ind_obj = 1:Nobjetos
    V_Area = [V_Area Props(ind_obj).Area];
end
figure,stem(V_Area)
xlabel('Número de objeto'), ylabel('Tamaño')

% Identificamos que la etiquetas de interes son
V_Interes = [2, 4, 5, 7];

% Bucle que filtra de la imagen binaria I_U las regiones de no interés.
[n_filas, n_cols] = size(I_rec); % nos dice el numero de filas y columnas que tiene la imagen.

% recorre todas las filas de la imagen
for ind_nfila=1:n_filas 
    % recorre todas las columnas de la imagen
    for ind_ncol=1:n_cols 
        % Accedemos a la posicion de la matriz de la imagen B/N si en la posición indicada tenemos un pixel de primer plano.
        if I_rec(ind_nfila, ind_ncol) 
            % busco si la etiqueta de ese pixel es una de las etiquetas de interes que hemos definido antes.
            numero_et = I_max_reg3(ind_nfila, ind_ncol); 
            % si el pixel pertenece a la region de interes, ismember nos
            % devuelve un valor mayor > 0. Concretamente nos devuelve el
            % valor en binario del numero de la etiqueta que pertenece a mis V_Interes.
            if sum(ismember(V_Interes, numero_et)) == 0 
                % Si se cumple la condición, borramos el pixel en cuestión,
                % y lo convertimos en un pixel de fondo. Es decir,
                % eliminamos la etiqueta que identifica ese pixel como un
                % objeto y le asignamos la etiqueta de fondo.
                I_rec(ind_nfila, ind_ncol) = 0;
            end
        end
    end
end
figure, imshow(I_rec),title('zona de interes')

% b. Obtención del marcador externo
I_max_reg3 = I_rec;
%Aqui con dilatacion, intentamos que los marcadores externos no correspondan a
%zonas de interes
% Me dilata la imagen anterior con un EE de disco de radio 7
I_dilate = imdilate(logical(I_max_reg3),strel('disk',7)); 
%Nos calcula la distacia euclidea de la imagen binaria. 
%Distancia de ese pixel a un pixel = 0 mas cercano
D = bwdist(I_dilate); 
DL = watershed(D); % Calculamos whatershef
bgm = (DL == 0); % Nos va a aplicar las lineas de watershed

%Visualizamos la dilatacion 
figure, imshow(I_dilate), title('Imagen dilatada');
figure, mesh(I_dilate), title('Imagen dilatada');
%Visualizamos watershed
figure, imshow(DL), title('Watershed');
figure, mesh(DL), title('Watershed');
%Visualizamos las lineas de watershed
figure, imshow(imadd(255*uint8(bgm),Img)), title('Lineas de watershed');

% c. Combinacion de marcadores internos con externos

%Combinamos ambos marcadores
I_minimos = bgm | I_max_reg3;
figure, imshow(I_minimos), title('Combinacion de minimos y maximos');

% d. Modulo del gradiente de la imagen

%Creo el filtro de sobel
H = fspecial('sobel');
Htranspose = H.'; % Hago la transpuesta
FilterH = imfilter(double(Img),H); %Hago el filtrado
FilterHtranspose =imfilter(double(Img),Htranspose);
%Calculamos el modulo del gradiente
Img_grad=sqrt(FilterH.^2+FilterHtranspose.^2);
figure, imshow(Img_grad, []), title('Modulo del gradiente');

% e. Evitar la sobresegmentación

% Nos va a ayudar a imponer minimos
Img_grad_mrk = imimposemin(Img_grad, I_minimos);
figure, imshow(Img_grad_mrk), title('Imposicion de minimos');

% f. Aplicar watershed

L_frontera = watershed(Img_grad_mrk);
bgm = (L_frontera == 0);
figure, imshow(bgm), title('Segmentación por watershed');

% g. Imagen frontera

%Visualizamos las lineas de watershed
figure, subplot(1,2,1), imshow(Img), title('Imagen Original');
subplot(1,2,2), imshow(imadd(255*uint8(bgm),Img)), title('RESULTADO FINAL');




