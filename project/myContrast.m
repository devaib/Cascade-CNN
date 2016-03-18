function contra = myContrast(im)
    summ = 0;
    for i = 1 : size(im, 1)
        for j = 1 : size(im, 2)
            summ = summ + (i-j).^2 * im(i, j);
        end
    end
    contra = summ
endfunction
