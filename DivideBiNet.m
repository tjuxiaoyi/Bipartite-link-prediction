function [ train test ] = DivideBiNet( net, ratioTrain)
%%����ѵ�����Ͳ��Լ�����֤ѵ������ͨ
    num_testlinks = ceil((1-ratioTrain) * nnz(net));      
    % ȷ�����Լ��ı���Ŀ
    [xindex, yindex] = find(net);  linklist = [xindex yindex];    
    % �����磨�ڽӾ��������еı��ҳ���������linklist  
    clear xindex yindex;  
    % Ϊÿ�������ñ�־λ���ж��Ƿ���ɾ��
    test = sparse(size(net,1),size(net,2));                 
    while ((length(linklist)>2)&&(nnz(test) < num_testlinks) )
      
        %---- ���ѡ��һ����
        index_link = ceil(rand(1) * length(linklist));
        uid1 = linklist(index_link,1); 
        uid2 = linklist(index_link,2);    
 %%%%%%%%%%%%%�˴����޸�Ϊ��uid1�����Ƿ���ڷ���Ԫ�أ�U��uid2���д��ڷ���Ԫ�أ���������ɾ���˱ߡ�
       
         tempvector1 = net(uid1,:);
         tempvector2 = net(:,uid2);
         if  ~isempty(tempvector1)  && ~isempty(tempvector2)
             sign = 1;
         else
             sign = 0;
         end
   
             
        %----���˱߿�ɾ������֮������Լ��У������˱ߴ�linklist���Ƴ�
        if sign == 1 %�˱߿���ɾ��
            linklist(index_link,:) = []; 
            test(uid1,uid2) = 1;
            net(uid1,uid2) = 0;
        else
            linklist(index_link,:) = [];
            net(uid1,uid2) = 1;   
        
        end   
        % ����-�жϴ˱��Ƿ����ɾ��������Ӧ����
    end
    % ������while��-���Լ��еı�ѡȡ���
    train = net;  test = test ;
    % ����Ϊѵ�����Ͳ��Լ�

