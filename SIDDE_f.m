clc;
clear;

img = double(imread('.\pavement.jpg')); 
sizeI = size(img);

A0 = max(img(:));
Anew = [A0,A0,A0];

A = [0,0,0];
ik = 0;

a1 = 0.001; a2 =0.1; lambda = 2;de = 0.5;     % set parameters
epsilon_stop = 1e-3; 

B = zeros(sizeI);  
D0 = zeros(sizeI);

while norm(Anew-A)/(norm(A)+eps) > 1e-3 && ik <5
    A=Anew;
    ik=ik+1;
    
    for i = 1:3
        B(:,:,i) = log((1-img(:,:,i)/A(i))*255+1);
        D0(:,:,i) = A(i)+20-img(:,:,i);
    end
    D = log(max(D0,[],3)+1);
    
    tic
    [ C, D, epsilon_C, epsilon_D ] = iter_f(B, a1, a2, lambda, epsilon_stop,D,de);
    toc
    
    t = exp(D);
    t = t/max(t(:));

    Air=atmLight(img,1-t);
    Anew = A0/min(Air)*Air;
end

albedo = 1-exp(C);
adj_percent = [0.001, 0.999];
albedo = adjust(albedo,adj_percent);

atmlight = zeros(100,100,3);
for i=1:3
    atmlight(:,:,i)= Air(i)/255;
end

out2 = img;
for i=1:3
    out2(:,:,i) = 1-exp(C(:,:,i)).*t.^0.3;
end

% adj_percent = [0.001, 0.999];
img_dehazed = adjust(out2,adj_percent);

figure;
subplot 231, imshow(uint8(img)), title('hazy input');
subplot 232, imshow(atmlight), title('airlight');
subplot 233, imshow(t),colormap jet,title('transmission');
subplot 234, imshow(albedo),title('albedo');
subplot 235, imshow(img_dehazed),title('dehazed');

