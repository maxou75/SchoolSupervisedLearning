function [donnee] = normalise(donnee)

ligne=size(donnee,1);

for i=1:ligne
    meanx= mean(donnee(i,:));
    stdx=std(donnee(i,:));
    donnee(i,:)=(donnee(i,:)-meanx)/stdx;
end

end

