function [visage] = testImage( imageDeBase, dim, modele)

pasdebase=30;
resultat=zeros(0,7);
g=0;
figure;

for k=1.5:0.5:10
    pas=pasdebase/k;
    clf;
    
    image=imresize(imageDeBase, 1/k);
    ligne=size(image,1)-dim;
    colonne=size(image,2)-dim;
    if (ligne<0)
        ligne=0;
    end;
    if (colonne<0)
        colonne=0;
    end;
    
    testX= zeros(1,2116);
    imshow(image);
    hold on;
    for i=1:pas:ligne
        for j=1:pas:colonne
            % clf;
            % rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','w');
            % pause(0.001);
            
            imgCrop=imcrop(image, [j i dim dim]);
            I=imresize(imgCrop, [dim dim]);
            testX(1,:)=reshape(I(:,:),1,2116);
            testX=normalise(testX);
            [prediction, score]=predict(modele, testX);
            if prediction==1
                rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','g');
                pause(0.01);
                g=g+1;
                resultat(g,1:2)=score;
                resultat(g,3:7)=[j i dim dim k];
            end;
        end;
    end;
end;

clf;
imshow(imageDeBase);
hold on;


if g>0 %au moin un visage detecté
    nbVisageP=g;
    
    resultatTmp=ones(1,nbVisageP);
    
    %Suppression des Non Maximas -> carrés trop proches
    for i=1:nbVisageP
        currentVisage=resultat(i,:);
        for j=1:nbVisageP
            if j~=i
                inter=intersection(uint8(currentVisage(1,3:6)*currentVisage(1,7)), uint8(resultat(j,3:6)*resultat(j,7)));
                dimCmp=dim*min(resultat(j,7), currentVisage(1,7));
                if(inter>((dimCmp*dimCmp)/2)) %Si l'intersection est >  aire /2 du plus petit des deux carrés
                    if(currentVisage(1,2)>resultat(j,2)) %Si son score est supérieur
                        resultatTmp(1,j)=0;
                    end;
                end;
            end;
        end;
    end;
    
    %Récuperation dans visage de toutes les images non supprimés et
    %affichage de celle ci
    visage=zeros(0,5);
    indice=0;
    for i=1:nbVisageP
        if resultatTmp(1,i)==1
            indice=indice+1;
            visage(indice,1:4)=resultat(i,3:6)*resultat(i,7);
            visage(indice,5)=resultat(i,2);
            rectangle('position', visage(indice,1:4), 'LineWidth',2, 'EdgeColor','b');
            pause(0.01);
        end;
    end;
    
    %On affiche en rouge le visage avec le meilleur score
    j=0;
    scoreMax=0;
    nbVisageP=size(visage,1);
    for i=1:nbVisageP
        if (visage(i,5)>scoreMax)
            scoreMax=visage(i,5);
            j=i;
        end;
    end;
    if j~=0
        rectangle('position', visage(j,1:4), 'LineWidth',2, 'EdgeColor','r');
        pause(0.01);
    end;
end;
end



