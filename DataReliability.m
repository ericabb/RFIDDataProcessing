function Radio = DataReliability(DeltaT,Ant_Selected,Sens_Selected,minTemp, maxTemp,PathName)

% Define the time interval
Time_Interval = 60; 

% The minumus and maximum RSSI during the process of the experiment
minRSSI = 0;    
maxRSSI = 40;

color = [[0 0 0];[1 0 0];[0 1 0];[0 0 1];[1 1 0];[1 0 1];[0 1 1];...
    [0 0.79 0.34];[0.16 0.14 0.13];[0.18 0.55 0.34];[0.22 0.37 0.06];...
    [0.24 0.35 0.67];[0.5 0.16 0.16];[0.53 0.81 0.92];[0.54 0.17 0.89];...
    [0.61 0.4 0.12];[0.64 0.58 0.5];[0.74 0.99 0.79];[0.94 0.9 0.55];[1 0.27 0]];


Data_Selected= load('Data_Selected.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%No need to revise unless special cases

% import and process orginal data
% Data contains£ºTime£¬last 4 number of EPC£¬AntNum£¬RSSI£¬Temperature
% Data = ImportDataFN(fileToRead);
% Analyzing_Waiting = waitbar(0,'Analyzing ...'); % Initialize the interface of waiting bar
pause(0.5);
% Find the CurrData with the ith Ant and the jth Sensor
eval(['CurrData = Data_Selected.Data_', Ant_Selected, '_', Sens_Selected, ';']) 
CurrData( CurrData(:,5)<minTemp | CurrData(:,5)>maxTemp ,:)=[];
if ~isempty(CurrData)
    CurrData = sortrows(CurrData,1);
    Temperature = CurrData(:,5);
    Time_Second = CurrData(:,1).*3600;   % Time with the unit of second
    Time_Total = max(Time_Second);  % Totol time
    Time_Group = ceil(Time_Total / Time_Interval);      % Group to divide
    Time_Cut = zeros(Time_Group,1);
    Temperature_New = zeros(Time_Group,1);
    for m=1:(length(CurrData(:,1))-1)
        for n=1:Time_Group
            if ((Time_Second(m) < (n*Time_Interval)) && (Time_Second(m+1) >= (n*Time_Interval)))
                % Find the place to divide
                Time_Cut(n) = m+1; 
                if n==1
                    Temperature_New(n) = mean(Temperature(1:Time_Cut(n)));
                else
                    % Compute the average of every group
                    Temperature_New(n) = mean(Temperature(Time_Cut(n-1):Time_Cut(n))); 
                end
            end
        end
    end 
    Time_New = [0:Time_Interval:Time_Total]./3600; % New X-axis
    Temperature_Reference = interp1(Time_New,Temperature_New,CurrData(:,1),'line');
    Temperature_Reference = smooth(Temperature_Reference,500,'moving');
    Temperature_Error = abs(CurrData(:,5)-Temperature_Reference);
    Radio = 1-(sum(Temperature_Error(:)>DeltaT))/length(CurrData(:,5));

    h = figure();
    plot(CurrData(:,1),CurrData(:,5),'.','MarkerSize',3.7,'color',color(4,:));
    hold on
    plot(CurrData(:,1),Temperature_Reference,'*','MarkerSize',2,'color','r')
    hold on
    fill1 = fill([CurrData(1:end-100,1);CurrData(end-100:-1:1,1)], ...
        [Temperature_Reference(1:end-100,1)+DeltaT;Temperature_Reference(end-100:-1:1,1)-DeltaT],color(5,:));
    alpha(fill1,0.5);
%         set(fill1,'FaceColor',color(5,:));
    set(fill1,'LineStyle','none');
    legend('Original Data','Reference Data','Confidence Interval');
    xlim([0 max(CurrData(:,1))-5])
    ylim([minTemp maxTemp])
    xlabel('Time/h');
    ylabel('Temperature/^oC');
    title(['Ant-',num2str(Ant_Selected),', Sensor-',num2str(Sens_Selected),', DeltaT = ',num2str(DeltaT), ', Confidence Ratio = ', ...
        num2str(Radio*100), '%']);
    set(h,'Position',get(0,'ScreenSize'));
    saveas(h,[PathName '\Ant-',num2str(Ant_Selected),', Sen' num2str(Sens_Selected) '-DeltaT = ',num2str(DeltaT),'.jpg']);      
    close(h);
%     if i*j == 1
%         waitbar(1/AntN_Selected/SensN_Selected,Analyzing_Waiting, ...
%             [num2str(1/AntN_Selected/SensN_Selected*100) '%' ' Completed']); 
%     else
%         waitbar(i*j/AntN_Selected/SensN_Selected,Analyzing_Waiting, ...
%             [num2str(i*j/AntN_Selected/SensN_Selected*100) '%' ' Completed']); 
%     end
end
% close(Analyzing_Waiting);
end


