function DataProcessing(Ant_Selected,Sens_Selected,AntN,SensN,AID,SID, ...
     strAID,strSID,Data,Span,Method_Selected,minTemp,maxTemp,val1,val2)
if (ismember('All',Ant_Selected,'rows')) && (ismember('All',Sens_Selected,'rows'))
    for i=1:AntN
        for j=1:SensN
            CurrData = Data((Data(:,3)==AID(i) & Data(:,2)==SID(j)),:);
            CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp | isnan(CurrData(:,3)),:)=[];
            CurrAntSens = ['Data_',strAID(i,:), '_', strSID(j,:)];
            eval(['Data_Ori.', CurrAntSens, '=CurrData;'])
            if ~strcmp(Method_Selected , 'none')
                CurrData(:,5) = smooth(CurrData(:,5),Span,Method_Selected);
            end            
            eval(['Data_Selected.', CurrAntSens, '=CurrData;'])
            clear CurrData;
        end
    end
else
    if ismember('All',Ant_Selected,'rows')
        for i=1:AntN
            for j=1:length(val2)
                CurrData = Data((Data(:,3)==AID(i) & Data(:,2)==SID(val2(j)-1)),:);
                CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp | isnan(CurrData(:,3)),:)=[];
                CurrAntSens = ['Data_',strAID(i,:), '_', strSID(val2(j)-1,:)];
                eval(['Data_Ori.', CurrAntSens, '=CurrData;'])
                if ~strcmp(Method_Selected , 'none')
                    CurrData(:,5) = smooth(CurrData(:,5),Span,Method_Selected);
                end    
                eval(['Data_Selected.', CurrAntSens, '=CurrData;'])
                clear CurrData;
            end
        end
    else
        if ismember('All',Sens_Selected,'rows')
            for j=1:SensN
                i = val1-1;
                CurrData = Data((Data(:,3)==AID(i) & Data(:,2)==SID(j)),:);
                CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp | isnan(CurrData(:,3)),:)=[];
                CurrAntSens = ['Data_',strAID(i,:), '_', strSID(val2(j)-1,:)];
                eval(['Data_Ori.', CurrAntSens, '=CurrData;'])
                if ~strcmp(Method_Selected , 'none')
                    CurrData(:,5) = smooth(CurrData(:,5),Span,Method_Selected);
                end    
                eval(['Data_Selected.', CurrAntSens, '=CurrData;'])
                clear CurrData;
            end
        else
            if length(val2) == 1
                i = val1-1;
                j = val2-1;
                CurrData = Data((Data(:,3)==AID(i) & Data(:,2)==SID(j)),:);
                CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp | isnan(CurrData(:,3)),:)=[];
                CurrAntSens = ['Data_',strAID(i,:), '_', strSID(val2(j)-1,:)];
                eval(['Data_Ori.', CurrAntSens, '=CurrData;'])
                if ~strcmp(Method_Selected , 'none')
                    CurrData(:,5) = smooth(CurrData(:,5),Span,Method_Selected);
                end    
                eval(['Data_Selected.', CurrAntSens, '=CurrData;'])
                clear CurrData;
            else
                for j=1:length(val2)
                    i = val1-1;
                    CurrData = Data((Data(:,3)==AID(i) & Data(:,2)==SID(val2(j)-1)),:);
                    CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp | isnan(CurrData(:,3)),:)=[];
                    CurrAntSens = ['Data_',strAID(i,:), '_', strSID(val2(j)-1,:)];
                    eval(['Data_Ori.', CurrAntSens, '=CurrData;'])
                    if ~strcmp(Method_Selected , 'none')
                        CurrData(:,5) = smooth(CurrData(:,5),Span,Method_Selected);
                    end    
                    eval(['Data_Selected.', CurrAntSens, '=CurrData;'])
                    clear CurrData;
                end
            end
        end
    end
end
save('Data_Selected.mat', '-struct', 'Data_Ori');
save('Data_Processed.mat', '-struct', 'Data_Selected');


end