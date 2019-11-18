function [rem_length,sws_length] = sleepTime(session)
    load('D:\Matlab\Billel\indexing.mat')
    index = ratsessionindex(xmlpath == session,:);
    rat = index(1);
    jour = index(2);

    cd(session)
    load('States.mat')
    
    rem_length = Rem (:,2) - Rem(:,1)
    sws_length = sws (:,2) - sws(:,1)
end
