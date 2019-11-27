load('D:\Matlab\Billel\indexing.mat')

auto_ccg_states_all = [];
metadata_all = [];

for i = 1:size(xmlpath,1)
    cd(xmlpath(i))
    if exist('Billel\Auto_CCG_State')
        cd('Billel\Auto_CCG_State')
        load('auto_ccg_states')

        auto_ccg_states_all = [auto_ccg_states_all ; auto_ccg_states];
        metadata_all = [metadata_all ; metadata];
    end
end

for i = 1:size(y)
    y.region(i) = x.region(ismember(x.ident,y.metadata_all(i,:),'rows'));
    y.type(i) = x.type(ismember(x.ident,y.metadata_all(i,:),'rows'));
end

