function [nouveauModele, testNegX, testPosX] = nouvelApprentissage( trainC, newlabel, modele, negTrainX, posTrainX)

newNegTrainX=zeros(0,2116);
score=zeros(0,2);

for i=1:100:1000
    image=trainC{i};
    newlabelCurrent=newlabel(i,:);
    [tmpNegX, scoreTmp]=glissage2(image, newlabelCurrent, 46, modele);
    tmpNegX=normalise(tmpNegX);
    newNegTrainX= [newNegTrainX;tmpNegX];
    score=[score ;scoreTmp];
end;

testNegX= [negTrainX ;newNegTrainX ];
tailleN=size(negTrainX,1)+size(newNegTrainX,1);
testNegY=-ones(tailleN,1);

testPosX= posTrainX;
tailleP=size(posTrainX,1);
testPosY=ones(tailleP,1);

testX=[testPosX ; testNegX];
testY=[testPosY ; testNegY];

nouveauModele = fitcsvm(testX, testY, 'BoxConstraint', 2.^-4);

