function [kernel] = myLoG(wsize, std)

Gk = myGaussian(wsize, std);
e = Gk * 2*pi*std^2;

%assuming wsize is an odd number since it would be impossible to be
%symmetric around 0 otherwise.
range = floor(wsize/2);

x = -range:1:range;
y = -range:1:range;

L = (((x.^2)'+y.^2) - 2*std^2)/std^4;

%for testing purposes
% e = [ 1, 1, 1; 2, 2, 2; 3, 3, 3];
% L = ones(3,3);


Lk = L.*e;

kernel = Lk;

%force sum of elements to 0?
%Not sure how to do this?
%needs a certain number of elements?
sum_K = sum(kernel, 'all');

if sum_K < 0
    kernel = zeros(wsize, wsize);
end 
   
end

