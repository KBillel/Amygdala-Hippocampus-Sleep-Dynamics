nb = 0;
for i = 1:length(xmlpath)
    session = xmlpath(i);
    cd(session)
    if ~exist('States.mat')
       continue
    end
    load('States.mat')

    events = [];

    for i=1:length(sws(:,1))
        if (sws(i,2)-sws(i,1)>50)
            in = sws(i,2)+2;
            for j = 1:length(Rem(:,1))
                if ((Rem(j,1)<in) & (in<Rem(j,2)) & Rem(j,2)-Rem(j,1) > 50)
                    in2 = Rem(j,2) + 2;
                    if length(sws(:,1)) ~= i
                        if (sws(i+1,1)<in2) & (in2<sws(i+1,2) & (sws(i+1,2)-sws(i+1,1)>50))
                            events = [events ; sws(i,1) sws(i,2) Rem(j,1) Rem(j,2) sws(i+1,1) sws(i+1,2)];
                            nb = nb+1;
                        end
                    end
                end
            end  
        end  
    end
    nb
%     for i=1:length(sws(:,1))
%         in = sws(i,2)+2;
%         for j = 1:length(Rem(:,1))
%             if (Rem(j,1)<in) & (in<Rem(j,2)) & (Rem(j,2) - Rem(j,1) > 49)
%                 events = [events ; sws(i,1) sws(i,2) Rem(j,1) Rem(j,2)];
%                 nb=nb+1;
%             end
%         end
% 
%     end
end
