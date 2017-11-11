%% VARIABLES
close all
clear all
global fig;
global display;
global paused;
global face;
global algorithm;
global tony_n;
global tony_y;
fig = 1;
display = true;
paused = false;
face = input('what face would you use? (01 o 51) ');
algorithm = input('what algorithm? 1) wiener 2)  tikhonov 3) Lucy 4) TonyLucy ');
iterations = input('how many iterations do you want to do? Recommended: wiener 300, tikhonov 500 Lucy 20 TonyLucy 20 ');


if(face == 1)
    face = '01';
    tony_n = [3 5 7 11 13];
    tony_y = [1.5 2.7 3 2.5 2.7];
else
    face = '51';
    tony_n = [3 5 7 11 13];
    tony_y = [1.5 2.4 2.9 2.4 2.6];
end

sizes = [7 19 31 43 55];
path = concat3('images/face_0', face, '_C0.png');
O = im2double(imread(path)); % original
for i = 1:5
    s = sizes(i);
    PSF = gauss(i, s);
    
    %% MAIN    
    figure;
    title("Degradacion de: " + s);
    %     show(O, 'Original');
    subplot(1,4,1);
    imshow(O, []);
    title("Original");
    
    f = getImage(i);
    %     show(f, "Gauss tamano: " + s);
    subplot(1,4,2);
    imshow(f, []);
    err = mean(abs(f(:)-O(:)));
    title("Degradada: " + err);
    %% DEBLUR
    Y = [];
    X = [];
    for j = 1:iterations
        
        W = deblur(f, PSF, noise(j), i);
        err = mean(abs(W(:)-O(:)));
        Y = cat(2, Y, (err));
        X = cat(2, X, (noise(j)));
    end
    
    [m, index] = min(Y);
    disp("PARA i = " + i);
    disp("EL MIN FUE " + m + " EN LA POS " + index);
    W = deblur(f, PSF, X(index), i);
    err = mean(abs(W(:)-O(:)));
    
    subplot(1,4,3);
    
    imshow(W, []);
    title("Restaurada: " +  err);
    subplot(1, 4, 4);
    plot(X, Y);
    title("Min: " + noise(index));
end




%% FUNCTIONS

function n = noise(j)
global algorithm
if( algorithm == 1)
n = j/(100000);
elseif(algorithm == 2)
    n = 0.1 * (j);
elseif(algorithm == 3)
    n = j;
elseif(algorithm == 4)
    n = j;
end
end

function G = getImage(i)
global face;
path = concat5('images/face_0', face, '_G', num2str(i), '.png');
B = im2double((imread(path)));
G = B;
end


function I = inverse(f, PSF)
I = wiener(f, PSF, 0);
end

function W = deblur(f, PSF, param, k)
global algorithm;
global tony_n;
global tony_y;
if(algorithm == 1)
    W = wiener(f,PSF,param);
elseif (algorithm == 2)
    W = tikhonov(f,PSF,param);
elseif (algorithm == 3)
    W = lucy(f,PSF,param);
elseif (algorithm == 4)
    W = TonyLucy(f,PSF, tony_n(k), tony_y(k), param);
else
    W = inverse(f,PSF);
end

end

function W =  wiener(f, PSF, noise_var)
nsr = noise_var / var(f(:));
W =deconvwnr(f, PSF, nsr);
end

function T = tikhonov(f, PSF, y)
T = deconvreg(f, PSF, y);
end

function L =  lucy(f, PSF, num_iteration)
L = deconvlucy(f, PSF, num_iteration);
end

function B = blind(f, PSF, param)
B = deconvblind(f, PSF, param);
end

function str = concat3(s1, s2, s3)
str = strcat(s1, s2);
str = strcat(str, s3);
end

function str = concat5(s1, s2, s3, s4, s5)
str1 = concat3(s1, s2, s3);
str2 = strcat(s4, s5);
str = strcat(str1, str2);
end

