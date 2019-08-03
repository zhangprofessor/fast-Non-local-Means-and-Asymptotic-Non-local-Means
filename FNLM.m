function  [Output]=FNLM(x,f,t,h);

% fast nonlocal means filter,a fast implementation of nonlocal means filter for image denoising.

% x :         a 2D image and
% f:          % radius of square patch
% t:          % searching range in each direction
% kernel
% sigma       % noise variance
% last modified 24-04-2010 

% Size of the image
[m n]=size(x);


% Memory for the output
Output=[];

% Replicate the boundaries of the x image

x2 = padarray(x,[f+t f+t],'symmetric');
kernel=make_kernel(f);

squ_sum=x2.*x2;
gsqu_sum=conv2(squ_sum,kernel,'same'); % Weighted 2-norm squared

wd=2*f+1; % width of widow;
h=h^2;

for i=1:m
    for j=1:n
        
        i1 = i+ t+f;
        j1 = j+ t+f;
        rw= x2(i1-f:i1+f , j1-f:j1+f); % reference window
        rw(:,1:end)=rw(:,2*f+1:-1:1);
        rw(1:end,:)=rw(2*f+1:-1:1,:);
        rw=rw.*kernel;
        bw=x2(i1-t-f:i1+t+f,j1-t-f:j1+t+f);   % big window for similarity searching
        % convolution computation
        cv_bw=conv2(bw,rw,'valid');
        
        %----------------------------------------------------------
        
        gsq_dis=gsqu_sum(i1,j1)+gsqu_sum(i1-t:i1+t,j1-t:j1+t)-2*cv_bw;  % Eqn. (5) in the paper;
        weight=exp(-gsq_dis/h);
        weight(t+1,t+1)=0;
        weight(t+1,t+1)=max(weight(:));
        est=x2(i1-t:i1+t,j1-t:j1+t).*weight;
        Output(i,j)=sum(est(:))/(sum(weight(:)));
        
    end
end

function [kernel] = make_kernel(f)

kernel=zeros(2*f+1,2*f+1);
for d=1:f
    value= 1 / (2*d+1)^2 ;
    for i=-d:d
        for j=-d:d
            kernel(f+1-i,f+1-j)= kernel(f+1-i,f+1-j) + value ;
        end
    end
end
kernel = kernel ./ f;



