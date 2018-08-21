
function varargout = GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes during object creation, after setting all properties.
function table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Edit_PathName,'String','');
set(handles.Edit_AnNum,'String','');
set(handles.Edit_SenNum,'String','');
% [FileName,PathName,FilterIndex] =  uigetfile({'*.csv';'*.*'},...
%     'Select files to import','MultiSelect','on');
PathName = uigetdir;    % Get the dir of the data file
set(handles.Edit_PathName,'String',PathName);

% handles.FileName = FileName;
handles.PathName = PathName;

% assignin('base','FileName',FileName);   %Save the data into workspace
assignin('base','PathName',PathName);

guidata(hObject,handles);




% --- Executes on button press in importButton.
function importButton_Callback(hObject, eventdata, handles)
% hObject    handle to importButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.Popup_Ant,'String','');
set(handles.Listbox_Sens,'String','n/a');
set(handles.Edit_AnNum,'String','');
set(handles.Edit_SenNum,'String','');

% FileName = handles.FileName;
PathName = handles.PathName;
DataType = get(handles.Popup_DataType,'Value');
if DataType == 1
    Data = LoadingDataRTEC(PathName,'Data_Original.mat');
end
if DataType == 2
    Data = LoadingDataIntelliSAW(PathName,'Data_Original.mat');
end
if DataType == 3
    Data = LoadingDataShengliSAW(PathName,'Data_Original.mat');
end
if DataType == 4
    Data = LoadingDataTianjinfeiyue(PathName,'Data_Original.mat');
end
if DataType == 5
    Data = LoadingDataYuehe(PathName,'Data_Original.mat');
end

Data(:,1) = Data(:,1)-min(Data(:,1));
maxTime = max(Data(:,1));
SID = unique(Data(:,2));    % Sensor ID
strSID = num2str(SID);      % Transform Sensor ID into string format
AID = unique(Data(:,3));    % Antanna ID
strAID = num2str(AID);      % Transform Antenna ID into string format
SensN = length(SID);        % The number of sensors
AntN  = length(AID);        % The number of Antanna

set(handles.Edit_AnNum,'String',num2str(AntN));
set(handles.Edit_SenNum,'String',num2str(SensN));

Importing_Done = msgbox('Importing Done£¡','Reminder','help','modal');
ht = findobj(Importing_Done, 'Type', 'text');
set(ht, 'FontSize', 15, 'Unit', 'normal');

strAID_new = '';
for i = 1:AntN
    strAID_new = [strAID_new,strAID(i,:),'|'];
end
strAID_new = strAID_new(:,1:end-1);
set(handles.Popup_Ant,'String',['All|',strAID_new]);

strSID_new = '';
for i = 1:SensN
    strSID_new = [strSID_new,strSID(i,:),'|'];
end
strSID_new = strSID_new(:,1:end-1);
set(handles.Listbox_Sens,'String',['All |',strSID_new]);

handles.Data = Data;
handles.PathName = PathName;

assignin('base','Data',Data);   %Save the data into workspace
assignin('base','PathName',PathName);

guidata(hObject,handles);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


Data = handles.Data;
PathName = handles.PathName;
% maxTime = max(Data(:,1));
SID = unique(Data(:,2));%Sensor ID
strSID = num2str(SID);	%Transfor SID into string
AID = unique(Data(:,3));%Antanna ID
strAID = num2str(AID);	%Transfor AID into string
SensN = length(SID);	%The total number of sensors
AntN  = length(AID);	%The total number of antenna
mark = false(SensN,AntN);%To mark non-null data

list1 = get(handles.Popup_Ant,'String');
val1 = get(handles.Popup_Ant,'Value');
Ant_Selected = list1(val1,:);
% assignin('base','list1',list1);
% assignin('base','val1',val1);
% assignin('base','Ant_Selected',Ant_Selected);

list2 = get(handles.Listbox_Sens,'String');
val2 = get(handles.Listbox_Sens,'Value');
Sens_Selected = list2(val2,:);
% assignin('base','list2',list2);
% assignin('base','val2',val2);
% assignin('base','Sens_Selected',Sens_Selected);

val3 = get(handles.Popup_Method,'Value');
switch val3
    case 1
        Method_Selected = 'moving';
    case 2
        Method_Selected = 'rlowess';
    case 3
        Method_Selected = 'rloess';
    case 4
        Method_Selected = 'sgolay';
    case 5
        Method_Selected = 'none';
end
Span = str2double(get(handles.Edit_Span,'String'));

minTemperature = str2double(get(handles.Edit_minTemp,'String'));
maxTemperature = str2double(get(handles.Edit_maxTemp,'String'));

DataProcessing(Ant_Selected,Sens_Selected,AntN,SensN,AID,SID, ...
     strAID,strSID,Data,Span,Method_Selected,minTemperature,maxTemperature,val1,val2);
 
Data = load('Data_Processed.mat'); % Load the preprocessed data
AntSensor_Selected = char(fieldnames(Data));
strAID_Selected = unique(AntSensor_Selected(:,6),'rows');%Sensor ID
[m,n] = size(AntSensor_Selected);
if n == 10
    strSID_Selected = unique(AntSensor_Selected(:,8:10),'rows');%Sensor ID
else
    if n == 11
        strSID_Selected = unique(AntSensor_Selected(:,8:11),'rows');%Sensor ID
    end
