function [ train test ] = DivideBiNet( net, ratioTrain)
%%划分训练集和测试集，保证训练集连通
    num_testlinks = ceil((1-ratioTrain) * nnz(net));      
    % 确定测试集的边数目
    [xindex, yindex] = find(net);  linklist = [xindex yindex];    
    % 将网络（邻接矩阵）中所有的边找出来，存入linklist  
    clear xindex yindex;  
    % 为每条边设置标志位，判断是否能删除
    test = sparse(size(net,1),size(net,2));                 
    while ((length(linklist)>2)&&(nnz(test) < num_testlinks) )
      
        %---- 随机选择一条边
        index_link = ceil(rand(1) * length(linklist));
        uid1 = linklist(index_link,1); 
        uid2 = linklist(index_link,2);    
 %%%%%%%%%%%%%此处需修改为（uid1的行是否存在非零元素）U（uid2的列存在非零元素），若存在删除此边。
       
         tempvector1 = net(uid1,:);
         tempvector2 = net(:,uid2);
         if  ~isempty(tempvector1)  && ~isempty(tempvector2)
             sign = 1;
         else
             sign = 0;
         end
   
             
        %----若此边可删除，则将之放入测试集中，并将此边从linklist中移除
        if sign == 1 %此边可以删除
            linklist(index_link,:) = []; 
            test(uid1,uid2) = 1;
            net(uid1,uid2) = 0;
        else
            linklist(index_link,:) = [];
            net(uid1,uid2) = 1;   
        
        end   
        % 结束-判断此边是否可以删除并作相应处理
    end
    % 结束（while）-测试集中的边选取完毕
    train = net;  test = test ;
    % 返回为训练集和测试集

