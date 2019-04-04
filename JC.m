function sim = JC(Network)
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
        cn_r = sum(sum(subNet,2)>0);%���Ӿ�������i��j�ߴ��ڣ����ʾ���ڴ�r��j��i��c��·�������ǿ�����ߵ�ʽ�������е�A���м�ڵ�
        cn_c = sum(sum(subNet,1)>0);
        sim(r,c)=(cn_r+cn_c)./(r_deg_all(r)+c_deg_all(c));
    end
end
sim(isinf(sim))=0;%������õ����쳣ֵ��Ϊ0
end