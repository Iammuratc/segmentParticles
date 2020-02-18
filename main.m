start=1;
finish=50;
%% Read the the binary image (1st step of the hole segmentation)
binary=zeros(975,928,finish-start+1);

for i=1:finish-start+1
im=imread(sprintf('out/binary_%03d_%03d/slice_%04d.tif',start,finish,i-1));
binary(:,:,i)=im;
end

% imshow3(binary,'Scale',0.5)
%% Read the segmented hole image (5th step of the hole segmentation)
Iholes=zeros(size(binary));

for i=1:finish-start+1
im=imread(sprintf('out/holes_ws_%03d_%03d/slice_%04d.tif',start,finish,i-1));
Iholes(:,:,i)=im;
end

%  Get properties of holes
CC = bwconncomp(Iholes);
Volume=regionprops3(CC,'Volume');
SurfaceArea=regionprops3(CC,'SurfaceArea');
%% Detect holes (6th step of the hole segmentation)

threshold=0.87;
count_volume=1;
myVolume=zeros(size(Volume));
for i= 1:size(Volume)
    V=Volume.Volume(i);
    A=SurfaceArea.SurfaceArea(i);
    if isSpherical(V,A,threshold)
        myVolume(count_volume)=i;
        count_volume=count_volume+1;
    end
end

myVolume=nonzeros(myVolume);
% Hole image
holes=zeros(size(Iholes));
for i=1:size(myVolume)
holes(CC.PixelIdxList{myVolume(i)})=1;
end


%imshow3(holes,'Scale',0.5)

%% Filled holes image
%holes=im2uint8(holes);
Ifilled=binary+holes;
%imshow3(Ifilled,'Scale',0.5)
%% Show some slices
close all
my_slice=25;
figure('Name','Hole image'), imshow(Iholes(:,:,my_slice))
figure('Name','Hole'), imshow(holes(:,:,my_slice))
figure('Name','Binary'), imshow(binary(:,:,my_slice))
figure('Name','Hole filled'), imshow(Ifilled(:,:,my_slice))
%% Write the hole filled image
for i = 1:size(Ifilled,3)
    filename=sprintf('out/binary_filled_%03d_%03d/slice_%03d.tif',start,finish,i-1);
    im=Ifilled(:,:,i);
    imwrite(im,filename);
end