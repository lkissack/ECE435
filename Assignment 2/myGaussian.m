function [kernel] = myGaussian(wsize, std)
%Function to generate gaussian kernel

norm = 1/(2*pi*std^2);

kernel = zeros(wsize, wsize);
%x, y, range (-wsize/2, wsize/2)
range = floor(wsize / 2);

denom = 2*std^2;

%Without using a loop
n = -range:1:range;
m = -range:1:range;

%square each element of n, and transpose it.
%then add the row vector of m.^2 to each row
sq = -1*((n.^2)' + m.^2)/denom;

e = exp(sq);

kernel = norm*e;
end

