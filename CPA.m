function sim = CPA(Network)
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
        
        lcl = sum(sum(subNet));%LCL is the number of local community links Ϊ·����
        cn_r = sum(sum(subNet,2)>0);%���Ӿ�������i��j�ߴ��ڣ����ʾ���ڴ�r��j��i��c��·�������ǿ�����ߵ�ʽ�������е�A���м�ڵ�
        cn_c = sum(sum(subNet,1)>0);
        ext_r = r_deg_all(r)-cn_r;
        ext_c = c_deg_all(c)-cn_c;
        car=(cn_r+cn_c)*lcl;
        sim(r,c)=ext_r*ext_c + ext_c*car + ext_r*car + car*car;
        
    end
end
end