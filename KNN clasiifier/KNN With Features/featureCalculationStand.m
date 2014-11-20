load stand.mat;
accX = stand(:,1)/9.8;%3rd column of the CSV file is the values of Accelerometer X 
accY = stand(:,2)/9.8;%4th column of the CSV file is the values of Accelerometer Y 
accZ = stand(:,3)/9.8;%5th column of the CSV file is the values of Accelerometer Z
[m,n]=size(accX);
%L=floor(m/23);
acc =[]; %%************ Initialization of the statistical values of the windows******% 
avgX=[]; 
avgY=[]; 
avgZ=[];

avgACC=[];
maxACC=[]; %these -3 and 100 values are random values which makes the inital values look a lot different than the actual values 
minACC=[]; 
maxX=[]; 
maxY=[];
maxZ=[]; 
minX=[];
minY=[]; 
minZ=[];
stdX=[]; 
stdY=[]; 
stdZ=[];
stdACC=[];
XYcorr=[];
XZcorr=[];
YZcorr=[];
energy=[];

for i=1:m 
    acc(i)=sqrt((accX(i)^2+accY(i)^2+accZ(i)^2));
end

i=1; j=1; windowsize=50; %*******In each iteration, statistical values of a window are calculated %and raw sit(accX,accY,accZ) index is inceremented by windowsize/2 to %provide %50 overlapping*************************************************% 

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
 cell=[ maxX.',minX.',avgX.',stdX.',maxY.',minY.',avgY.',stdY.',maxZ.',minZ.',avgZ.',stdZ.',maxACC.',minACC.',avgACC.',stdACC.',XYcorr.',XZcorr.',YZcorr.',energy.'];
 save('StandFeature','cell');