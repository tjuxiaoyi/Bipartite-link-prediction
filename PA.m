function sim = PA(Network)
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
r_deg_all = sum(Network,2);%所有r节点的度
c_deg_all = sum(Network,1);
for r=1:row
    for c=1:col
        sim(r,c)=r_deg_all(r)*c_deg_all(c);
    end
end
end