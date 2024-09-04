function final=my_separable_conv(img,hor_kernel,ver_kernel,pad_type)
 imageF=imread(img);
 imageF=im2double(imageF);
 
  if strcmp(pad_type,"zero")==1
    imageG=padarray(imageF,[(size(hor_kernel,2)-1)/2 (size(ver_kernel,1)-1)/2]);
  elseif strcmp(pad_type,"replica")==1
    imageG=padarray(imageF,[(size(hor_kernel,2)-1)/2 (size(ver_kernel,1)-1)/2],"replicate");
  endif
  
  fin=my_conv(imageG,hor_kernel);
  final=my_conv(fin,ver_kernel);
  
  O=conv2(ver_kernel,hor_kernel,imageF,"same");
  
endfunction

function final=my_conv(img,kernel)
  imageA=im2col(img,[size(kernel,1),size(kernel,2)]);
  kernelF=fliplr(kernel);
  kernelF=flipud(kernelF);
  kernelF=kernelF(:);

   tmp=zeros(1,size(imageA,2));
for i = 1:size(imageA,2)
       tmp(i) = sum(imageA(:,i).*kernelF);
end

  final=col2im(tmp,[size(kernel,1) size(kernel,2)],[(size(img,1)),(size(img,2))]);
  
endfunction
