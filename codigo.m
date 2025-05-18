% ---------------------------------------------------------
% LECTURA Y PREPROCESAMIENTO DE LA IMAGEN
% ---------------------------------------------------------

% Leer cualquier imagen de entrada
img_original = imread('foto.jpg');  

% Convertimos a una escala de grises si la imagen es a color
if size(img_original, 3) == 3
    img_gray = rgb2gray(img_original);
else
    img_gray = img_original;
end

% Guardar como BMP para tener mas precision para el filtrado
imwrite(img_gray, 'imagen.bmp');

% Leemos la imagen BMP y convertir a tipo double para los calculos 
img = imread('imagen.bmp');
img_gray = double(img);

% ---------------------------------------------------------
% CONSTRUCCIoN DEL FILTRO GAUSSIANO (convolucion discreta)
% ---------------------------------------------------------

% Parametros del filtro
sigma = 1;               % Controla que tanto se suaviza la imagen
kernel_size = 5;         % Tamaño del nucleo (debe ser impar)
k = floor(kernel_size / 2);  % Radio del filtro

% Generar la malla 2D para crear el núcleo gaussiano
[x, y] = meshgrid(-k:k, -k:k);

% Funcion gaussiana 2D (simula la respuesta al impulso del sistema LTI)
gaussian_kernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
gaussian_kernel = gaussian_kernel / sum(gaussian_kernel(:));  % Normalizamos

% ---------------------------------------------------------
% SIMULACION DE RUIDO ALEATORIO (tipo sal y pimienta) PAR TENER UNA MEJOR VISUALIZACION DEL FILTRO GAUSSIANO
% ---------------------------------------------------------

% Definimos la probabilidad de insertar ruido
probabilidad_ruido = 0.05;
img_noisy = img_gray;

% Insertamos ruido aleatorio pixel a pixel 
for i = 1:size(img_gray, 1)
    for j = 1:size(img_gray, 2)
        if rand < probabilidad_ruido
            img_noisy(i, j) = randi([0, 255]);
        end
    end
end

% ---------------------------------------------------------
% Se realiaza el Filtrado Gaussiano
% ---------------------------------------------------------

[rows, cols] = size(img_gray);
img_filtered = zeros(rows, cols);  % Inicializamos imagen de salida

% Aplicamos la convolucion 2D 
for i = 1 + k : rows - k
    for j = 1 + k : cols - k
        region = img_noisy(i - k:i + k, j - k:j + k);  % Vecindad local
        img_filtered(i, j) = sum(sum(region .* gaussian_kernel));  % Hacemos la convolucion
    end
end

% Convertimos el resultado a tipo uint8 para mostrar en pantalla
img_filtered_uint8 = uint8(img_filtered);

% ---------------------------------------------------------
% Resultados
% ---------------------------------------------------------

figure;

% Imagen original
subplot(1, 3, 1);
imshow(uint8(img_gray));
title('Original', 'FontSize', 6);

% Imagen con ruido
subplot(1, 3, 2);
imshow(uint8(img_noisy));
title('Con Ruido Aleatorio', 'FontSize', 6);

% Imagen filtrada (respuesta del sistema al ruido)
subplot(1, 3, 3);
imshow(uint8(img_filtered));
title('Filtrada (Convolución Gaussiana)', 'FontSize', 6);


