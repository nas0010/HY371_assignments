function J=my_gaussian_filter(img, pad_type,sigma)
  imageF=imread(img);
  imageF=im2double(imageF);
  %usual size is 3 times sigma
  win_size=floor(3*sigma);
  b= floor(win_size/2);
  %separable kernel
  [m,v]=meshgrid(-b:b,0);
  [v,n]=meshgrid(0,-b:b);
  powM = -(m.^2)/(2*sigma*sigma);
  powN= -(n.^2)/(2*sigma*sigma);
  hor_kernel=exp(powN)/(sqrt(2*pi)*sigma);
  ver_kernel=exp(powM)/(sqrt(2*pi)*sigma);
 
  J=my_separable_conv(img,hor_kernel,ver_kernel,pad_type);
  
  %padding now because ia have hor and ver kernel sizes for octaves function
  if strcmp(pad_type,"zero")==1
    imageG=padarray(imageF,[(size(hor_kernel,2)-1)/2 (size(ver_kernel,1)-1)/2]);
  elseif strcmp(pad_type,"replica")==1
    imageG=padarray(imageF,[(size(hor_kernel,2)-1)/2 (size(ver_kernel,1)-1)/2],"replicate");
  endif
  O=matlab_gaussian_filter(imageG,win_size,sigma);
  
  figure;
  subplot(1, 3, 1);
  imshow(im2bw(imageF));
  title('Initial');
  subplot(1, 3, 2);
  imshow(im2bw(J));
  title('My implementation');
  subplot(1, 3, 3);
  imshow(im2bw(O));
  title('Octave');
  
endfunction

function G=matlab_gaussian_filter(img, pad_type,sigma)
 G=imsmooth(img,"Gaussian",sigma);
 %G= imfilter(img, fspecial("gaussian", [pad_type pad_type],sigma));
endfunction
