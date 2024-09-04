op="sub";
a=2;
I=imread("Brodatz/D8.gif");
#{
  function Er=Ef(x,y,S)
    Er=0;
    for m=1:size(x,1)
      for n=1:size(x,2)
        Er=Er+(x(m,n) - y(m,n)).^2;
      endfor
    endfor
    Er=1/S(x)*sqrt(Er);
    return;
  endfunction

function Sr=Sf(x)
  Sr=0;
  for m=1:size(x,1)
    for n=1:size(x,2)
      Sr=Sr+(x(m,n)).^2;
    endfor
  endfor
  Sr=sqrt(Sr);
  return;
endfunction

function Hr=Ghf(x,S)
  Hr=0;
  for m=1:size(x,1)
    for n=2:size(x,2)
      Hr=Hr+(x(m,n) - x(m,n-1)).^2;
    endfor
  endfor
  Hr=1/S(x)*sqrt(Hr);
  return;
endfunction

function Vr=Gvf(x,S)
  Vr=0;
  for m=2:size(x,1)
    for n=1:size(x,2)
      Vr=Vr+(x(m,n) - x(m-1,n)).^2;
    endfor
  endfor
  Vr=1/S(x)*sqrt(Vr);
  return;
endfunction

function [G,E] = GE(x, y)
    S=Sf(x);
    E=@(x,y)Ef(x,y,S);
    Gh=@(x)Gh(x,S);
    Gv=@(x)Gv(x,S);
    G=@(Gh,Gv)max(Gh,Gv);
    
    E_res = cellfun(E, x, y, 'UniformOutput', false);
    Gh_res = cellfun(Gh, x, 'UniformOutput', false);
    Gv_res = cellfun(Gv, x, 'UniformOutput', false);

    G_res = cellfun(G, Gh_res, Gv_res, 'UniformOutput', false);

    E_res = cell2mat(E_res);
    G_res = cell2mat(G_res);
    
    return
end


#}
  im2double(I);
  if(op=="sub")
      a=1/a;
  endif
      % DEFINE THE RESAMPLE SIZE
      Col = a * size(I,2);
      Row = a * size(I,1);

      %OBTAIN THE INTERPOLATED POSITIONS
      IR = ceil([1:(size(I,1)*a)]./(a));
      IC = ceil([1:(size(I,2)*a)]./(a));

      %ROW_WISE INTERPOLATION
      FI=I(:,IR);

      %COLUMN-WISE INTERPOLATION
      FI=FI(IC,:);
      
SI = imresize(I, a, 'nearest');
SIAA =imresize(I, a, 'nearest','Antialiasing', true);
UI=imresize(I, 1/a, 'nearest');
figure,subplot(121),imshow(SIAA);title('Sub sampling matlab');  axis([0,1024,0,1024]);axis on;
subplot(122),imshow(FI);title('sub sampling');  axis([0,1024,0,1024]);axis on;

figure,imshow(SIAA);title('sub sampling matlab aa');  axis([0,1024,0,1024]);axis on;
figure,imshow(UI);title('upsampling');  axis([0,1500,0,1500]);axis on;