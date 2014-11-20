load accelerometer.mat
data=fulldata;
%[sss n]=size(data);
accX = data(:,2)/9.8;%3rd column of the CSV file is the values of Accelerometer X 
accY = data(:,3)/9.8;%4th column of the CSV file is the values of Accelerometer Y 
accZ = data(:,4)/9.8;%5th column of the CSV file is the values of Accelerometer Z
%**************************************************************************

[m,n]=size(accX); 
L=floor(m/23);
acc = ones(1,m); %%************Initialization of the statistical values of the windows******% 
avgX=zeros(1,L); 
avgY=zeros(1,L); 
avgZ=zeros(1,L);

avgACC=zeros(1,L);
maxACC=-3*ones(1,L); %these -3 and 100 values are random values which makes the inital values look a lot different than the actual values 
minACC=-3*ones(1,L); 
maxX=100*ones(1,L); 
maxY=100*ones(1,L);
maxZ=100*ones(1,L); 
minX=-100*ones(1,L);
minY=-100*ones(1,L); 
minZ=-100*ones(1,L);
stdX=zeros(1,L); 
stdY=zeros(1,L); 
stdZ=zeros(1,L); 
stdACC=zeros(1,L);
XYcorr=zeros(1,L); 
XZcorr=zeros(1,L);
YZcorr=zeros(1,L);
energy=zeros(1,L); %************************************************************************** %************************************************************************** 

for i=1:m
    acc(i)=sqrt((accX(i)^2+accY(i)^2+accZ(i)^2)); 
end

i=1; j=1; windowsize=50; %*******In each iteration, statistical values of a window are calculated %and raw data(accX,accY,accZ) index is inceremented by windowsize/2 to %provide %50 overlapping*************************************************% 
while(i<=m-52)
    corrmatrix=corrcoef([accX(i:i+windowsize-1),accY(i:i+windowsize-1),accZ(i:i+windowsize-1)]); 
   
    XYcorr(j)=corrmatrix(1,2);
    XZcorr(j)=corrmatrix(1,3); 
    YZcorr(j)=corrmatrix(2,3);

     avgX(j)=mean(accX(i:i+windowsize-1));
     stdX(j)=std(accX(i:i+windowsize-1));
     maxX(j)=max(accX(i:i+windowsize-1));
     minX(j)=min(accX(i:i+windowsize-1));
     
     avgY(j)=mean(accY(i:i+windowsize-1));
     stdY(j)=std(accY(i:i+windowsize-1));
     maxY(j)=max(accY(i:i+windowsize-1));
     minY(j)=min(accY(i:i+windowsize-1));
     
     avgZ(j)=mean(accZ(i:i+windowsize-1));
     stdZ(j)=std(accZ(i:i+windowsize-1));
     maxZ(j)=max(accZ(i:i+windowsize-1));
     minZ(j)=min(accZ(i:i+windowsize-1));
     
     avgACC(j)=mean(acc(i:i+windowsize-1));
     stdACC(j)=std(acc(i:i+windowsize-1));
     maxACC(j)=max(acc(i:i+windowsize-1));
     minACC(j)=min(acc(i:i+windowsize-1));
     energy(j)=sum(abs(fft(acc(i:i+windowsize-1))))/26;  %
     %Energy is defined as the normalized summation of absolute values of
     %Discrete Fourier Transform of a windowed signal sequence
     i=i+windowsize/2-1;
     j=j+1;
end
%**************************************************************************

   %This cell represents a matrix consisting of each row representing a
   %window and each column representing the statistical attribute
   %calculated above%
     ss={ 'maxX','minX','avgX','stdX','maxY','minY','avgY','stdY','maxZ','minZ','avgZ','stdZ','maxACC','minACC','avgACC','stdACC','XYcorr','XZcorr','YZcorr','energy'};
     cell=[ maxX.',minX.',avgX.',stdX.',maxY.',minY.',avgY.',stdY.',maxZ.',minZ.',avgZ.',stdZ.',maxACC.',minACC.',avgACC.',stdACC.',XYcorr.',XZcorr.',YZcorr.',energy.'];
   
    %MATLAB has a built-in function to write the matrix given as input  into a file of the format of CSV.
    xlswrite('features.xls',ss);
    xlswrite('features.xls',cell,1,'A2');
    %csvwrite('features.csv',cell, 1, 0);
 % end