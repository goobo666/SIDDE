clc;
clear all;

name = 'canon';
img = double(imread(['D:\image enhance\haze images fattal\',name,'_input.png'])); 

sizeI = size(img);

A=getAtm(img);

a1 = 0.001; a2 =0.1; lambda = 2;de=0.5;     % set parameters
epsilon_stop = 1e-3; 

tic
[ C, D, epsilon_C, epsilon_D ] = iter_f(B, a1, a2, lambda, epsilon_stop,D,de);
toc

albedo = 1-exp(C);

t = exp(D);
figure,imshow(t1),colormap jet;
% saveas(gca,['D:\paper1\fattal_d\',name,'_transd_anis.png']);

out2 = img;


adj_percent = [0.005, 0.995];
img_dehazed = adjust(out2,adj_percent);
figure,imshow(img_dehazed);

