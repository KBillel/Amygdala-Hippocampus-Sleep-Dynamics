function [EV, REV] = StateCorrMatrixAll(str_name,binSize)
    load('D:\Matlab\Billel\indexing.mat')
    load('Z:\All-Rats\Structures\structures.mat')
    
    if size(str_name,2)==2
        file_path = ['Billel/CorrMatrix/CorrMatrixAll' '_' num2str(binSize) '.mat'];
        str1 = eval(str_name(1));
        str2 = eval(str_name(2));
        all = true;
    else 
        file_path = ['Billel/CorrMatrix/CorrMatrix' str_name '_' num2str(binSize) '.mat'];
        all = false;
    end
    
    StateCorrMatrix.data = [];
    StateCorrMatrix.metadata.session = [];
    StateCorrMatrix.metadata.binSize = binSize;
    StateCorrMatrix.metadata.str = str_name;
    
    excluded = 0;
    for i = 1:size(xmlpath,1)
        cd(xmlpath(i))
        if exist(file_path)
            load(file_path)
            
            if all
                isStr1 = metadata(ismember(metadata(:,1:3),str1,'rows'),5);
                isStr2 = metadata(ismember(metadata(:,1:3),str2,'rows'),5);
                
                for j = 1:size(corrMatrix,1)
                    corrMatrix.Corr{j} = corrMatrix.Corr{j}(isStr1,isStr2);
                    corrMatrix.pVal{j} = corrMatrix.pVal{j}(isStr1,isStr2);
                end
                
            else
                if size(CorrMatrix.run.matrix,1)<7 || size(CorrMatrix.run.matrix,2)<7
                    excluded = excluded +1;
                    continue
                end    
            end
            
            StateCorrMatrix.data = [StateCorrMatrix.data ; CorrMatrix];
            StateCorrMatrix.metadata.session = [StateCorrMatrix.metadata.session; xmlpath(i)];
        else
            disp(xmlpath(i)+file_path + " not found")
        end
    end

    if isempty(StateCorrMatrix.data)
         disp(['CorrMatrix' str_name '_' num2str(binSize) '.mat could not be found in any session. Check that StateCorrMatrix has been run with those parameters']);
    else
        disp(size(StateCorrMatrix.data,1)+ " Sessions were loaded")
        disp(excluded + " sessions were excluded because not enough cells inside")
    end
    
    
    
    EV.peaks = [];
    REV.peaks = [];

    EV.troughs = [];
    REV.troughs = [];
    
    EV.sws = [];
    REV.sws = [];
    for i = 1:size(StateCorrMatrix.data,1)
        run = StateCorrMatrix.data(i).run.matrix;
        pre.peaks = StateCorrMatrix.data(i).pre.rem.peaks.matrix;
        post.peaks = StateCorrMatrix.data(i).post.rem.peaks.matrix;

        pre.troughs = StateCorrMatrix.data(i).pre.rem.troughs.matrix;
        post.troughs = StateCorrMatrix.data(i).post.rem.troughs.matrix;
        
        pre.sws = StateCorrMatrix.data(i).pre.sws.matrix;
        post.sws = StateCorrMatrix.data(i).post.sws.matrix;

        [EVi, REVi] = ExplainedVariance(run,pre.peaks,post.peaks);
        EV.peaks = [EV.peaks ; EVi*100];
        REV.peaks = [REV.peaks ; REVi*100];

        [EVi, REVi] = ExplainedVariance(run,pre.troughs,post.troughs);
        EV.troughs = [EV.troughs ; EVi*100];
        REV.troughs = [REV.troughs ; REVi*100];
        
        
        [EVi, REVi] = ExplainedVariance(run,pre.sws,post.sws);
        EV.sws = [EV.sws ; EVi*100];
        REV.sws = [REV.sws ; REVi*100];
    end

    figure;
    boxplot([EV.sws REV.sws])

    title(['EV and REV for ' str_name ' with binSize = ' num2str(binSize) 's'])
end