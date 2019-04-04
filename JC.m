function sim = JC(Network)
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
r_deg_all = sum(Network,2);%所有r节点的度
c_deg_all = sum(Network,1);
for r=1:row
    for c=1:col
        c_neg = find(Network(r,:));%r节点的所有c节点邻居
        r_neg = find(Network(:,c));%c节点的所有r节点邻居
        subNet=Network(r_neg,c_neg);
        cn_r = sum(sum(subNet,2)>0);%在子矩阵中中i，j边存在，则表示存在从r到j到i到c的路径，于是可用左边的式子求所有的A类中间节点
        cn_c = sum(sum(subNet,1)>0);
        sim(r,c)=(cn_r+cn_c)./(r_deg_all(r)+c_deg_all(c));
    end
end
sim(isinf(sim))=0;%将除零得到的异常值置为0
end