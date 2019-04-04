function sim = CAR(Network)
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
for r=1:row
    for c=1:col
        c_neg = find(Network(r,:));%r�ڵ������c�ڵ��ھ�
        r_neg = find(Network(:,c));%c�ڵ������r�ڵ��ھ�
        subNet=Network(r_neg,c_neg);
        
        lcl = sum(sum(subNet));%LCL is the number of local community links Ϊ·����
        cn_r = sum(sum(subNet,2)>0);%���Ӿ�������i��j�ߴ��ڣ����ʾ���ڴ�r��j��i��c��·�������ǿ�����ߵ�ʽ�������е�A���м�ڵ�
        cn_c = sum(sum(subNet,1)>0);
        sim(r,c)=(cn_r+cn_c)*lcl;
    end
end
end