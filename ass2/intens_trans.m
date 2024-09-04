5function intens_trans(img)


    imc =imread(['MRI_Cardia/',img]);
    load('p_R.mat', 'p_R');
    load('p_G.mat', 'p_G');
    load('p_e.mat', 'p_e');
    pixels=numel(imc);

  
%empty arrays 
h=zeros(256,1);

p=zeros(256,1);
p_o=zeros(256,1);

q=zeros(256,1);

T1=zeros(256,1);

T2=zeros(256,1);

match=zeros(256,1);

myH=uint8(zeros(size(imc,1),size(imc,2)));

    
    
    for i=1:size(imc,1)

        for j=1:size(imc,2)

            x=imc(i,j); %get value

            h(x+1)=h(x+1)+1; %+1 because it cannot get 0 

            p(x+1)=h(x+1)/pixels; %known type

        end

end

[counts,y]=imhist(imc); %octave function for the above



p_o=counts/pixels; %calculation of pdf using results from octave

  for i=1:size(p)
    RMSE(i)=sqrt( mean(p_o(i)-p(i)).^2 );  %in for loop so that i can plot it
end

figure;
plot (p_o);
hold on;
plot(p);
legend('p_o','p');
title('pdfs');

figure;
plot(RMSE);
title("RMSE");

tmp=0;
  
  for i=1:size(p) %qumulative 
      tmp=tmp+p(i);
      q(i)=tmp;

end


    p0 = q(1)/p_e(1);  %as asked in assignment
    p1 = p0*p_e+(1-p0)*p_G;
    p2 = p0*p_e+(1-p0)*p_R;
   
    tmp=0; 
    for i=1:size(p1)  %qumulatives for gaussian and rice
      tmp=tmp+p1(i);
      q1(i)=tmp;

    end

    tmp=0;
    for i=1:size(p2)
          tmp=tmp+p2(i);
          q2(i)=tmp;

    end

    for i = 1:size(T1)   %types given in assignment
        T1(i)= min(abs(q1-q(i)));
        T2(i)= min(abs(q2-q(i)));
    end
    
    for i=1:size(p)   %my histogram equalization rounding up the product os qumulative and the number of values
        match(i)=round(q(i)*255);
     end
    
    for i=1:size(imc,1)

    for j=1:size(imc,2)

            myH(i,j)=match(imc(i,j)+1); %[0,1]
 
    end

end
    
    Y1 =T1(imc+1);  %unsigned integer arrays because grayscale(used above as well
    Y1=uint8(Y1*255);
    Y2 =T2(imc+1);
    Y2=uint8(Y2*255);   
    J = histeq(imc,256);

figure;
 plot(T1);
    hold on;
    plot(T2);
    hold on;
    plot(q);
    hold on;
    legend('Gauss', 'Rice','My transform'); %i write code in octave so i cant get T from histeq as in matlab
    title('T1, T2, T');
    
figure;
subplot(1, 3, 1);
imshow(imc);
title('Initial');
subplot(1, 3, 2);
imshow(myH);
title('My implementation');
subplot(1, 3, 3);
imshow(J);
title('Octave');

figure;
imshow(imc);
  subplot(2, 2, 1);
    imshow(imc);
    title('Initial');
    subplot(2, 2, 2);
    imshow(J);
    title('Octave');
    subplot(2, 2, 3);
    imshow(Y1);
    title('Gauss');
    subplot(2, 2, 4);
    imshow(Y2);
    title('Rice');
    
    figure;
    plot(imhist(imc));
    hold on;
    plot(imhist(Y1));
    hold on;
    plot(imhist(Y2));
    hold on;
    plot(imhist(J));
    legend('Initial', 'Gauss', 'Rice', 'Histeq');
    title('Histograms');


    
endfunction
