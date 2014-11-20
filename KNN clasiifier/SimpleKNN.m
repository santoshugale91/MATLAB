% sample matrix for testing
a=[50, 60;
    7, 2;
    13, 12;
    100, 200];
b=[1, 0;
    200, 30;
    19, 10];
g={'first';
    'second';
    'third';};
ans=knnclassify(a,b,g);