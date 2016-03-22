function simplestColorBalance(filename,outFile,satLevel,plots)
% simplestColorBalance(filename,outFile,satLevel,plot)
% Performs color balancing via histogram normalization.
% satLevel controls the percentage of pixels to clip to white and black.
% Set plot = 0 or 1 to turn diagnostic plots on or off.


%% import image
im_orig = imread(filename);
figure
imshow(im_orig)
title('Original Image')


%% full width histogram method
% satLevel = .01; %percentage of the image to saturate to black or white, tweakable param
q = [satLevel/2 1-satLevel/2];

imRGB_orig = reshape(im_orig, size(im_orig, 3), size(im_orig, 1) * size(im_orig, 2), 1);
size(im_orig)
size(imRGB_orig)
imRGB = zeros(size(imRGB_orig));
N = size(imRGB_orig,2);
color = {'r','g','b'};
for ch = 1:3
    if plots
        figure
        subplot(2, 1, 1)
        hist(imRGB_orig(ch,:),256)
        set(findobj(gca, 'Type', 'patch'), 'FaceColor', color{ch}, 'EdgeColor', color{ch})
        xlim([0 255])
        title('Original Histogram')
    end
    tiles = quantile(imRGB_orig(ch,:),q)
    %[sum(imRGB_orig(ch,:)<tiles(1))/N,sum(imRGB_orig(ch,:)>tiles(2))/N] %check percentages are correct
    %imRGB(ch,:) = saturate(imRGB_orig(ch,:),tiles); %saturate at the appropriate pts. in distribution
    imRGB(ch, :) = min(tiles(2), imRGB(ch, :));
    imRGB(ch, :) = max(tiles(1), imRGB(ch, :));
    bottom = min(imRGB(ch,:)); top = max(imRGB(ch,:));
    imRGB(ch,:) = (imRGB(ch,:)-bottom)/(top-bottom);
    
    if plots
        subplot(2, 1, 2)
        hist(imRGB(ch,:),256)
        set(findobj(gca,'Type','patch'),'FaceColor',color{ch},'EdgeColor',color{ch})
        xlim([0 255])
        title('Corrected Histogram')
    end
    print(gcf,'-dpng',[outFile '-fig' num2str(ch)])
end

imwrite(reshape(imRGB,size(im_orig)), outFile,'png');
figure
imshow(reshape(imRGB,size(im_orig)))
title('Simplest Color Balance Corrected')

endfunction
