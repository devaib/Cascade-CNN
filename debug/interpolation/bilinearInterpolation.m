function [out] = bilinearInterpolation(im, outputDims_width_height)

    %// Get some necessary variables first
    input_rows = size(im,1);
    input_cols = size(im,2);
    output_cols = outputDims_width_height(1);
    output_rows = outputDims_width_height(2);

    %// Let S_R = R / R'        
    S_R = input_rows / output_rows;
    %// Let S_C = C / C'
    S_C = input_cols / output_cols;

    %// Define grid of co-ordinates in our image
    %// Generate (x,y) pairs for each point in our image
    [cf, rf] = meshgrid(1 : output_cols, 1 : output_rows);

    %// Let r_f = r'*S_R for r = 1,...,R'
    %// Let c_f = c'*S_C for c = 1,...,C'
    rf = rf * S_R;
    cf = cf * S_C;

    %// Let r = floor(rf) and c = floor(cf)
    r = floor(rf);
    c = floor(cf);

    %// Any values out of range, cap
    r(r < 1) = 1;
    c(c < 1) = 1;
    r(r > input_rows - 1) = input_rows - 1;
    c(c > input_cols - 1) = input_cols - 1;

    %// Let delta_R = rf - r and delta_C = cf - c
    delta_R = rf - r;
    delta_C = cf - c;

    %// Final line of algorithm
    %// Get column major indices for each point we wish
    %// to access
    in1_ind = sub2ind([input_rows, input_cols], r, c);
    in2_ind = sub2ind([input_rows, input_cols], r+1,c);
    in3_ind = sub2ind([input_rows, input_cols], r, c+1);
    in4_ind = sub2ind([input_rows, input_cols], r+1, c+1);       

    %// Now interpolate
    %// Go through each channel for the case of colour
    %// Create output image that is the same class as input
    out = zeros(output_rows, output_cols, size(im, 3));
    out = cast(out, 'like', im);

    for idx = 1 : size(im, 3)
        chan = double(im(:,:,idx)); %// Get i'th channel
        %// Interpolate the channel
        tmp = chan(in1_ind).*(1 - delta_R).*(1 - delta_C) + ...
                       chan(in2_ind).*(delta_R).*(1 - delta_C) + ...
                       chan(in3_ind).*(1 - delta_R).*(delta_C) + ...
                       chan(in4_ind).*(delta_R).*(delta_C);
        out(:,:,idx) = cast(tmp, 'like', im);
    end
endfunction