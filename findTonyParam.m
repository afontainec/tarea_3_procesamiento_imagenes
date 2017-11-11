%% VARIABLES
close all
global fig;
global display;
global paused;
global face;
global algorithm;

fig = 1;
display = true;
paused = false;
face = input('what face would you use? (01 o 51) ');
iterations = input('how many iterations do you want to do? Recommended: 20 ');


if(face == 1)
    face = '01';
else
    face = '51';
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
    K = [];
    for j = 1:iterations
        Errors = [];
        for k = 1:iterations
            W = Tony(f, PSF, j, noise(k));
            err = mean(abs(W(:)-O(:)));
            Errors = cat(2, Errors, (err));
        end
        [min_err, min_k] = min(Errors);
        Y = cat(2, Y, (min_err));
        X = cat(2, X, (j));
        K = cat(2, K, (min_k));
    end
    
    [m, index] = min(Y);
    disp("PARA i = " + i);
    disp("EL MIN FUE " + m + " EN LA POS " + index);
    W = Tony(f, PSF, X(index), noise(K(index)));
    err = mean(abs(W(:)-O(:)));
    
    subplot(1,4,3);
    
    imshow(W, []);
    title("Restaurada: " +  err);
    subplot(1, 4, 4);
    plot(X, Y);
    title("Min: " + X(index) + ":" + noise(K(index)));
end




%% FUNCTIONS

function n = noise(j)
    n = 1.1 + j/10;
end

function G = getImage(i)
global face;
path = concat5('images/face_0', face, '_G', num2str(i), '.png');
B = im2double((imread(path)));
G = B;
end

function W =  wiener(f, PSF, noise_var)
nsr = noise_var / var(f(:));
W =deconvwnr(f, PSF, nsr);
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

