function Data = ImportDataTianjinfeiyue(fileToRead,Flag_Single)
newData = cell2mat(importdata(fileToRead));
Temperature = str2num(newData(:,21:end));
Time = newData(:,1:19);
clear newData

num  = length(Temperature);
Day  = zeros(num,1);
Hour = zeros(num,1);
Min  = zeros(num,1);
Sec  = zeros(num,1);

if Flag_Single == 1
    Importing_Waiting = waitbar(0,'Importing Data'); %  Initialize the interface of waiting bar
    pause(0.5);
end

radio = 0.1;

for k = 1:num
    Day(k) = str2int2(Time(k,9:10));
    Hour(k) = str2int2(Time(k,12:13));
    Min(k) = str2int2(Time(k,15:16));
    Sec(k) = str2int2(Time(k,18:19));
    if Flag_Single == 1
        if k > radio*num
            waitbar(radio,Importing_Waiting,[num2str(radio*100) '%' ' Completed']); 
            radio = radio+0.1;
        end    
    end
end	
if Flag_Single == 1
    close(Importing_Waiting)
end
% if length(Months) == 2
%     Mon  = zeros(num,1);
%     Days = [31 28 31 30 31 30 31 31 30 31 30 31];
%     for k = 1:num
%         Mon(k) = str2int2(textdata{k+1,1}(7:8));
%     end
%     Index = Mon(:,1) == Months(2);
%     Day(Index) = Day(Index)+Days(Months(1));
% end

Time = Day*24 + Hour + Min/60 + Sec/3600;
TimeOffset = min(Time);
Time_New = Time - TimeOffset;    
Data = [Time_New Temperature];
end