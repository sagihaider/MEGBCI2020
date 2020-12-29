function [data_tr, data_ts]=remove_bad_channels(data_tr, data_ts, bChan)

    for sessionid = 1:size(bChan, 2)
        disp(['Removing bad channel from Session :' num2str(sessionid)])
        nbadChan = bChan{1,sessionid};
         disp(nbadChan) 
        badchanarray = [];
        for eachbadChan = 1:size(nbadChan, 2)            
%             disp(nbadChan(eachbadChan))
            stri=cell2mat(nbadChan(eachbadChan));
            idx = find(strcmp(data_tr.label, stri(2:end)));
            badchanarray = [badchanarray, idx ];            
        end
        disp(badchanarray)
        if(sessionid == 1)
            for idel=1:size(data_tr.trial,2)
                data_tr.trial{1,idel}(badchanarray,:)=[];
            end            
        else
            for idel=1:size(data_ts.trial,2)
                data_ts.trial{1,idel}(badchanarray,:)=[];
            end            
        end
    end

end