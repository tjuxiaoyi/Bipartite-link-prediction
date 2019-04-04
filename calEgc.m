function egcMat = calEgc(predictMat)
%根据某种链路预测算法的预测值连计算对于每条边从其两个点角度分别出发得到的egc
%我们以第i行第j列的值，egcMat(i,j)的值表示从i结点角度考虑的该种算法对应边(i,j)的egc
%使用两个矩阵，分别存储从两类节点的角度去比较
%考虑predictMat矩阵为n*m矩阵
n = size(predictMat,1);
m=size(predictMat,2);
%A矩阵用来表示从A节点角度进行比较
%n0MatA矩阵（i，j）处存储边（i，j）的预测值比i节点其他边的预测值大的次数
n0MatA = zeros(n,m);
%n1MatA矩阵（i，j）处存储边（i，j）的预测值和i节点其他边的预测值一样大的次数
n1MatA = zeros(n,m);
%NA矩阵保存和其他边比较的次数，因为计算egc需要和节点所有可能存在的边比较，故比较次数是n-2次
NA = ones(n,m)*(m-1);
%B矩阵用来表示从B节点角度进行比较
%n0MatB矩阵（i，j）处存储边（i，j）的预测值比j节点其他边的预测值大的次数
n0MatB = zeros(n,m);
%n1MatB矩阵（i，j）处存储边（i，j）的预测值和j节点其他边的预测值一样大的次数
n1MatB = zeros(n,m);
%NB矩阵保存和其他边比较的次数，因为计算egc需要和节点所有可能存在的边比较，故比较次数是n-2次
NB = ones(n,m)*(n-1);

 %j循环的值确定边(i,j)
 %循环k值用来比较(i,j)边和(i,k)边 
 %因为两条边之间只需要相互比较一次
 %当predictMat(i,j)>predictMat(i,k)时，只需更新n0Mat(i,j)
 %当predictMat(i,j)<predictMat(i,k)时，只需更新n0Mat(i,k)
 %predictMat(i,j)==predictMat(i,k)时，同时更新n1Mat(i,j)和n1Mat(i,k)
for i =1:n     %从A类节点出发 考虑
    for j=1:m-1 %二重循环用来比较
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


for i =1:m     %从B类节点出发 考虑
    for j=1:n-1 %二重循环用来比较
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