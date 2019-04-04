%%%%% Bipartite link prediction indices %%%%%

%%% Released under MIT License
%%% Copyright (c) 2015 Simone Daminelli, Josephine Thomas, Claudio Duran and Carlo Vittorio Cannistraci

% Please cite:
% Common neighbours and the local-community-paradigm for topological link prediction in bipartite networks
% Simone Daminelli, Josephine Thomas, Claudio Duran and Carlo Vittorio Cannistraci
% New Journal of Physics
% 2015

% INPUT
%   x => the bipartite network adjacency matrix
%        The matrix x must be in binary form, where 1 are existing links
%        and 0 missing links.

% OUTPUT
%   Type: an array with list of all missing links in the original bipartite network and the
%         respective scores for each method.
%   Organization: 
%      - first/second column: indices of the two adjacent nodes that take part
%        in the putative link. (putative in the sense that the link is currently
%        missing in the network but it might exist in the future)
%      - 3rd to 13th column: scores for the putative links according to the
%        different indices.
%   Details for each column of the matrix, from the 1st to the 13th:
%   node (row) | node (column) | cn | lcl | ra | aa | cra | caa | cpa | jc | pa | car | cjc

function [Sim] = cannistraci_bipartite_link_predictors(net)


%Find Putative links: links to predict (missing links in the current network topology)
[r,c]=find(net==0|net==1); % r (row index), c (column index) from matrix x
predict_links=[r c] ;
clear r c

%% Calculation
[cn,lcl,ra,aa,cra,caa,cpa,jc,pa,car,cjc]= computeLCP(net,predict_links);

%% Create output matrix with links likelihoods for each method 
predictions=[predict_links,cn,lcl,ra,aa,cra,caa,cpa,jc,pa,car,cjc];
[simrow,simcol]=size(net);
Sim_CN = reshape(predictions(:,3),simrow,simcol);
Sim_RA = reshape(predictions(:,5),simrow,simcol);
Sim_AA = reshape(predictions(:,6),simrow,simcol);
Sim_JC = reshape(predictions(:,10),simrow,simcol);
Sim_PA = reshape(predictions(:,11),simrow,simcol);

Sim_CAR = reshape(predictions(:,12),simrow,simcol);
Sim_CRA = reshape(predictions(:,7),simrow,simcol);
Sim_CAA = reshape(predictions(:,8),simrow,simcol);
Sim_CJC = reshape(predictions(:,13),simrow,simcol);
Sim_CPA = reshape(predictions(:,9),simrow,simcol);

Sim={Sim_CN,Sim_RA,Sim_AA,Sim_JC,Sim_PA,Sim_CAR,Sim_CRA,Sim_CAA,Sim_CJC,Sim_CPA};

%% Save the final predictions for each putative link
save('bipartite_link_predictions.mat','predictions')




%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Support Functions %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cn,lcl,ra,aa,cra,caa,cpa,jc,pa,car,cjc] = computeLCP(x,links)
% Main function to compute link likelihoods according to the methods described in the paper.
% Inputs: 
%   - a bipartite matrix x
%   - a list of links (Eg: row index, col index) to be assigned a
%     likelihood by each prediction method

s=size(links,1); % number of links

% Initialize variables
init=zeros(s,1);
% Arrays for each method
cn=init; 
lcl=init;
car=init;
jc=init;
cjc=init;
pa=init;
cpa=init;
ra=init;
cra=init;
aa=init;
caa=init;

% Empty cells for storing neighbours of row/col nodes
ne_r=cell(size(x,2),1); %存储c类节点的邻居节点
ne_c=cell(size(x,1),1); 

% compute neighbours (only for nodes in links)
nodes_r=unique(links(:,1));
nodes_c=unique(links(:,2));

parfor i=1:size(x,1)
    if any(i==nodes_r)
        ne_c{i}=find(x(i,:));
    end
end

parfor i=1:size(x,2)
    if any(i==nodes_c)
        ne_r{i}=find(x(:,i));
    end
end

deg_r_all=sum(x,2); % Degrees of all the row nodes
deg_c_all=sum(x,1); % Degrees of all the column nodes

parfor i=1:s    %s是边数
%for i=1:s
    % Parallized loop for each link in links
    
    % Take submatrix of neighbours of nodes involved in the link
    n_r=ne_r{links(i,2)};%第i条边的c类节点的邻居
    n_c=ne_c{links(i,1)};%第i条边的r类节点的邻居
    sx=x(n_r,n_c);
    
    % Find the neighbours in the submatrix 
    n_r=n_r(sum(sx,2)>0);
    n_c=n_c(sum(sx,1)>0);

    %%%%%% Methods %%%%%%
  
    lcl(i)=sum(sum(sx));% lcl count
    
    if lcl(i)>0
        
        % CNs of row_set and column_set and total
        cn_r=sum(sum(sx,1)>0);
        cn_c=sum(sum(sx,2)>0);
        cn(i)=cn_r+cn_c; % CN
        
        % Degree of row_node/column_node in the link at present
        deg_r=deg_r_all(links(i,1));
        deg_c=deg_c_all(links(i,2));
        
        jc(i)=cn(i)./(deg_r+deg_c); % JC
        car(i)=cn(i).*lcl(i); % CAR
        cjc(i)=car(i)./(deg_r+deg_c); % CJC
        
        % External links of row_node/column_node in the link at present
        ext_r=deg_r-cn_r;
        ext_c=deg_c-cn_c;
        
        cpa(i)=ext_r.*ext_c+ext_r.*car(i)+ext_c.*car(i)+car(i).*car(i); % CPA
        
        % Values needed for RA, AA
        a=[deg_r_all(n_r); deg_c_all(n_c)'];% all the degrees of CNs nodes put in one array
        
        % Values needed for CRA CAA
        ff_r=sum(sx,2) ;
        ff_r=ff_r(sum(sx,2)>0); % LCLs attached to CNs of row set
        ff_c=sum(sx,1);
        ff_c=ff_c(sum(sx,1)>0); % LCLs attached to CNs of col set
        ff=[ff_r;ff_c']; % array with all the LCLs attacted to the CNs each
        
        ra(i)=sum(1./a); % RA
        aa(i)=sum(1./log2(a)); % AA
        %aa(i)(isinf(aa(i))) = 0;  % 将除数为0得到的异常值置为0
        cra(i)=sum(ff./a); % CRA
        caa(i)=sum(ff./log2(a)); % CAA
    end
    
    pa(i)=deg_r_all(links(i,1)).*deg_c_all(links(i,2)); % PA
    
end
 aa(isinf(aa)) = 0;
 caa(isinf(caa)) = 0;
