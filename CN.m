function sim = CN(Network)
%%%
%算法的思路是，找到A类节点r和b类节点c之间经过两跳可达的所有节点，统计他们的总数
%比如从A类节点r1 到 B类节点c2有边 c2到r2有边，r2到c1有边，那么从r1到c1经过两跳的节点，就是c2和r2
%那么cn（r1,c1）=2
%如果从c2到r3,从r3到c1也有一条路，则r1和c1只间两跳节点为r2 r3 c2 cn(r1,c1)=3
%只统计节点数有多少，不考虑路径数量
%%%
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
for r=1:row
    for c=1:col
        c_neg = find(Network(r,:));%r节点的所有c节点邻居
        r_neg = find(Network(:,c));%c节点的所有r节点邻居
        subNet=Network(r_neg,c_neg);
        cn_r = sum(sum(subNet,2)>0);%在子矩阵中中i，j边存在，则表示存在从r到j到i到c的路径，于是可用左边的式子求所有的A类中间节点
        cn_c = sum(sum(subNet,1)>0);
        sim(r,c)=cn_r+cn_c;
    end
end
end