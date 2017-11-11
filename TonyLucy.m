function W = TonyLucy(I, PSF, n, y, iterations)
    %% SHARPEN
    F = conv2(I,ones(n,n)/n^2,'same');
    J = I + y*(I-F);
    f = J;
    f(J>1) = 1;
    W = deconvlucy(f, PSF, iterations);

end