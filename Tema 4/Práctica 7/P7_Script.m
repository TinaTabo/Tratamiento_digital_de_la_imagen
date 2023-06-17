%%%%%%% PRÁCTICA 7 %%%%%%%
%% 

% I. Preprocesado.
clear all, close all, clc

I_celulas = imread('I_celulas.bmp');
figure, imshow(I_celulas), title('Imagen original')

% Filtramos la imagen aplicando un filtro alternado secuencial (ASF3)
% open-close con un EE plano -> disco.
% Disco radio 1.
EE1 = strel('disk',1);
Apertura1 = imopen(I_celulas, EE1);
I_ASF1 = imclose(Apertura1, EE1);
figure, imshow(I_ASF1), title('ASF1')

% Disco radio 2.
EE2 = strel('disk',2);
Apertura2 = imopen(I_celulas, EE2);
I_ASF2 = imclose(Apertura2, EE2);
figure, imshow(I_ASF2), title('ASF2')

% Disco radio 3.
EE3 = strel('disk',3);
Apertura3 = imopen(I_celulas, EE3);
I_ASF3 = imclose(Apertura3, EE3);
figure, imshow(I_ASF3), title('ASF3')


% II. Segmentación por watershed.

% Apartado A.
% Creamos el negativo de I_ASF3.
I_neg = imcomplement(I_ASF3);
figure, imshow(I_neg), title('I negativo')

% Erosionamos la I_neg con el EE disco de radio 9.
EE = strel('disk',9);
I_marker = imerode(I_neg, EE);
figure, imshow(I_marker), title('marcador')

% Reconstruimos utilizando como marcador la erosion y como segundo parámetro el
% negativo.
I_rec = imreconstruct(I_marker, I_neg);
figure, imshow(I_rec), title('reconstruida')

% obtenemos la img binaria donde los pixeles de primer plano indiquen los
% máximos regionales de I_rec.
I_max_reg = imregionalmax(I_rec);
figure, imshow(I_max_reg), title('maximos regionales')

% Debemos deshacernos de los maximos que no nos interesan porque no
% pertenecen a las celulas.
I_max_reg2 = imclearborder(I_max_reg);
figure, imshow(I_max_reg2), title('bordes limpios')

% Como aun sigue habiendo maximos que no nos interesan, debemos deshacernos
% de ellas. 
I_max_reg3=I_max_reg2;
% Capa de etiquetas
cc = bwlabel(I_max_reg2);
imtool(cc,[])
n_objetos = max(max(cc(:)))
% Nos da el nivel media de intensidad de cada etiqueta.
stats = regionprops(cc, I_celulas, 'MeanIntensity');
% Recorremos todos los objetos y le digo q si la intensidad media del objeto es
% mayor o igual que 150 lo elimino ya que no será una celula.
for nob=1:n_objetos
if stats(nob).MeanIntensity >= 150
[r,c] = find(cc == nob);
I_max_reg3(r,c)=0;
end
end % for nob

figure, imshow(I_max_reg3), title('objetos no interes eliminados')

% Apartado B.
% 7 no es el mejor tamaño del EE porque algunas celulas me las coje juntas.
% Queda mejor con 5.
I_dilate = imdilate(logical(I_max_reg3),strel('disk',7));
D = bwdist(I_dilate);
DL = watershed(D);
bgm = (DL == 0);
figure, imshow(I_dilate), title('dilatacion')
figure, mesh(I_dilate)
figure, imshow(D,[]), title('transformacion distancia')
figure, imshow(DL,[]), title('watershed')
figure, imshow(bgm,[]), title('lineas de watershed')
figure, imshow(imadd(255*uint8(bgm),I_celulas)), title('lineas de watershed sobre original')

% Apartado C.
I_minimos = bgm | I_max_reg3;
figure, imshow(I_minimos,[]), title('minimos')

% Apartado D.
%Creo el filtro de sobel
H = fspecial('sobel');
Htranspose = H.'; % Hago la transpuesta
FilterH = imfilter(double(I_celulas),H); %Hago el filtrado
FilterHtranspose =imfilter(double(I_celulas),Htranspose);
%Calculamos el modulo del gradiente
I_celulas_grad=sqrt(FilterH.^2+FilterHtranspose.^2);
figure, imshow(I_celulas_grad,[]), title('Modulo del gradiente');

% Apartado E.
I_celulas_grad_mrk = imimposemin(I_celulas_grad, I_minimos);
figure, imshow(I_celulas_grad_mrk), title('grad mrk')

% Apartado F.
L = watershed(I_celulas_grad_mrk);
L_frontera = (L == 0);
figure, imshow(L_frontera), title('segmentación watershed')

% Apartado G.
figure, imshow(imadd(255*uint8(L_frontera), I_celulas)), title('RESULTADO FINAL')



