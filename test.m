clear;
net=load('GPC.mat');
net=net.net;
[train,test]=DivideBiNet(net,0.9);
sim =CPA(train);
n=100;
auc = CalcBiAUC(train,test,sim,n);