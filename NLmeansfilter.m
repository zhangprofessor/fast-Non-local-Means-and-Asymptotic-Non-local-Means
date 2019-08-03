function [output]=NLmeansfilter(input,t,f,h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 %  input: image to be filtered
 %  t: radio of search window
 %  f: radio of similarity window
 %  h: degree of filtering
 %
 %  Author: Jose Vicente Manjon Herrera & Antoni Buades
 %  Date: 09-03-2006
 %
 %  Implementation of the Non local filter proposed for A. Buades, B. Coll and J.M. Morel in
 %  "A non-local algorithm for image denoising"
 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Size of the image
 [m n]=size(input);
 
 
 % Memory for the output
 Output=zeros(m,n);

 % Replicate the boundaries of the input image
 input2 = padarray(input,[f f],'symmetric');
 
 % Used kernel
 kernel = make_kernel(f);
 kernel = kernel / sum(sum(kernel));

 h=h*h;
 
 for i=1:m
 for j=1:n
                 
         i1 = i+ f;
         j1 = j+ f;
                
         W1= input2(i1-f:i1+f , j1-f:j1+f);
         
         wmax=0; 
         average=0;
         sweight=0;
         
         rmin = max(i1-t,f+1);
         rmax = min(i1+t,m+f);
         smin = max(j1-t,f+1);
         smax = min(j1+t,n+f);
         
         for r=rmin:1:rmax
         for s=smin:1:smax
                                               
                if(r==i1 && s==j1) continue; end;
                                
                W2= input2(r-f:r+f , s-f:s+f);                
                 
                d = sum(sum(kernel.*(W1-W2).*(W1-W2)));
                                               
                w=exp(-d/h);                 
                                 
                if w>wmax                
                    wmax=w;                   
                end
                
                sweight = sweight + w;
                average = average + w*input2(r,s);                                  
         end 
         end
             
        average = average + wmax*input2(i1,j1);
        sweight = sweight + wmax;
                   
        if sweight > 0
            output(i,j) = average / sweight;
        else
            output(i,j) = input(i,j);
        end                
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

