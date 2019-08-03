%====================================================
% demo
%==================================================
%---------------------------------------------------
% This is a comparision of three implemantations of nonlocal means filter
% (NLM) for image denoising. Matlab funciton "FNLM" ¡¢"ANLM"and "ANLM1"are our
% fast implementation by using convolution , and "NLmeansfilter" is the classical implementation.
%---------------------------------------------------


% Any problems and advises are welcome .
% Email:zhangxuande@sust.edu.cn  
% Date: 08-02-2019



%%
clear all;
path(path,'./image')
iptsetpref('ImshowBorder','tight');
% load test image
timg=2;   %1 3 4 5 6 7 8 9 10 11 12 13 14
x0=load_test_image(timg);
figure(1), imshow(x0,[])
% add noise
randn('state',0)
sigma=25; % variance of noise
x=x0+sigma*randn(size(x0));
figure(2), imshow(x,[])
disp(['psnr of noisy image=' num2str(psnr(x,x0)) 'dB'])

%--------parameters-------------
% delta for convergence control
t=10;   %searching range in each direction
f=2; % radius of square patch in kernelized ar regresssion
%=======================================




%% Non-local Means 
%=======================================
tic
[output]=NLmeansfilter(x,t,f,sigma);
toc
figure(3), imshow(output,[])
disp(['psnr of denoising output=' num2str(psnr(output,x0)) 'dB'])
%=======================================




%% Fast Non-local Means 
%=======================================
tic
[Output]=FNLM(x,f,t,sigma);
toc
figure(4), imshow(Output,[])
disp(['psnr of denoising output=' num2str(psnr(Output,x0)) 'dB'])
%=======================================




%% Asymptotic Non-local Means 
%=======================================
tic
sigmahalf=sigma/2;        % half the standard deviation of the noise    
[dx,W1]=ANLM(x,f,t,sigmahalf);  % first filtering
[output]=ANLM1(dx,f,t,W1);   % second filtering
toc
figure(5), imshow(output,[])
disp(['psnr of denoising output=' num2str(psnr(output,x0)) 'dB'])

%=======================================

