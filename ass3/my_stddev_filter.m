function my_stddev_filter(img, pad_type)
  imageF=imread(img);
  imageF=im2double(imageF);
  imageS=(imageF).^2;
  %creating image to call my convolution implementation
  imwrite(imageS,"squared_img.png","png");
  %averaging box
  hor_kernel=ones(1,5)*1/5;
  ver_kernel=ones(5,1)*1/5;
  E_I=my_separable_conv(img,hor_kernel,ver_kernel,pad_type);
  E_I2=my_separable_conv("squared_img.png",hor_kernel,ver_kernel,pad_type);
  E_I=im2double(E_I);
  E_I2=im2double(E_I2);
  J=sqrt(abs(E_I2 - (E_I).^2)); %abs to keep only positive values
  O=matlab_stddev_filter(imageF,pad_type);  
  levelJ=graythresh(real(J));
  levelO=graythresh(real(O));
  figure;
  subplot(1, 3, 1);
  imshow(im2bw(imageF,graythresh(imageF)));
  title('Initial');
  subplot(1, 3, 2);
  imshow(im2bw(J,levelJ));
  title('My implementation');
  subplot(1, 3, 3);
  imshow(im2bw(O,levelO));
  title('Octave');
  
  %%%%%%%%%%%%%IMPORTANT trexei telika me thn facade.png apla argei arketa 
  
endfunction

function A=matlab_stddev_filter(img, pad_type)
  A_1 = imfilter(img, fspecial("average", [5 5]));
  A_2 = imfilter(img.^2, fspecial("average", [5 5]));
  A=sqrt(abs(A_2-((A_1).^2)));
endfunction
