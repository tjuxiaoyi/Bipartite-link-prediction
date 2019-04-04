function egcMat = calEgc(predictMat)
%����ĳ����·Ԥ���㷨��Ԥ��ֵ���������ÿ���ߴ���������Ƕȷֱ�����õ���egc
%�����Ե�i�е�j�е�ֵ��egcMat(i,j)��ֵ��ʾ��i���Ƕȿ��ǵĸ����㷨��Ӧ��(i,j)��egc
%ʹ���������󣬷ֱ�洢������ڵ�ĽǶ�ȥ�Ƚ�
%����predictMat����Ϊn*m����
n = size(predictMat,1);
m=size(predictMat,2);
%A����������ʾ��A�ڵ�ǶȽ��бȽ�
%n0MatA����i��j�����洢�ߣ�i��j����Ԥ��ֵ��i�ڵ������ߵ�Ԥ��ֵ��Ĵ���
n0MatA = zeros(n,m);
%n1MatA����i��j�����洢�ߣ�i��j����Ԥ��ֵ��i�ڵ������ߵ�Ԥ��ֵһ����Ĵ���
n1MatA = zeros(n,m);
%NA���󱣴�������߱ȽϵĴ�������Ϊ����egc��Ҫ�ͽڵ����п��ܴ��ڵı߱Ƚϣ��ʱȽϴ�����n-2��
NA = ones(n,m)*(m-1);
%B����������ʾ��B�ڵ�ǶȽ��бȽ�
%n0MatB����i��j�����洢�ߣ�i��j����Ԥ��ֵ��j�ڵ������ߵ�Ԥ��ֵ��Ĵ���
n0MatB = zeros(n,m);
%n1MatB����i��j�����洢�ߣ�i��j����Ԥ��ֵ��j�ڵ������ߵ�Ԥ��ֵһ����Ĵ���
n1MatB = zeros(n,m);
%NB���󱣴�������߱ȽϵĴ�������Ϊ����egc��Ҫ�ͽڵ����п��ܴ��ڵı߱Ƚϣ��ʱȽϴ�����n-2��
NB = ones(n,m)*(n-1);

 %jѭ����ֵȷ����(i,j)
 %ѭ��kֵ�����Ƚ�(i,j)�ߺ�(i,k)�� 
 %��Ϊ������֮��ֻ��Ҫ�໥�Ƚ�һ��
 %��predictMat(i,j)>predictMat(i,k)ʱ��ֻ�����n0Mat(i,j)
 %��predictMat(i,j)<predictMat(i,k)ʱ��ֻ�����n0Mat(i,k)
 %predictMat(i,j)==predictMat(i,k)ʱ��ͬʱ����n1Mat(i,j)��n1Mat(i,k)
for i =1:n     %��A��ڵ���� ����
    for j=1:m-1 %����ѭ�������Ƚ�
        for k=j+1:m
            if predictMat(i,j) > predictMat(i,k)
                n0MatA(i,j)=n0MatA(i,j)+1;
            elseif predictMat(i,j) == predictMat(i,k)
                n1MatA(i,j)=n1MatA(i,j)+1;
                n1MatA(i,k)=n1MatA(i,k)+1;
            else
                n0MatA(i,k)=n0MatA(i,k)+1;
            end
        end
    end
end

egcMatA=n0MatA+n1MatA*0.5;
egcMatA=egcMatA./NA;


for i =1:m     %��B��ڵ���� ����
    for j=1:n-1 %����ѭ�������Ƚ�
        for k=j+1:n
            if predictMat(j,i) > predictMat(k,i)
                n0MatB(j,i)=n0MatB(j,i)+1;
            elseif predictMat(j,i) == predictMat(k,i)
                n1MatA(j,i)=n1MatA(j,i)+1;
                n1MatA(k,i)=n1MatA(k,i)+1;
            else
                n0MatA(k,i)=n0MatA(k,i)+1;
            end
        end
    end
end

egcMatB=n0MatB+n1MatB*0.5;
egcMatB=egcMatB./NB;

egcMat = max(egcMatA,egcMatB);
end