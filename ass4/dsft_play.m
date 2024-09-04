%simply run dsft_play for part 1&2 of assignment4
function dsft_play
%Discrete Space Fourier Transform
%data of assignment
h =[0.009, 0.027, 0.065, 0.122, 0.177, 0.2, 0.177, 0.122, 0.065, 0.027, 0.009];
g =[0.013, 0.028, 0.048, 0.056, 0.039, 0, -0.039, -0.056, -0.048, -0.028, -0.013];
m =-5:5;
u =linspace(-0.5,0.5,201);   
hg=h.*g';%transpose to have valid multiplication
gh=g.*h';

%DSFT for signals
Fh = ONED_mine_DSFT(h,m,u);
Fg = ONED_mine_DSFT(g,m,u);
Fhg= Fh.*Fg'; %conv idiothta in fourier domain

%magnitude of spatial frequencies in [-0.5,0.5]
magnitudeH=abs(Fh);
magnitudeG=abs(Fg);
magnitudeHG=abs(Fhg);

%plot 1D
figure;
subplot(1, 2, 1);
stem(m, h)
hold on;
stem(m, g)
title('Time');
legend('h(m)', 'g(m)');

subplot(1, 2, 2);
plot(u,magnitudeH);
hold on;
plot(u,magnitudeG );
title('Frequency');
legend('H(u)', 'G(u)');

%plot 2D
figure;
subplot(1, 2, 1);
plot(m, hg);
title('Time');

subplot(1, 2, 2);
surf(u,u,magnitudeHG);
title('Frequency');

%Image Segmentation
imageF=imread("build_neoclassic.png");
imageF=im2double(imageF);
y1=imfilter(imageF,hg,"conv");
y2=imfilter(imageF,gh,"conv");

%plot original and filtered image
figure;
subplot(1, 3, 1);
imshow(imageF);
title('Neoclassic building original');

subplot(1, 3, 2);
imshow(y1, []);
title('Neoclassic building filtered(hg)');

subplot(1, 3, 3);
imshow(y2, []);
title('Neoclassic building filtered(gh)');

%square magnitude
A = y1.^2 + y2.^2;

%unsigned direction of vector
arctan=atan(y2./y1);
t=abs(arctan);
mi=mean2(A);
k=t(:);
[L ,~]= kmeans(k,4,'Start',[0; 0.15*pi; 0.35*pi; 0.5*pi]); 
L=reshape(L,size(imageF, 1), size(imageF, 2));
finalL=zeros(size(imageF, 1), size(imageF, 2));
for i = 1:size(imageF, 1)
    for j = 1:size(imageF, 2)
        if A(i,j) <= mi
            L(i,j) = 0;
        end
    end
end

%because color array below will be indexe? from 1 add 1 to all (i,j) pixel
for i = 1:size(imageF, 1)
    for j = 1:size(imageF, 2)
       finalL(i,j) = L(i,j)+1; 
    end
end


color=[0, 0, 0; 1, 1, 0; 1, 0, 0; 0, 1, 0; 0, 0, 1];%0:’black’, 1:’yellow’, 2:’red’, 3:’green’, 4:’Blue’.
L= label2rgb(finalL,color);

figure;
subplot(1, 2, 1);
imshow(imageF);
title('Neoclassic building original');
subplot(1, 2, 2);
imshow(L, []);
title('Neoclassic building segmented');

%%%%%%%%%%%%%%%%part2
imageB=imread("barbara.png");
imageB=im2double(imageB);
%imageB=imread("obama.png");
%imageB=im2double(imageB);
%imageB=imread("einstein.png");
%imageB=im2double(imageB);

%u,v variable initialisation
u=(0:size(imageB,1)-1)/size(imageB,1);
v=(0:size(imageB,2)-1)/size(imageB,2);

%get fourier transform for angle
dftA=fft2(imageB);
p=imhist(imageB);

%inverse for 0.45
dft45 = Af(u,v,0.45).*exp(1i*angle(dftA));
idft45 =ifft2(dft45,'symmetric');
z45=histeq(Zf(imageB, idft45),p);


%inverse  for 0.49
dft49 = Af(u,v,0.49).*exp(1i*angle(dftA));
idft49 = ifft2(dft49,'symmetric');
z49=histeq(Zf(imageB, idft49),p);


%inverse  for 0.495
dft495 = Af(u,v,0.495).*exp(1i*angle(dftA));
idft495 = ifft2(dft495,'symmetric');
z495=histeq(Zf(imageB,idft495),p);


%plot original and each new result
figure;
subplot(1, 4, 1);
imshow(imageB);
title('Initial Image');
subplot(1, 4, 2);
imshow(z45, [])
title(["a=0.45,mean absolute error=", num2str(meanAbsErr(imageB, z45))]);
subplot(1, 4, 3);
imshow(z49, [])
title(["a=0.49,mean absolute error=", num2str(meanAbsErr(imageB, z49))]);
subplot(1, 4, 4);
imshow(z495, [])
title(["a=0.495,mean absolute error=", num2str(meanAbsErr(imageB, z495))]);

