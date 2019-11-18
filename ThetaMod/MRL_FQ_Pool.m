function pooled = MRL_FQ_Pool(input)
    pooled.hpc.sws.r = [];
    pooled.hpc.sws.p = [];

    pooled.hpc.rem.r = [];
    pooled.hpc.rem.p = [];

    pooled.bla.sws.r = [];
    pooled.bla.sws.p = [];

    pooled.bla.rem.r = [];
    pooled.bla.rem.p = [];

    pooled.hpc.rem.metadata = [];
    pooled.hpc.sws.metadata = [];
    pooled.bla.rem.metadata = [];
    pooled.bla.sws.metadata = [];

    pooled.f=[input{1}.f]

    for i = 1:length(input)
        pooled.hpc.sws.r = [pooled.hpc.sws.r ; input{i}.hpc.sws.r];
        pooled.hpc.sws.p = [pooled.hpc.sws.p ; input{i}.hpc.sws.p];

        pooled.hpc.rem.r = [pooled.hpc.rem.r ; input{i}.hpc.rem.r];
        pooled.hpc.rem.p = [pooled.hpc.rem.p ; input{i}.hpc.rem.p];

        pooled.bla.sws.r = [pooled.bla.sws.r ; input{i}.bla.sws.r];
        pooled.bla.sws.p = [pooled.bla.sws.p ; input{i}.bla.sws.p];

        pooled.bla.rem.r = [pooled.bla.rem.r ; input{i}.bla.rem.r];
        pooled.bla.rem.p = [pooled.bla.rem.p ; input{i}.bla.rem.p];

        pooled.hpc.rem.metadata = [pooled.hpc.rem.metadata ; input{i}.hpc.rem.metadata];
        pooled.hpc.sws.metadata = [pooled.hpc.sws.metadata ; input{i}.hpc.sws.metadata];
        pooled.bla.rem.metadata = [pooled.bla.rem.metadata ; input{i}.bla.rem.metadata];
        pooled.bla.sws.metadata = [pooled.bla.sws.metadata ; input{i}.bla.sws.metadata];
    end
end