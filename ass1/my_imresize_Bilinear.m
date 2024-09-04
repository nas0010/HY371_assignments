
resize_down_nearest = @(img) imresize(img, 1/a, 'nearest');
resize_down_nearest_AA = @(img) imresize(img, 1/a, 'nearest','Antialiasing', true);
resize_up_bilinear = @(img) imresize(img,a,'bilinear');
op="up";

I=imread("Brodatz/D104.gif");

  im2double(I);
 #{
 if(op=="sub")
      a=1/a; %devision because we  subsample
      %calculate wanted size
      column = a*size(I,2);
      row = a*size(I,1);
      %normalise and round up position numbers
      new_r= ceil([1:row]./(a));
      new_c= ceil([1:column]./(a));
      %fill the rows with the missing values with new_r indexing the value
      FI=I(:,new_r); 
      %fill with columns that contain the value of the nearest neighbor from new_c
      FI=FI(new_c,:);
      
   else
      #}
      if(op=="up")
      %calculate wanted size
      sc=size(I,2);
      sr=size(I,1);
      column =  a*sc;
      row =a*sr;
      FI = zeros(row, column);
            % https://en.wikipedia.org/wiki/Bilinear_interpolation
            for i = 1 : row
                for j = 1 : column
                    rf = i*a;
                    cf= j*a;
                    r1 = floor(rf);          
                    c1 = floor(cf);
                    
                    if r1 > sr - 1
                      r1= sr- 1;
                    endif
                    if c1> sc - 1
                      c1=sc - 1;
                    endif
                    
                     if r1 <1
                      r1=1;
                    endif
                    if c1<1
                      c1=1;
                    endif
                    r2=r1+1;
                    c2=r2+1;
                    if r2 > sr - 1
                      r2= sr- 1;
                    endif
                    if c2> sc - 1
                      c2=sc - 1;
                    endif
                    b = rf - r1;
                    c = cf - c1 ;
                    
                    % Formula for square of pixels
                    FI(i,j) = I(r1,c1)*(1-b)*(1-c) + I(r2,c1)*(b)*(1-c) +I(r1,c2)*(1-b)*(c) +I(r2,c2)*(b)*(c);
                 end
            end
     
     
  endif
UIB=imresize(I,a,'bilinear');
figure,subplot(121),imshow(UIB);title('UP sampling matlab');  axis([0,1024,0,1024]);axis on;
subplot(122),imshow(FI);title('up sampling');  axis([0,1024,0,1024]);axis on;


