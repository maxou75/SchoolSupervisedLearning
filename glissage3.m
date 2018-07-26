function [visage] = glissage3( imageDeBase,  dim , modele)

pasdebase=30;
carreNeg= zeros(1,4);
g=0;
figure;
indiceImg=0;
visage=zeros(0,5);

for k=1:0.5:10
    clf;
    nbrImageK=0;
    pas=pasdebase/k;

    image=imresize(imageDeBase, 1/k);
    ligne=size(image,1)-dim;
    colonne=size(image,2)-dim;
    if (ligne<0)
        ligne=1;
    end;
    if (colonne<0)
        colonne=1;
    end;
    
    testX= zeros(1,2116);
    imshow(image);
    hold on;
    for i=1:pas:ligne
        for j=1:pas:colonne
            imgCrop=imcrop(image, [j i dim dim]);
            I=imresize(imgCrop, [dim dim]);
            testX(1,:)=reshape(I(:,:),1,2116);
            testX=normalise(testX);
            [prediction, score]=predict(modele, testX);
            if prediction==1
                
                rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','b');
                pause(0.01);
                nbrImageK=nbrImageK+1;
                carreNeg(nbrImageK,1:4)=[j i dim dim];
            end;
        end;
    end;
    
    if nbrImageK>0
        %calcule des moyennes des images
        moyenneX=mean(carreNeg(:,1));
        moyenneY=mean(carreNeg(:,2));
        
        %eliminer les extrémités
        
        %calcul des ecarts type
        sigmaX=abs(std(carreNeg(:,1)));
        sigmaY=abs(std(carreNeg(:,2)));
        
        newX=moyenneX+23-sigmaX/2;
        newY=moyenneY+23-sigmaY/2;
        rectangle('position', [newX newY sigmaX sigmaY],'LineWidth',2, 'EdgeColor','r');
        pause(2);
        
        indiceImg=indiceImg+1;
        %Calcul du score de la nouvelle image
        imgFinale=imcrop(image, [newX newY sigmaX sigmaY]);
        imgFinale=imresize(imgFinale, [dim dim]);
        X=zeros(1,2116);
        X(1,:)=reshape(imgFinale(:,:),1,2116);
        X=normalise(X);
        [prediction, score]=predict(modele, X);
        
        visage(indiceImg,1:4)=[newX newY sigmaX sigmaY];
        visage(indiceImg,5)=score(1,2);
        
    end;
    
    
end;