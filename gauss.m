function h = gauss(i, s)
path = strcat('maskG', num2str(i));
path = strcat(path, '.txt');
fileID = fopen(path,'r');
h = fscanf(fileID,'%f', [s s]);
fclose(fileID);
end
