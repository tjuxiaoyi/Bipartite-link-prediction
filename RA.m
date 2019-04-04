function sim = RA(Network)
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
        r_hop_neg = r_neg(sum(subNet,2)>0);%所有A类中间节点在原图中的坐标
        c_hop_neg = c_neg(sum(subNet,1)>0);
        neg_deg_all = [r_deg_all(r_hop_neg)',c_deg_all(c_hop_neg)];
        sim(r,c)=sum(1./neg_deg_all);
    end
end
sim(isinf(sim))=0;%将除零得到的异常值置为0
end