function [dstImage] = contrastEnhance (srcImage, enhancementVal)
    cast(enhancementVal, 'double');
    srcImage = cast(srcImage, 'double');

    correctionFactor = 259 * (enhancementVal + 255) / 255 / (259 - enhancementVal);
    dstImage = correctionFactor .* (srcImage - 128) + 128;
    dstImage = cast(dstImage, 'uint8');
%endfunction
