function my_log_filter(img, pad_type,sigma)
  imageF=imread(img);
  imageF=im2double(imageF);
  %usual size is 3 times sigma
  win_size=floor(3*sigma);
  %b= floor(win_size/2);
  win_size1=floor(3*1.28*sigma);
  b= floor(win_size1/2);
  %separable kernel
  [m,v]=meshgrid(-b:b,0);
  [v,n]=meshgrid(0,-b:b);
  powM = -(m.^2)/(2*sigma*sigma);
  powN= -(n.^2)/(2*sigma*sigma);
  hor_kernel=exp(powN)/(sqrt(2*pi)*sigma);
  ver_kernel=exp(powM)/(sqrt(2*pi)*sigma);
  
  %separable kernel
  [m1,v]=meshgrid(-b:b,0); %idio size kernel??
  [v,n1]=meshgrid(0,-b:b);
  powM1 = -(m1.^2)/(2*sigma*1.28*1.28*sigma);
  powN1= -(n1.^2)/(2*sigma*1.28*1.28*sigma);
  hor_kernel1=exp(powN1)/(sqrt(2*pi)*1.28*sigma);
  ver_kernel1=exp(powM1)/(sqrt(2*pi)*1.28*sigma);
 
  G2=my_separable_conv(img,hor_kernel,ver_kernel,pad_type);
  G1=my_separable_conv(img,hor_kernel1,ver_kernel1,pad_type);
  
  %G1=imsmooth(imageF,"Gaussian",sigma*1.28);
  %G2=imsmooth(imageF,"Gaussian",sigma);
  G=G1-G2;
  levelG=graythresh(G);
  levelF=graythresh(imageF);
  figure;
  subplot(1, 2, 1);
  imshow(im2bw(imageF,levelF));
  title('Initial');
  subplot(1, 2, 2);
  imshow(im2bw(G,levelG));
  title('My implementation');
  
  matlab_log_filter(imageF, pad_type);
endfunction

function matlab_log_filter(img, pad_type)
  sigma2 = [1, sqrt(2), 2, 2*sqrt(2)];
  sigma1=1.28*sigma2;
  G1_1 = imsmooth(img,"Gaussian",sigma1(1));
  G2_1 = imsmooth(img,"Gaussian",sigma2(1));
  G_1=G1_1-G2_1;
  levelG1=graythresh(G_1);
  G1_2= imsmooth(img,"Gaussian",sigma1(2));
  G2_2 = imsmooth(img,"Gaussian",sigma2(2));
  G_2=G1_2-G2_2;
  levelG2=graythresh(G_2);
  G1_3 = imsmooth(img,"Gaussian",sigma1(3));
  G2_3 = imsmooth(img,"Gaussian",sigma2(3));
  G_3=G1_3-G2_3;
  levelG3=graythresh(G_3);
  G1_4 = imsmooth(img,"Gaussian",sigma1(4));
  G2_4= imsmooth(img,"Gaussian",sigma2(4));
  G_4=G1_4-G2_4;
  levelG4=graythresh(G_4);
  figure;
  subplot(3, 2, 1);
  imshow(img);
  title('original');
  subplot(3, 2, 2);
  imshow(im2bw(img,graythresh(img)));
  title('binarized');
  subplot(3, 2, 3);
  imshow(im2bw(G_1,levelG1));
  title('1');
  subplot(3, 2, 4);
  imshow(im2bw(G_2,levelG2));
  title('2');
  subplot(3, 2, 5);
  imshow(im2bw(G_3,levelG3));
  title('3');
  subplot(3, 2, 6);
  imshow(im2bw(G_4,levelG4));
  title('4');
  
endfunction
