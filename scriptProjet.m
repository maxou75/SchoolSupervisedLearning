
%%  PROJET SY32 : APPRENTISSAGE SUPERVISE ET DETECTION DE VISAGE
%%PROPERTY OF MAXIME DONNET

%%-------------------- INITIALISATION -----------------------------%%



%Label : x, y, L, H
trainC=cell(1,1000);
label=zeros(1000,4);
maximumTrain=zeros(1,2);

for i=1:1000
    %chargement des images
    j=sprintf('%04d', i);
    img=imread(strcat(strcat('train/',j),'.jpg'));
    if(size(img,3) == 1)
        trainC{i}=img;
    else
        trainC{i}=rgb2gray(img);
    end;
    %chargement des images
    k=sprintf('%03d', i);
    l=load(strcat(strcat('label/',k),'.txt'));
    label(i,:)= l(1,:);
    %determination du label max
    m=label(i,3)*label(i,4);
    if(m>max(maximumTrain(1,1),maximumTrain(1,2)) )
        maximumTrain(1,1)= label(i,3);
        maximumTrain(1,2)= label(i,4);
    end;
    %determination du label min
end;

%determination des coordonnées min des label qui va déterminer la carré de
%glissage
minimumTrain=maximumTrain;
for i=1:1000
    m=min(label(i,3),label(i,4));
    if(m<min(minimumTrain(1,1),minimumTrain(1,2)) )
        minimumTrain(1,1)= label(i,3);
        minimumTrain(1,2)= label(i,4);
    end;
end;

%Réglages des labels : Si les coordonnées sont négatives ont les met à 0.
for i=1:1000
    if(label(i,1)<0)
        label(i,1)=0;
    end;
    if(label(i,2)<0)
        label(i,2)=0;
    end;
end;
%min = 30 46 donc carré de 46 * 46

%Redimensionnement des label en fonction du scale
newlabel=zeros(1000,5);
for i=1:1000
    scale=max(label(i,3)/46, label(i,4)/46);
    newlabel(i,1)= label(i,1)/scale;
    newlabel(i,2)= label(i,2)/scale;
    newlabel(i,3)= 45;
    newlabel(i,4)= 45;
    newlabel(i,5) = scale;
end;


clearvars m i j k l im max min scale;

%chargement des images de test
testC=cell(1,447);
for i=1:451
    j=sprintf('%04d', i);
    img=imread(strcat(strcat('test/',j),'.jpg'));
    if(size(img,3) == 1)
        testC{i}=img;
    else
        testC{i}=rgb2gray(img);
    end;
end;

clearvars i j img var



%--------------------- APPRENTISSAGE -------------------------------



[modele1 , modele_TrainX, modele_TrainY]=apprentissage(trainC, newlabel);
%Modele 2 qui est le résultat d'un apprentissage plus précis
[modele2 ,P,N1,N2, posTrainX,negTrainX]=apprentissage2(trainC , newlabel);

%Vérification des images positives et négatives
for i=1:1000
    imshow(P{i}); %avec P,N1 et N2=images rejetés car trop proche de positives
end;

%Phase de verification du modele sur des images
i=97;
img=trainC{i};
img=imresize(img, 1/newlabel(i,5));

%avec glissage, l'image est dimensionné au préalable
glissage(img, newlabel(i,1:4), 3, 46, modele1);
glissage(img, newlabel(i,1:4), 3, 46, modele2);

img=trainC{247};
%avec glissage 2 qui boucle pour modifier la dimension de l'image
%passé en parametre
[test3, score3]=glissage2(img, newlabel(i,1:5), 46, modele1);
[test4, score4]=glissage2(img, newlabel(i,1:5), 46, modele2);



%------------------------NOUVEL APPRENTISAGE--------------------------

%On prend un échantillon des images d'entrainements pour rajouter aux
%données négatives du modèle les faux positifs de cet échantillon.
%NewModele est
[newModele,newNegTrainX, newPosTrainX]= nouvelApprentissage(trainC, newlabel, modele2, negTrainX, posTrainX);

i=700;
img=trainC{i};
%Nouveau modele plus performant, on constate beaucoup moins d'erreurs
[test5, score5]=glissage2(img, newlabel(i,1:5), 46, newModele);



%-------------DETECTION DE VISAGE SUR IMAGES DE TEST-----------------

%on a un modele assez performant pour pouvoir être testé sur
%les images de tests

img=testC{1};

%On enregistre tous les visages trouvés sur l'image pour toutes les dimensions.
%A la fin, on élimine les Non Maximas et on garde le carré
%avec le meilleur score parmis ceux proches. On affiche ainsi tous les
%bons visage trouvés et on met en évidence celui avec le meilleur score.
result2=testImage(img, 46 , newModele2);


%Sauvegarde des résultats
%On écrit dans un fichier .txt par image, les coordonnées du visage trouvé
%ainsi que son score.
detectionVisage(testC, 46, newModele2);






