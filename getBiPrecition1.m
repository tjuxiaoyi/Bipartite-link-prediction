function [ prec ] = getBiPrecition1( train,test, sim, L )
   mat=sim.*(1-train); %测试集和不存在边集合中的相似性
   [m,n]=size(mat);
    vec=zeros(m*n,3);
    k=0;
    for i=1:m
        for j=1:n
            k=k+1;
            vec(k,:)=[mat(i,j),i,j];
        end
    end
    vec=sortrows(vec,1);
    cnt=0;
    i=0;
    while i<L
        xy=vec(k-i,:);
        
        if test(xy(2),xy(3))==1
            
            cnt=cnt+1;    
        end
        i=i+1;
    end
    prec=cnt/L;

end

