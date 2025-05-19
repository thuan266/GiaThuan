
% Ask user to select an image file
[filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif'}, 'Select an image file');
if isequal(filename,0)
    disp('No file selected');
    return;
end

% Read the image
image = imread(fullfile(pathname, filename));

% Convert to grayscale
if size(image,3) == 3
    image_gray = rgb2gray(image);
else
    image_gray = image;
end
image_gray = im2double(image_gray);

% Show original image
figure;
subplot(1,2,1);
imshow(image);
title('Original Image');

% Get compression factor from user
k = input('Enter compression factor k: ');

% Checking the "k" value if it is invalid 
if k < 1 || k > min(size(image_gray))
    disp(['Invalid value of k. It should be between 1 and ', num2str(min(size(image_gray)))]);
    return;
end

% Call the local function to compress image
compressed_image = compress_image_svd(image_gray, k);

% Show compressed image
subplot(1,2,2);
imshow(compressed_image);
title(['k = ' num2str(k) '']);

% --- Local function definition at the end of the file ---
function compressed_image = compress_image_svd(image, k)
    [U,S,V] = svd(image, 'econ');
    U_k = U(:,1:k);
    S_k = S(1:k,1:k);
    V_k = V(:,1:k);
    compressed_image = U_k * S_k * V_k';
end

