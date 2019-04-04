function sim =AA(Network)
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
r_deg_all = sum(Network,2);%����r�ڵ�Ķ�
c_deg_all = sum(Network,1);
for r=1:row
    for c=1:col
        c_neg = find(Network(r,:));%r�ڵ������c�ڵ��ھ�
        r_neg = find(Network(:,c));%c�ڵ������r�ڵ��ھ�
        subNet=Network(r_neg,c_neg);
        r_hop_neg = r_neg(sum(subNet,2)>0);%����A���м�ڵ���ԭͼ�е�����
        c_hop_neg = c_neg(sum(subNet,1)>0);
        neg_deg_all = [r_deg_all(r_hop_neg)',c_deg_all(c_hop_neg)];
        sim(r,c)=sum(1./log2(neg_deg_all));
    end
end
sim(isinf(sim))=0;%������õ����쳣ֵ��Ϊ0
end