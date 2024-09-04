function segmenting_images
    imageT=imread("office.png");
    imageT=im2double(imageT);
    depth=load("office_depth.mat");
    [H, W, ~] = size(imageT);
    image=reshape(imageT,H*W,3);
    depthg=cell2mat(struct2cell(depth));
    depthg=mat2gray(depthg);

    %using only color data
    [idx3, C3] = kmeans(image, 3);
    [idx5, C5] = kmeans(image,5);
    [idx7, C7] = kmeans(image, 7);
    
    outimg3=reshape(idx3,H,W);
    outimg5=reshape(idx5,H,W);
    outimg7=reshape(idx7,H,W);

    figure;
    subplot(1,4,1);
    imshow(imageT);
    title("Original Image");
    subplot(1,4,2);
    imshow(labeloverlay(image,outimg3));
    title("k=3");
    subplot(1,4,3);
    imshow(labeloverlay(image,outimg5));
    title("k=5");
    subplot(1,4,4);
    imshow(labeloverlay(image,outimg7));
    title("k=7");
    %{
    %using only depth data
    [idx3, C3] = kmeans(depthg, 3);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C3(:,1), C3(:,2),'kx');
    title("k=3");
    
    [idx5, C5] = kmeans(depthg,5);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C5(:,1), C5(:,2),'kx');
    title("k=5");

    [idx7, C7] = kmeans(depthg, 7);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C7(:,1), C7(:,2), 'kx');
    title("k=7");

     [idx3, C3] = kmeans(depthg, 3);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C3(:,1), C3(:,2),'kx');
    title("k=3");
    
    [idx5, C5] = kmeans(depthg,5);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C5(:,1), C5(:,2),'kx');
    title("k=5");

    [idx7, C7] = kmeans(depthg, 7);
    figure;
    imshow(depthg,[]);
    hold on;
    plot(C7(:,1), C7(:,2), 'kx');
    title("k=7");

   
    

    [l o p]=MeanShiftCluster(image',0.2,1);
    [l o p]=MeanShiftCluster(image',0.35,1);
    [l o p]=MeanShiftCluster(image',0.6,1);
    
    [l o p]=MeanShiftCluster(image',0.2,1);
    [l o p]=MeanShiftCluster(image',0.35,1);
     [l o p]=MeanShiftCluster(image',0.6,1);


%    [idx,C] = kmeans(image,7,'Distance','cityblock');

 %   [idx,C] = kmeans(image,7,'Distance','cosine');

  %  [idx,C] = kmeans(image,7,'Distance','sqeuclidean');

   % [idx,C] = kmeans(depthg,7,'Distance','cityblock');

    %[idx,C] = kmeans(depthg,7,'Distance','cosine');

    %[idx,C] = kmeans(depthg,7,'Distance','sqeuclidean');

    %[idx,C] = kmeans(X,7,'Distance','cityblock');
%
 %   [idx,C] = kmeans(X,7,'Distance','cosine');

%    [idx,C] = kmeans(X,7,'Distance','sqeuclidean');
    %}

end
