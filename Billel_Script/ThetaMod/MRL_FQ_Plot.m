function MRL_FQ_Plot(input,BLA)
    ticklabel = (input.f(2:2:end)+input.f(3:2:end))/2;
    %Can't understand how this is behaving. Condition on 2 dimentional
    %array and simple array
   
    bla_rem_p = input.bla.rem.p(ismember(input.bla.rem.metadata(:,1:3),BLA,'rows') & input.bla.rem.r(:,2) > 0.04 & input.bla.rem.p(:,2) < 0.01,:)<0.01;
    bla_rem_p = input.bla.rem.p(ismember(input.bla.rem.metadata(:,1:3),BLA,'rows') & input.bla.rem.r(:,2) > 0.04 & input.bla.rem.p(:,2) < 0.01,:)
    
    bla_rem_r = input.bla.rem.r(ismember(input.bla.rem.metadata(:,1:3),BLA,'rows') & input.bla.rem.r(:,2) > 0.04 & input.bla.rem.p(:,2) < 0.01,:)>0.04;
    bla_rem_r = input.bla.rem.r(ismember(input.bla.rem.metadata(:,1:3),BLA,'rows') & input.bla.rem.r(:,2) > 0.04 & input.bla.rem.p(:,2) < 0.01,:)
%     bla_rem_r = zscore(bla_rem_r')';
    bla_sws_p = input.bla.sws.p<0.01;
    bla_sws_r = input.bla.sws.r>0.04;

    hpc_rem_p = input.hpc.rem.p(ismember(input.hpc.rem.metadata(:,1:3),BLA,'rows') & input.hpc.rem.r(:,2) > 0.04 & input.hpc.rem.p(:,2) < 0.01,:)<0.01;
    hpc_rem_r = input.hpc.rem.r(ismember(input.hpc.rem.metadata(:,1:3),BLA,'rows') & input.hpc.rem.r(:,2) > 0.04 & input.hpc.rem.p(:,2) < 0.01,:)>0.04;
    disp (size(bla_rem_p))
    hpc_sws_p = input.hpc.sws.p<0.01;
    hpc_sws_r = input.hpc.sws.r>0.04;

    figure;
    imagesc(zscore(input.bla.rem.r(ismember(input.bla.rem.metadata(:,1:3),BLA,'rows'),:)')');
    title('BLA REM')
    xticklabels(ticklabel)

%     figure;
%     imagesc(bla_sws_p.*bla_sws_r);
%     title('BLA SWS')
%     xticklabels(ticklabel)
% 
%     figure;
%     imagesc(hpc_rem_p.*hpc_rem_r);
%     title('hpc REM')
%     xticklabels(ticklabel)
% 
%     figure;
%     imagesc(hpc_sws_p.*hpc_sws_r);
%     title('hpc SWS')
%     xticklabels(ticklabel)
end