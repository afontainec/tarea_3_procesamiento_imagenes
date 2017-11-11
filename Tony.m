function W = Tony(I, PSF, n, y)
    %% SHARPEN
    F = conv2(I,ones(n,n)/n^2,'same');
    J = I + y*(I-F);
    W = J;
    W(J>1) = 1;
end