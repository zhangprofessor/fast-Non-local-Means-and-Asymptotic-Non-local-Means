function  x0=load_test_image(timg)
% read test image



switch timg
    case 1
        x0=double(imread('Cameraman256.png'));
    case 2
        x0=double(imread('lena.png')); 
    case 3
        x0=double(imread('boat.png'));
    case 4
        x0=double(imread('fingerprint.tif'));
    case 5
        x0=double(imread('bfly.tif'));
    case 6
        x0=double(imread('man.png'));
    case 7
        x0=double(imread('Baboon.png'));
    case 8
        x0=double(imread('straw.tif'));
    case 9
        x0=double(imread('barbara.png'));
    case 10
        x0=double(imread('montage.png'));
    case 11
        x0=double(imread('house.tif'));
    case 12
        x0=double(imread('hill.tif'));
    case 13
        x0=double(imread('couple.png'));
    case 14
        x0=double(imread('peppers256.png'));
        
end