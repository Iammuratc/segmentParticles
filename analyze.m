%% Analyze the data
minerals=zeros(975,928,50);

for i=1:50
im=imread(sprintf('out/segmented_minerals/slice_%04d.tif',i-1));
minerals(:,:,i)=im;
end
%% EquivDiameter and Sphericity
CC = bwconncomp(minerals);
EquivDiameter=regionprops3(CC,'EquivDiameter');


Volume=regionprops3(CC,'Volume');
SurfaceArea=regionprops3(CC,'SurfaceArea');

Sphericity=zeros(size(Volume));
for i= 1:size(Volume)
    V=Volume.Volume(i);
    A=SurfaceArea.SurfaceArea(i);
    sphericity=((36*pi*V^2)^(1/3))/A;
    Sphericity(i)=sphericity;
end