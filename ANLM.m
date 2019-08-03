function  [output,W1]=ANLM(x,f,t,h);


% x :         a 2D image and
% f:          % radius of square patch
% t:          % searching range in each direction
% kernel
% sigma       % noise variance

% modified 08-02-2019

% Size of the image
[m n]=size(x);


% Memory for the output
output=[];

% Replicate the boundaries of the x image

x2 = padarray(x,[f+t f+t],'symmetric');
kernel=make_kernel(f);
squ_sum=x2.*x2; gsqu_sum=imfilter(squ_sum,kernel);
wd=2*f+1; % width of widow;

h=h^2;
W1=[];
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
        
        %-----------------------------------
        gsq_dis=gsqu_sum(i1,j1)+gsqu_sum(i1-t:i1+t,j1-t:j1+t)-2*cv_bw;
        weight=exp(-gsq_dis/h);
        w1=sum(sum(weight.*weight));
        w1=w1*h; % Calculated noise standard deviation
        W1(i,j)=w1; % Noise standard deviation at each pixel point after filtering
        
        weight(t+1,t+1)=0;
        weight(t+1,t+1)=max(weight(:));
        est=x2(i1-t:i1+t,j1-t:j1+t).*weight;
        output(i,j)=sum(est(:))/(sum(weight(:)));
        
    end
end






