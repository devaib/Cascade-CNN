function [dstImage] = brightnessEnhance (srcImage, enhancementVal)
    cast(enhancementVal, 'double');
    srcImage = cast(srcImage, 'double');

    dstImage = srcImage + enhancementVal;
    dstImage = cast(dstImage, 'uint8');
endfunction