end
[AntN_Selected,a] = size(strAID_Selected);
[SensN_Selected,a] = size(strSID_Selected);

handles.AntN_Selected = AntN_Selected;
handles.SensN_Selected = SensN_Selected;
handles.strAID_Selected = strAID_Selected;
handles.strSID_Selected = strSID_Selected;
assignin('base','strAID_Selected',strAID_Selected);
assignin('base','strSID_Selected',strSID_Selected);
guidata(hObject,handles); 
h=msgbox('Preprocessing Done£¡','Reminder','help','modal');



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
minTemperature = str2double(get(handles.Edit_minTemp,'String'));
maxTemperature = str2double(get(handles.Edit_maxTemp,'String'));
PathName = handles.PathName;
Data = load('Data_Processed.mat'); % Load the preprocessed data
strAID_Selected = handles.strAID_Selected;
strSID_Selected = handles.strSID_Selected;

SinglePlot = get(handles.Check_SingleSensor,'Value');
IntegratedPlot = get(handles.Check_Integrated,'Value');
SeperatedPlot = get(handles.Check_Seperated,'Value');

DataPlot(Data,PathName,strAID_Selected,strSID_Selected,minTemperature,maxTemperature, ...
                SinglePlot,IntegratedPlot,SeperatedPlot);
            

guidata(hObject,handles); 
h=msgbox('Ploting Done£¡','Reminder','help','modal');




% --- Executes on button press in Button_DataReliability.
function Button_DataReliability_Callback(hObject, eventdata, handles)
% hObject    handle to Button_DataReliability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PathName = handles.PathName;
minTemperature = str2double(get(handles.Edit_minTemp,'String'));
maxTemperature = str2double(get(handles.Edit_maxTemp,'String'));

list1 = get(handles.Popup_Ant,'String');
val1 = get(handles.Popup_Ant,'Value');
Ant_Selected = list1(val1,:);
list2 = get(handles.Listbox_Sens,'String');
val2 = get(handles.Listbox_Sens,'Value');
Sens_Selected = list2(val2,:);
Ant_Selected(find(isspace(Ant_Selected))) = [];
Sens_Selected(find(isspace(Sens_Selected))) = [];
AntN_Selected = length(Ant_Selected);
[SensN_Selected,a] = size(Sens_Selected);
if AntN_Selected*SensN_Selected ==1
    DeltaT = str2double(get(handles.Edit_DeltaT,'String'));
    Radio = DataReliability(DeltaT,Ant_Selected,Sens_Selected, ...
   minTemperature,maxTemperature,PathName);
    set(handles.Edit_Confidence,'String',[num2str(Radio*100),'%']);
    h=msgbox('Analyze Done£¡','Reminder','help','modal');
else
    h=msgbox('Please Select 1 Sensor with 1 Antenna£¡','Reminder','help','modal');
end



















% --- Executes on button press in pushbutton4.
function Listbox_Sens_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function Edit_minTemp_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_minTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_minTemp as text
%        str2double(get(hObject,'String')) returns contents of Edit_minTemp as a double


% --- Executes during object creation, after setting all properties.
function Edit_minTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_minTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_maxTemp_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_maxTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_maxTemp as text
%        str2double(get(hObject,'String')) returns contents of Edit_maxTemp as a double


% --- Executes during object creation, after setting all properties.
function Edit_maxTemp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_maxTemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in Popup_Ant.
function Popup_Ant_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_Ant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_Ant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_Ant


% --- Executes during object creation, after setting all properties.
function Popup_Ant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Popup_Ant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function Popup_Method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function Edit_Span_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Row as text
%        str2double(get(hObject,'String')) returns contents of Edit_Row as a double



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function Edit_AnNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Edit_Span_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Listbox_Sens_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Edit_PathName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Edit_SenNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Popup_Method.
function Popup_Method_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_Method

% --- Executes on selection change in Popup_Method.
function Check_SingleSensor_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_Method

% --- Executes on selection change in Popup_Method.
function Check_Seperated_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_Method

% --- Executes on selection change in Popup_Method.
function Check_Integrated_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_Method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_Method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_Method







function Edit_DeltaT_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_DeltaT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_DeltaT as text
%        str2double(get(hObject,'String')) returns contents of Edit_DeltaT as a double


% --- Executes during object creation, after setting all properties.
function Edit_DeltaT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_DeltaT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_Confidence_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_Confidence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_Confidence as text
%        str2double(get(hObject,'String')) returns contents of Edit_Confidence as a double


% --- Executes during object creation, after setting all properties.
function Edit_Confidence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_Confidence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in importButton.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to importButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Edit_AnNum_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_AnNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_AnNum as text
%        str2double(get(hObject,'String')) returns contents of Edit_AnNum as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_AnNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_SenNum_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_SenNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_SenNum as text
%        str2double(get(hObject,'String')) returns contents of Edit_SenNum as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_SenNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Edit_PathName_Callback(hObject, eventdata, handles)
% hObject    handle to Edit_PathName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Edit_PathName as text
%        str2double(get(hObject,'String')) returns contents of Edit_PathName as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Edit_PathName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on selection change in Popup_DataType.
function Popup_DataType_Callback(hObject, eventdata, handles)
% hObject    handle to Popup_DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Popup_DataType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Popup_DataType


% --- Executes during object creation, after setting all properties.
function Popup_DataType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Popup_DataType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
