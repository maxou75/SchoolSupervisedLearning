function [SVMModel, cellulePos,celluleNeg,celluleNeg2,posTrainX,negTrainX] = apprentissage( trainC,  newlabel)

posTrainY=ones(1000,1); %Chaque image positive
posTrainX= zeros(1000, 2116); %une ligne pour une image soit une ligne de 46*46 colonnes = 2116
negTrainY=-ones(1,0);
negTrainX= zeros(1, 2116);
cellulePos=cell(1,1000);
celluleNeg=cell(1,10000);
celluleNeg2=cell(1,10000);
negTrainX=zeros(1,2116);
SVMModel=0;
a=0;
b=0;
for i=1:1000
    
    img=imresize(trainC{i}, 1/newlabel(i,5));
    imgCrop=imcrop(img, newlabel(i,1:4));
    I=imresize(imgCrop, [46 46]);
    posTrainX(i,:)=reshape(I(:,:),1,2116);
    cellulePos{i}=I;
end
for i=1:1000
    j=0;
    nbrMax=0;
    %10 visages négatifs pasr image
    while j<10 && nbrMax <100
        
        nbrMax=nbrMax+1;
        r=randi([1 4]);
        img=imresize(trainC{i}, 1/r);
        l=size(img,1) - 46;
        if (l<0)
            l=1;
        end;
        c=size(img,2) - 46;
        if (c<0)
            c=1;
        end;
        x=randi([0 c]);
        y=randi([0 l]);
        
        imgCrop=imcrop(img, [x y 45 45]);
        I=imresize(imgCrop, [46 46]);
        %imshow(img);
        %hold on;
        
        carrePos=newlabel(i,1:4)*newlabel(i,5)*1/r;
        %rectangle('position', carrePos,'LineWidth',2, 'EdgeColor','y');
        pause(0.1);
        %Vérification que le zone négatif n'est pas trop proche du carré positif
        %Il faut comparer avec le zone du visage adapté à la bonne dimension
        %actuelle
        %dimDif= abs(r-newlabel(i,5)); %calcul de la difference de dimension afin d'accepter un nombre de pixel par rapport à cette difference
        if (intersection(uint8(carrePos), uint8([x y 46 46]))==0)    %10*dimDif)
            %rectangle('position', [x y 46 46],'LineWidth',2, 'EdgeColor','r');
            %pause(1.5);
            a=a+1;
            j=j+1;
            celluleNeg{a}=I;
            negTrainX(a,:)=reshape(I(:,:),1,2116);
        else
            %rectangle('position', [x y 46 46],'LineWidth',2, 'EdgeColor','g');
            %pause(1.5);
            b=b+1;
            celluleNeg2{b}=I;
        end;
    end;
end
posTrainX=normalise(posTrainX);
negTrainX=normalise(negTrainX);


negTrainY=-ones(a,1);

trainX=[posTrainX ; negTrainX];
trainY=[posTrainY ; negTrainY];
SVMModel = fitcsvm(trainX, trainY, 'BoxConstraint', 2.^-4);
end