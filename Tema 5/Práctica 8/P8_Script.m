%%%%%%%%%% PRACTICA 8 %%%%%%%%%%
%% I. Manejo básico de vídeo en MATLAB
file_name = 'shopping_center.mpg';
my_movie= VideoReader(file_name);

% en esta practica nos vamos a centrar en cdata.
% crea una estructura de cdata sea una matriz de 0 con el tamaño de un
% frame del video y de tipo uint8.
s_movie = struct('cdata',zeros(my_movie.Height,my_movie.Width,3,'uint8'),'colormap',[]);
k = 1;
% repite esto mientras tenga frames.
while my_movie.hasFrame
s_movie(k).cdata = readFrame(my_movie);
k = k+1;
end
% Visualizamos el primer frame.
s_movie(1);
imshow(s_movie(1).cdata);

% NO FUNCIONA PARA LA VERSION DE 2019a
% Como ver un numero de frames determinado y no tener que ver uno por uno.
%frame_nums = [5 20];
%my_movie2 = readFrame(my_movie, frame_nums);

%Preasignar array de 4D que contendrá todos los frames
image_data=uint8(zeros(my_movie.Height,my_movie.Width,3,560));
% Se ve poco.
for k = 1:560
% tiene 4 dimensiones: alto, largo, profundidad(capas), numero de frames.
image_data(:,:,:,k) = s_movie(k).cdata;
end
montage(image_data)

% Lo hacemos con menos para verlo mejor.
for k = 1:10
image_data2(:,:,:,k) = s_movie(k).cdata;
end
montage(image_data2)

% Intentamos reproducir el video
implay(s_movie);
% Hacemos que se reproduzca mas lento
implay(s_movie,10);
% Hacemos que se reproduzca mas rapido.
implay(s_movie,100);

% Transformamos el frame 10 a una imagen.
old_img = frame2im(s_movie(10));

% Vamos a desenfocarla.
fn = fspecial('average',7);
new_img = imfilter(old_img, fn);

% Mostramos ambas imagenes.
figure,subplot(1,2,1), imshow(old_img), title('old img')
subplot(1,2,2), imshow(new_img), title('new img')

% Calculamos el negativo de la imagen
image_neg = imadjust(old_img, [0 1], [1 0]);
figure, imshow(image_neg)

% Vamos a guardar en frames la nueva imagen desenfocada y el negativo.
my_movie_new = s_movie;
new_frame10 = im2frame(new_img);
my_movie_new(10) = new_frame10;

new_frame5 = im2frame(image_neg);
my_movie_new(5) = new_frame5;

% Intentamos reproducir el video
implay(my_movie_new);
% Hacemos que se reproduzca mas lento
implay(my_movie_new,10);
% Hacemos que se reproduzca mas rapido.
implay(my_movie_new,100);

% Cree una estructura de vídeo a partir de una matriz de imágenes negativas 
% del vídeo original.
my_imgs = uint8(zeros(my_movie.Height,my_movie.Width,3, 560));
for i = 1:560
    old_img = frame2im(s_movie(i));
    image_neg = imadjust(old_img, [0 1], [1 0]);
    new_frame = im2frame(image_neg);
    my_movie_new(i) = new_frame;
    my_imgs(:,:,:,i) = my_movie_new(i).cdata;
end
% vemos todos los frames.
montage(my_imgs)
% Paso las imagenes a video.
new_movie = immovie(my_imgs);
% lo reproducimos con matlab.
implay(new_movie);
% Guardamos el video
file_name = 'new_video.avi';
v_new = VideoWriter(file_name);
open(v_new);
writeVideo(v_new,new_movie);
close(v_new);

%% II. Estimación de movimiento basada en bloques
% II.1 EBMA
%exhaustivo
% 115.7542 con [16,16];
% 71.5272 con [8,8];
% 173.6598 con [32,32];
anchorName = 'foreman69.Y';
targetName = 'foreman72.Y';
frameHeight = 352;
frameWidth = 288;
blockSize = [16,16];
% Si el tamaño del bloque es pequeño el error disminuye y el tiempo aumenta
% Si el tamaño del bloque es grande el error aumenta y el tiempo disminuye.

% Leemos los frames de referencia y objetivo.
fid = fopen(anchorName,'r');
anchorFrame = fread(fid,[frameHeight,frameWidth]);
anchorFrame = anchorFrame';
fclose(fid);
fid = fopen(targetName,'r');
targetFrame = fread(fid,[frameHeight,frameWidth]);
targetFrame = targetFrame';
fclose(fid);
% Las visualizamos.
figure, subplot(1,2,1), imshow(uint8(anchorFrame)), title('Anchor Frame')
subplot(1,2,2), imshow(uint8(targetFrame)), title('Target Frame')

% Con tic y toc sacamos el tiempo que tarda en procesar.
tic
% Esta funcion hace la estimacion de movimiento basada en bloques
% exaustivo. La funcion nos devuelve el frame predicho y los vectores de
% movimiento.
[predictedFrame, mv_d, mv_o] = ebma(targetFrame, anchorFrame, blockSize);
time_ebma = toc
figure, imshow(uint8(predictedFrame)), title('Predicted Frame')

figure, imshow(uint8(anchorFrame))
hold on
quiver(mv_o(1,:),mv_o(2,:),mv_d(1,:),mv_d(2,:)), title('Vectores de movimiento EBMA');
hold off

figure, imshow(uint8(predictedFrame))
hold on
quiver(mv_o(1,:),mv_o(2,:),mv_d(1,:),mv_d(2,:)), title('Vectores de movimiento EBMA');
hold off

errorFrame = imabsdiff(anchorFrame, predictedFrame);
MSE_ebma = mean(mean((errorFrame.^2)))

% II.2 HBMA
% gerarquico
% 80.9825 con [16,16];
% 155.7916 con [32,32];
blockSize = [16,16];
%numero de niveles L
L = 4;
% L=3, 154.4806 con [16,16];
tic
[predictedFrame,mv_d,mv_o]=hbma(targetFrame,anchorFrame,blockSize,L);
time_ebma = toc

errorFrame = imabsdiff(anchorFrame, predictedFrame);
MSE_ebma = mean(mean((errorFrame.^2)))

%Cambiando el tamaño de bloque a mas grande el error es mayor, el tiempo de
%procesado aumenta y el frame estimado es peor hace un efecto bloque muy
%grande. tiene menos vectores de movimiento
%con el nivel, al aumentar aumenta el error y disminuye el tiempo de prrocesado

% II.3 Phase Correlation Method
% 3 dimensiones: ancho, largo, frame de referencia o frame objetivo.
frame(:,:,1) = anchorFrame;
frame(:,:,2) = targetFrame;

% Ejecutar directamente por linea de comandos: PhaseCorrelation
