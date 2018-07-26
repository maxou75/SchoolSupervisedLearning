function [] = detectionVisage( testC, dim, modele)

taille=size(testC, 2);

for i=4:taille
    image=testC{i};
    visage=testImage(image, dim, modele);
    j=sprintf('%03d', i);
    file = fopen(strcat(strcat('testLabel/',j)),'w');
    for j=1:size(visage,1)
        fprintf(file,'%.0f %.0f %.0f %.0f %.2f',visage(j,1), visage(j,2), visage(j,3), visage(j,4), visage(j,5) );
        fprintf(file,'\n');
    end;
    fclose(file);
end;

