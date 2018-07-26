function [SVMModel,posTrainX,negTrainX] = apprentissage2( trainC,  newlabel)

posTrainY=ones(1000,1); %Chaque image positive
negTrainY=-ones(10000,1); % Pour chaque image, on prend 10 carré négatifs "au hasard"
posTrainX= zeros(1000, 2116); %une ligne pour une image soit une ligne de 46*46 colonnes = 2116
negTrainX= zeros(1000, 2116);
cellulePos=cell(1,1000);
celluleNeg=cell(1,10000);
celluleNeg2=cell(1,10000);
a=0;
b=0;
dim=46;

for i=1:1000
    img=imresize(trainC{i}, 1/newlabel(i,5));   %réajustement de la taille de l'image
    imgCrop=imcrop(img, newlabel(i,1:4));       %récuperation du visage, format carré
    I=imresize(imgCrop, [dim dim]);             %redimensionnement au cas ou le visage est en bordure
    posTrainX(i,:)=reshape(I(:,:),1,2116);
    cellulePos{i}=I;
end
for i=1:1000
    j=0;
    while j<10
        r=randi([1 6]);
        %img=imresize(trainC{i}, 1/newlabel(i,5));
        img=imresize(trainC{i}, 1/r);
        l=size(img,1) - dim;
        if (l<0)
            l=0;
        end;
        c=size(img,2) - dim;
        if (c<0)
            c=0;
        end;
        y=randi([0 l]);
        x=randi([0 c]);
        imgCrop=imcrop(img, [x y 45 45]);
        I=imresize(imgCrop, [46 46]);
        if (abs((x-newlabel(i,1)*newlabel(i,5)*1)/r>50/r) && abs((y-newlabel(i,2)*newlabel(i,5)*1/r)>50/r) ) && abs(r-newlabel(i,5))<2;
            a=a+1;
            negTrainX(a,:)=reshape(I(:,:),1,2116);
            celluleNeg{a}=I;
            j=j+1;
        else
            b=b+1;
            celluleNeg2{b}=I;
        end;
    end;
    
end
posTrainX=normalise(posTrainX);
negTrainX=normalise(negTrainX);

trainX=[posTrainX ; negTrainX];
trainY=[posTrainY ; negTrainY];

SVMModel = fitcsvm(trainX, trainY, 'BoxConstraint', 2.^-4);
end

