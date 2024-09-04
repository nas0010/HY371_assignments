function my_conv(img,kernel)
  imageF=imread(img);
  imageF=im2double(imageF);
  imageA=im2col(imageF,[size(kernel,1),size(kernel,2)]);
  kernelF=fliplr(kernel);
  kernelF=flipud(kernelF);
  kernelF=kernelF(:);

   tmp=zeros(1,size(imageA,2));
for i = 1:size(imageA,2)
       tmp(i) = sum(imageA(:,i).*kernelF);
end

  final=col2im(tmp,[size(kernel,1) size(kernel,2)],[(size(imageF,1)),(size(imageF,2))]);
  
  O=conv2(imageF,kernel,"valid");
  
  
  figure;
  subplot(1, 3, 1);
  imshow(imageF);
  title('Initial');
  subplot(1, 3, 2);
  imshow(final);
  title('My implementation');
  subplot(1, 3, 3);
  imshow(O);
  title('Octave');
  
endfunction