%quantisation
q5z=quatization(fft2(z495), 5);
q5 =quatization(dftA, 5);

q9z =quatization(fft2(z495), 9);
q9 =quatization(dftA, 9);

q17z =quatization(fft2(z495), 17);
q17 =quatization(dftA, 17);

q33z =quatization(fft2(z495), 33);
q33 =quatization(dftA, 33);

q65z =quatization(fft2(z495), 65);
q65 =quatization(dftA, 65);

figure;
subplot(1, 5, 1);
imshow(q5z);
title(["a=0.495, kf=5, mean absolute error=", num2str(meanAbsErr(imageB,q5z))]);
subplot(1, 5, 2);
imshow(q9z);
title(["a=0.495, kf=9, mean absolute error=", num2str(meanAbsErr(imageB,q9z))]);
subplot(1, 5, 3);
imshow(q17z);
title(["a=0.495, kf=17, mean absolute error=", num2str(meanAbsErr(imageB,q17z))]);
subplot(1, 5, 4);
imshow(q33z);
title(["a=0.495, kf=33, mean absolute error=", num2str(meanAbsErr(imageB,q33z))]);
subplot(1, 5, 5);
imshow(q65z);
title(["a=0.495, kf=65, mean absolute error=", num2str(meanAbsErr(imageB,q65z))]);

figure;
subplot(1, 5, 1);
imshow(q5);
title(["kf=5, mean absolute error=", num2str(meanAbsErr(imageB,q5))]);
subplot(1, 5, 2);
imshow(q9);
title(["kf=9, mean absolute error=", num2str(meanAbsErr(imageB,q9))]);
subplot(1, 5, 3);
imshow(q17);
title(["kf=17, mean absolute error=", num2str(meanAbsErr(imageB,q17))]);
subplot(1, 5, 4);
imshow(q33);
title(["kf=33, mean absolute error=", num2str(meanAbsErr(imageB,q33))]);
subplot(1, 5, 5);
imshow(q65);
title(["kf=65, mean absolute error=", num2str(meanAbsErr(imageB,q65))]);

%compresion
c25 = compress(dftA, 0.025,size(imageB,1),size(imageB,2));
c5 = compress(dftA, 0.05,size(imageB,1),size(imageB,2));
c75 = compress(dftA, 0.075,size(imageB,1),size(imageB,2));

figure;
subplot(1, 4, 1);
imshow(imageB);
title('Initial Image');
subplot(1,4,2);
imshow(c25);
title(["p=2.5%, mean absolute error=", num2str(meanAbsErr(imageB, c25))]);
subplot(1,4,3);
imshow(c5);
title(["p=5%, mean absolute error=", num2str(meanAbsErr(imageB,c5))]); 
subplot(1,4,4);
imshow(c75);
title(["p=7.5%, mean absolute error=", num2str(meanAbsErr(imageB, c75))]);
end

%%%%%%%%%%%%part1
function F = ONED_mine_DSFT(signal,n,u)
  F=signal*exp(1i*2*pi*n'*u);
end 

%%%%%%%%%%%%part2

%quantisation function 
function Q=quatization(fimg,k)
    ang=angle(fimg);
    
    if k<=20 %max value for multithreshis 20
        thresh = multithresh(ang,k-1);
        angQ=imquantize(ang,thresh,[0,thresh]);
    else
        lvls=linspace(min(ang(:)), max(ang(:)),k); %devide pedio timwn in k equal spaces
        angQ=imquantize(ang,lvls,[0,lvls]);
    end
    dftQ=abs(fimg).*exp(1i * angQ);
    Q=abs(ifft2(dftQ));
end
%given type
function A=Af(u,v,a)
  vi=v';
  A=1./(1-a*(cos(2*pi*u)+cos(2*pi*vi)));
end
%given type
function Z=Zf(X,Y)
     Z=max(X(:)).*((Y-min(Y(:)))/(max(Y(:))-min(Y(:))))+ min(X(:));
end
%found type online
function M=meanAbsErr(original,myhist)
  M=sum(abs(original(:)-myhist(:)))/numel(original);
end

%image compression
function Cimg = compress(fimg,p,s1,s2)
    dft_abs = abs(fimg);

    max_val =fix(s1*s2*p);
    [sortV,I] = sort(dft_abs(:),1,'descend');

    sortV(max_val:end)= 0;%set remaining values to zero
    
    resortV(I) = sortV;%get back to original arrangemnt based on I
    pvals= reshape(resortV, [s1 s2]);
    filtered=pvals.*exp(1i * angle(fimg));
    Cimg=abs(ifft2(filtered));
end
