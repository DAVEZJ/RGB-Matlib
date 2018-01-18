function [rgb] = xyz2rgb(XYZ)
%tristimulus only, 

[j,k,l] = size(XYZ);

if l == 3
    [X,Y,Z] = deal(XYZ(:,:,1),XYZ(:,:,2),XYZ(:,:,3));
elseif k ==3
    [X,Y,Z] = deal(XYZ(:,1,:),XYZ(:,2,:),XYZ(:,3,:));
else
    error('Data must be size Mx3 or MxNx3')
end

%transformation kernel

% %http://easyrgb.com
% 3.2406 -1.5372  -0.4986
% -0.9689  1.8758  0.0415
% 0.0557 -0.2040   1.0570

% % www.srgb.com 
% 3.2406 -1.5372 -0.4986
% -0.9689 1.8758 0.0415
% 0.0557 -0.2040 1.0570

% %http://www.w3.org/Graphics/Color/sRGB.html
% 3.2410 -1.5374 -0.4986
% -0.9692 1.8760 0.0416
% 0.0556 -0.2040 1.0470

%poynton color FAQ
a = [
	3.240479 -1.537150 -0.498535
	-0.969256 1.875992 0.041556
	0.055648 -0.204043 1.057311];

%  ref X 95.047
%  ref Y 100
%  ref Z 108.883
 
%transform to rgb
% RGB = a*[X';Y';Z'];
RGB = a*[X(:),Y(:),Z(:)]'/100;

r = zeros(size(X));
g = zeros(size(Y));
b = zeros(size(Z));

[r(:),g(:),b(:)] = deal(RGB(1,:),RGB(2,:),RGB(3,:));


if l == 3
    [rgb] = cat(3,r,g,b);

elseif k ==3
    [rgb] = cat(2,r,g,b);
end
