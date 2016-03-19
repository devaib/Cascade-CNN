function homo = homogeneity(im)
    summ = 0;
    for i = 1 : size(im, 1)
        for j = 1 : size(im, 2)
            summ = summ + double(im(i, j)) / (1 + abs(i-j));
        end
    end
    homo = summ;
