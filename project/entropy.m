function entro = entropy(im)
    entro = sum(sum(im.*log(im)));
endfunction