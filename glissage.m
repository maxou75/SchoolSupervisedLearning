function [] = glissage( image, zoneP, pas, dim , modele)

testX= zeros(1,2116);
ligne=size(image,1);
colonne=size(image,2);
if (dim>ligne)
    dim=ligne;
    ligne=1;
else
    ligne=ligne-dim;
end;
if (dim>colonne)
    dim=colonne;
    colonne=1;
else
    colonne=colonne-dim;
end;

figure;
imshow(image);
hold on;
for i=1:pas:ligne
    for j=1:pas:colonne
        %rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','w');
        %pause(0.01);
        rectangle('position', zoneP,'LineWidth',2, 'EdgeColor','y');
        pause(0.01);
        imgCrop=imcrop(image, [j i dim dim]);
        I=imresize(imgCrop, [dim dim]);
        testX(1,:)=reshape(I(:,:),1,2116);
        testX=normalise(testX);
        prediction=predict(modele, testX);
        if prediction==1
            rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','b');
            pause(0.01);
        end;
    end
end

