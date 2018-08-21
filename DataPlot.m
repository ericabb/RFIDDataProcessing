function DataPlot(Data,PathName,strAID_Selected,strSID_Selected,minTemp,maxTemp, ...
                SinglePlot,IntegratedPlot,SeperatedPlot)

%color = ['r';'g';'b';'c';'m';'y';'k'];
% Plotting_Waiting = waitbar(0,'Plotting ...'); % Waiting bar initial interface
% pause(0.5);
minRSSI = 0;
maxRSSI = 40;
maxSensNum = 20;
color = [[1 0 0];[0 1 0];[0 0 1];[1 1 0];[1 0 1];[0 1 1];...
    [0 0.79 0.34];[0.16 0.14 0.13];[0.18 0.55 0.34];[0.22 0.37 0.06];...
    [0.24 0.35 0.67];[0.5 0.16 0.16];[0.53 0.81 0.92];[0.54 0.17 0.89];...
    [0.61 0.4 0.12];[0.64 0.58 0.5];[0.74 0.99 0.79];[0.94 0.9 0.55];[1 0.27 0]];

[AntN_Selected,a] = size(strAID_Selected);
[SensN_Selected,a] = size(strSID_Selected);
if SensN_Selected > maxSensNum
    display(SID);
	error('The number of sensors exceeds the number of predefined colors');
end

AntN_Selected  = length(strAID_Selected);	%The total number of antenna
maxTime_Pre = 0;
% mark = false(SensN,AntN);%To mark non-null data

for i=1:AntN_Selected
    for j=1:SensN_Selected
        
        % Find the CurrData with the ith Ant and the jth Sensor
        eval(['CurrData = Data.Data_', strAID_Selected(i,:), '_', strSID_Selected(j,:), ';']) 
        if ~isempty(CurrData)
            maxTime_Cur = max(CurrData(:,1));
            maxTime = max(maxTime_Cur,maxTime_Pre);

            if (SeperatedPlot)
                g = figure(AntN_Selected*SensN_Selected*2+1+i);
                set(g,'NumberTitle','off',...
                    'Name',['Ant' '0'+strAID_Selected(i,:) '- All Sensors']);
                [row, col] = Seperating(SensN_Selected);
                subplot(row,col,floor((j-1)/col)*col+j);
                plot(CurrData(:,1),CurrData(:,5),'*','MarkerSize',2);
                xlim([0 maxTime])
                ylim([minTemp maxTemp])
                title(['Ant' strAID_Selected(i,:) '-' strSID_Selected(j,:)]);
                xlabel('Time/h');
                ylabel('Temperature/^oC');
                subplot(row,col,floor((j-1)/col)*col+j+col);
                plot(CurrData(:,1),CurrData(:,4),'*','MarkerSize',2);
                xlim([0 maxTime])
                ylim([minRSSI maxRSSI])
    %             title(['Ant' '0'+AID(i) '-' strSID(j,:)]);
                xlabel('Time/h');
                ylabel('RSSI/dB');       
            end

            if(SinglePlot)
                h = figure((i-1)*SensN_Selected+j);
                % Plot temperature by time
                subplot(2,1,1);
                plot(CurrData(:,1),CurrData(:,5),'*','MarkerSize',2);
                xlim([0 maxTime]);
                ylim([minTemp maxTemp]);
                xlabel('Time/h');
                ylabel('Temperature/^oC');
                title(['Ant' strAID_Selected(i,:) '-' strSID_Selected(j,:)]);

                % Plot RSSI by time
                subplot(2,1,2);
                plot(CurrData(:,1),CurrData(:,4),'*','MarkerSize',2);
                xlim([0 maxTime]);
                ylim([minRSSI maxRSSI]);
                xlabel('Time/h');
                ylabel('RSSI/dB');
                saveas(h,[PathName '\ Ant' strAID_Selected(i,:) '-' ...
                    strSID_Selected(j,:), '.jpg']);% Save figures
                close(h);
            end

            if (IntegratedPlot)
                % Plot temperature of total sensors
                f = figure(AntN_Selected*SensN_Selected*2+1);
                set(f,'NumberTitle','off','Name','All Sensors and Antennas');
                subplot(AntN_Selected,1,i);
                plot(CurrData(:,1),CurrData(:,5),'*','MarkerSize',2,'color',color(j,:));
                hold on
                xlim([0 maxTime]);
                ylim([minTemp maxTemp]);
                xlabel('Time/h');
                ylabel('Temperature/^oC');
                legend(strSID_Selected);
                title(['Ant- ' strAID_Selected(i,:)])
            end
            maxTime_Pre = maxTime;
        end
    end
    
    if (SeperatedPlot)
        g = figure(AntN_Selected*SensN_Selected*2+1+i);
        set(g,'outerposition',get(0,'screensize'));
        saveas(g,[PathName '\Ant',strAID_Selected(i,:),'- All Sensors (Seperated).jpg']);
        close(g);
    end
end
if (IntegratedPlot)
    f = figure(AntN_Selected*SensN_Selected*2+1);
    set(f,'outerposition',get(0,'screensize'));
    saveas(f,[PathName '\All Sensors and Antennas.jpg']);
    close(f);
end

% close(Plotting_Waiting);

