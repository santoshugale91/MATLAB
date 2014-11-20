% sample matrix for testing
%classify(sample, training, group);
Train=xlsread('training dtata');
Test=xlsread('test');
load('group.mat');
class=knnclassify(Test, Train, group);
