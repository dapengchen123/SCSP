%%%%%%%%%%%%% data partition for viper %%%%%%%%%%%%%%

     for t=1:100
        in = randperm(632);
        for p=1:Ntr
           parti(t).trnSet(p)=in(p);   
        end
        ntst = 0;
        for p = (Ntr+1):632
           ntst = ntst + 1;
           parti(t).tstSet(ntst)=in(p);  
        end
       
     end
    


