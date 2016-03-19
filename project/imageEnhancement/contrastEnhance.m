function [dstImage] = contrastEnhance (srcImage, enhancementVal)
    cast(enhancementVal, 'double');
    correctionFactor = 259 * (enhancementVal + 255) / 255 / (259 - enhancementVal);

    cast(srcImage, 'double');
    correctionFactor
    size(srcImage)
    srcImage(1,1:10, 1)
    dstImage = correctionFactor .* (srcImage - 128) + 128;
    dstImage(1,1:10, 1)
    7.8328 * (89 - 128) + 128
    cast(dstImage, 'uint8');
endfunction
