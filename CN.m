function sim = CN(Network)
%%%
%�㷨��˼·�ǣ��ҵ�A��ڵ�r��b��ڵ�c֮�侭�������ɴ�����нڵ㣬ͳ�����ǵ�����
%�����A��ڵ�r1 �� B��ڵ�c2�б� c2��r2�бߣ�r2��c1�бߣ���ô��r1��c1���������Ľڵ㣬����c2��r2
%��ôcn��r1,c1��=2
%�����c2��r3,��r3��c1Ҳ��һ��·����r1��c1ֻ�������ڵ�Ϊr2 r3 c2 cn(r1,c1)=3
%ֻͳ�ƽڵ����ж��٣�������·������
%%%
row=size(Network,1);
col=size(Network,2);
sim = zeros(row,col);
for r=1:row
    for c=1:col
        c_neg = find(Network(r,:));%r�ڵ������c�ڵ��ھ�
        r_neg = find(Network(:,c));%c�ڵ������r�ڵ��ھ�
        subNet=Network(r_neg,c_neg);
        cn_r = sum(sum(subNet,2)>0);%���Ӿ�������i��j�ߴ��ڣ����ʾ���ڴ�r��j��i��c��·�������ǿ�����ߵ�ʽ�������е�A���м�ڵ�
        cn_c = sum(sum(subNet,1)>0);
        sim(r,c)=cn_r+cn_c;
    end
end
end