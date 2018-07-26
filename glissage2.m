function [negX, resultat] = glissage2( imageDeBase, newlabel, dim , modele)
zoneP=newlabel(1,1:4);
pasdebase=20;
resultat=zeros(0,2);
negX= zeros(1, 2116);
g=0;
figure;

for k=1:0.5:10
    clf;
    pas=pasdebase/k;
    
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
    rectangle('position', zoneP*newlabel(1,5)*1/k,'LineWidth',2, 'EdgeColor','y');
    pause(0.01);
    for i=1:pas:ligne
        for j=1:pas:colonne
            imgCrop=imcrop(image, [j i dim dim]);
            I=imresize(imgCrop, [dim dim]);
            testX(1,:)=reshape(I(:,:),1,2116);
            testX=normalise(testX);
            [prediction, score]=predict(modele, testX);
            if prediction==1
                %Si intersection carré avec positif est > 0
                if  intersection(uint8(zoneP*newlabel(1,5)*1/k), uint8([j i dim dim]))>0
                    rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','b');
                    pause(0.01);
                else %faux positif
                    rectangle('position', [j i dim dim],'LineWidth',2, 'EdgeColor','g');
                    pause(0.01);
                    g=g+1;
                    resultat(g,:)=score;
                    celluleNeg{g}=I;
                end;
            end;
            %pause(0.01);
        end;
    end;
end;
if g>0
    negX= zeros(g, 2116);
    for i=1:g
        J=celluleNeg{i};
        negX(i,:)=reshape(J(:,:),1,2116);
    end;
end;