% =========================================================================
% This function is used for import data file exported by FN software
% and store them in a *.mat file.
% =========================================================================
function Data = LoadingDataTianjinfeiyue(PathName, SaveFileName)
%% Arguments check
% Check the number of input arguments to provide more flexable use of this
% function
if nargin <= 0
    errordlg('There is no sufficient input arguments!','Error');
    return;
elseif nargin == 1
%     uiwait(msgbox('There is only one input argument.', 'Message','modal'));
elseif nargin == 2
%     uiwait(msgbox('There are two input arguments.', 'Message','modal'));
else
%     uiwait(msgbox('There are more than 2 input arguments.', 'Message','modal'));
end     

%% Loading data files 
% Check the number of data files in the designated folder.
% List the file names under the designated folder, *.csv files
FileName = dir(strcat(PathName,'\*.txt'));

% Check the total number of csv data files
NumFiles = length(FileName);
if NumFiles <= 0
    errordlg('There is no data file can be found in this folder!','Error');
    return;
else
    if NumFiles == 1 % Single file to be imported
    %     Data = ImportFileFN([PathName FileName]);
        Data = ImportDataTianjinfeiyue([PathName '\' FileName.name],1);
    else % Multi files to be imported
        Importing_Waiting = waitbar(0,'Importing Data ...'); % Initialize the interface of waiting bar
        pause(0.5);
        Data = ImportDataTianjinfeiyue([PathName '\' FileName(1).name],0);
    %     Data = ImportFileFN([PathName FileName{1}]);
        waitbar(1/length(FileName),Importing_Waiting,[num2str(1/length(FileName)*100) '%' ' Completed']); 
        for i = 2:length(FileName)
            Data = [Data; ImportDataTianjinfeiyue([PathName '\' FileName(i).name],0)];
    %         Data = [Data; ImportFileFN([PathName FileName{i}])];
            waitbar(i/length(FileName),Importing_Waiting,[num2str(i/length(FileName)*100) '%' ' Completed']); 
        end
        close(Importing_Waiting);
    end
end


%% Save the data to *.mat file
File2Save = strcat(PathName, '\', SaveFileName); % File to save
save(File2Save, 'Data');
