close all
%{
%brightness interpolation
f=1.5;
I=double(imread('peppers.png'));
figure
imshow(I/255+.5)
%expensive rgb->Lab, f*L->L, Lab->RGB.
I=rgb2lab(I);
I(:,:,1)=I(:,:,1)*f;
I=uint8(lab2rgb(I));
figure
imshow(double(I)/255+.5)

%brightness interp is better faster.
%}
% interpolation of equalized image vs oiginal im
%{
I=imread('pout.tif');
J=histeq(I);
a=(-2:.1:2);
I=double(I)/255;
J=double(J)/255;
Gm=ones(size(I))*mean(mean(I));
figure
for i=1:length(a)
    a(i)
    subplot(1,3,1)
   imshow(J*(1-a(i))+a(i)*I)
   subplot(1,3,2)
   imshow(I*(1-a(i))+a(i)*Gm)
   subplot(1,3,3)
   imshow(I)
drawnow
end
%}

%%

a=(1:-.01:-2);
I=double(imread('peppers.png'))/255;
G=rgb2gray(I);
Gm=ones(size(I))*mean(mean(G));
G=repmat(G,1,1,3);

%% Saturation
figure
for i=1:length(a)
   imshow(I*(1-a(i))+a(i)*G)
drawnow
a(i)
end
%% Contrast
figure
for i=1:length(a)
   imshow(I*(1-a(i))+a(i)*Gm)
drawnow
end


%%
%{
figure
for i=1:100
    %{
    u=rand+1/2;
    v=rand+1/2;
    w=rand+1/2;
    %}
    u=(round(2*rand)-1)/2+1;
    v=(round(2*rand)-1)/2+1;
    w=(round(2*rand)-1)/2+1;
   imshow(I*(u+v+w)/3+u*Gm/3+v*G/3)
drawnow
end
%}