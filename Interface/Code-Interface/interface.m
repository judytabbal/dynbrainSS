function varargout = interface(varargin)
%INTERFACE MATLAB code file for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to interface_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      INTERFACE('CALLBACK') and INTERFACE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in INTERFACE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 12-Jun-2020 13:27:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;


set(handles.text8,'visible','off')
set(handles.time_elap,'visible','off')
set(handles.uipanel9,'visible','off')
set(handles.buttonGo,'visible','off')

I=imread('brain_connections.png');
I1=imread('sig_yellow.jpg');
I2=imread('sig_red.jpg');
I3=imread('sig_blue.jpg');

axes(handles.axes1);
imshow(I)
% set(handles.axes1,'handlevisibility','off', 'visible','off')
% view(handles.axes1,[30 60])

axes(handles.axes2);
imshow(I)
% set(handles.axes2,'handlevisibility','off', 'visible','off')
% view(handles.axes2,[30 60])

axes(handles.axes3);
imshow(I)
% set(handles.axes3,'handlevisibility','off', 'visible','off')
% view(handles.axes3,[30 60])

axes(handles.axes6);
imshow(I1)
set(handles.axes6,'handlevisibility','off', 'visible','off')

axes(handles.axes7);
imshow(I2)
set(handles.axes7,'handlevisibility','off', 'visible','off')

axes(handles.axes8);
imshow(I3)
set(handles.axes8,'handlevisibility','off', 'visible','off')


clear global cmat_list;
clear global NICs;
clear global results;
clear global timeElapsed;
clear global dist
clear global label
clear global disp_concat
clear global thresh

global data_nb
global method_id
global NICs
global cmat_list
data_nb = get(handles.menuData,'value');
method_id = get(handles.menuMethod,'value');
NICs=str2num(get(handles.editNICs,'String'));

% change the below line to your corresponding path
global files_base
files_base = 'C:\Users\imanm\Desktop\PhD\Matlab\dynBrainSS\Interface\Data-Interface';
files_base2 = 'C:\Users\imanm\Desktop\PhD\Matlab\dynBrainSS';

subject1 = { '001'; '002' ; '003' ; '004' ; '005'; '006' ; '007' ; '008' ; '009'; '010' ; '011' ; '012' ; '013'; '014' ; '015'};
for i=1:length(subject1)
    cmat_list{i} = [files_base '\1-Motor_Self-paced\' subject1{i} '_demo.mat'];  
end

tmp = which('ft_defaults');
if isempty(tmp)
    % change the below line to wherever your copy of fieldtrip resides
    addpath([files_base2 '\fieldtrip-20190224']);
    ft_defaults
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in menuData.
function menuData_Callback(hObject, eventdata, handles)
% hObject    handle to menuData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuData
clear global cmat_list
clear global data_nb
clear global newS_noise
clear global n_parcels
clear global time_wind
global cmat_list
global data_nb
global newS_noise;
global n_parcels;
global time_wind;
global files_base

set(handles.pushbutton3,'BackgroundColor',[1,1,1])
set(handles.msgUp,'visible','off')
val_data = get(hObject,'value');
switch val_data
    
    
case 1
    set(handles.menuData,'BackgroundColor',[0.95,1,0.95])
    set(handles.pushbutton3,'BackgroundColor',[1,1,1])
    set(handles.msgUp,'visible','off')
    disp('Motor1 Self-paced Dataset Selected.')
    data_nb=1;
    subject1 = { '001'; '002' ; '003' ; '004' ; '005'; '006' ; '007' ; '008' ; '009'; '010' ; '011' ; '012' ; '013'; '014' ; '015'};
    for i=1:length(subject1)
        cmat_list{i} = [files_base '\1-Motor_Self-paced\' subject1{i} '_demo.mat'];  
    end
case 2
    set(handles.menuData,'BackgroundColor',[0.95,1,0.95])
    set(handles.pushbutton3,'BackgroundColor',[1,1,1])
    set(handles.msgUp,'visible','off')
    disp('Motor2 HCP Dataset Selected.')
    data_nb=2;
    subject2 = { '104012'; '105923' ; '106521' ; '108323' ; '109123'; '113922' ; '116726' ; '125525'; '133019'; '140117'; '151526'; '153732'; '156334'; '162026'; '162935'; '164636'; '169040'; '175237'; '177746'; '185442'; '189349'; '191033'; '191437'; '191841'; '192641'; '198653'; '200109'; '204521'; '205119'; '212318'; '212823'; '221319' ; '250427' ; '255639' ; '257845'; '283543' ; '287248' ; '293748'; '353740'; '358144'; '406836'; '500222'; '559053'; '568963'; '581450'; '599671'; '601127' ; '660951' ; '662551' ; '667056'; '679770' ; '680957' ; '706040'; '707749'; '725751'; '735148'; '783462'; '814649'; '891667'; '898176'; '912447'  };
    for i=1:length(subject2)
        cmat_list{i} = [files_base '\2-Motor_HCP-LH\' subject2{i} '_LH1-30100_alldemo.mat'];  
    end
case 3
    set(handles.menuData,'BackgroundColor',[0.95,1,0.95])
    set(handles.pushbutton3,'BackgroundColor',[1,1,1])
    set(handles.msgUp,'visible','off')
    disp('Working Memory Dataset Selected.')
    data_nb=3;
    subject3 = { '001'; '002' ; '003' ; '004' ; '005'; '006' ; '007' ; '008' ; '009'; '010' ; '011' ; '012' ; '013'; '014' ; '015'; '016' ; '017'; '018' ; '019'};   
    for i = 1:length(subject3)
        cmat_list{i} = [files_base '\3-Working_Memory\' subject3{i} '_demo.mat'];
    end
case 4
    set(handles.menuData,'BackgroundColor',[0.95,1,0.95])
    set(handles.pushbutton3,'BackgroundColor',[1,1,1])
    set(handles.msgUp,'visible','off')
    disp('Simulation Dataset Selected.')
    data_nb=4;
    S=load('Sim_JT2_noise1.mat');
    S_noise=cell2mat(struct2cell(S));
    %param values init
    n_parcels=size(S_noise,2);
    time_wind=size(S_noise,1);
    %re-order matrix format + substract mean
    newS_noise_notsym=zeros(n_parcels,n_parcels,time_wind);
    newS_noise_notsym=permute(S_noise,[2 3 1]);
    newS_noise_notsym=newS_noise_notsym-repmat(mean(newS_noise_notsym,3),[1,1,size(newS_noise_notsym,3)]);
    %make the matrix symm (from upper) and 0 for diag
    for i=1:n_parcels 
        newS_noise_notsym(i,i,:)=0; 
    end
    for j=1:time_wind 
        newS_noise(:,:,j)=triu(newS_noise_notsym(:,:,j))+triu(newS_noise_notsym(:,:,j))';
    end

end
% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in menuMethod.
function menuMethod_Callback(hObject, eventdata, handles)
% hObject    handle to menuMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menuMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menuMethod
clear global method_id
global method_id

val_method = get(hObject,'value');
method_id=val_method;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonGo.
function buttonGo_Callback(hObject, eventdata, handles)
% hObject    handle to buttonGo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NICs
global results
global data_nb
global dist
global label
global disp_concat
global thresh

if(data_nb==1)
    benf_fact=2*NICs*8; % 2 tails x 10 ICs x 8 DOFs
elseif(data_nb==2)
    benf_fact=2*NICs*6; % 2 tails x 10 ICs x 6 DOFs
elseif(data_nb==3)
    benf_fact=2*NICs*12; % 2 tails x 10 ICs x 12 DOFs
elseif(data_nb==5)
    benf_fact=2*NICs*8;
end

if(data_nb==4)
    cfg             = [];
    cfg.threshold   = thresh;
    cfg.label=label;
    disp('Plotting...')
    if(disp_concat==1)    
        go_viewNetworkComponents_general_sim_concat(cfg,results);
    else
        go_viewNetworkComponents_general_sim_separated(cfg,results); 
    end      
else
    if(dist==1)
        cfg1                     = [];
        cfg1.p                   = 0.05;
        cfg1.bonferroni_factor   = benf_fact;   
        cfg2             = [];
        cfg2.threshold   = thresh;
        cfg2.label=label;
        if(data_nb==2)
            perms = go_testNetworks_general_bigHCP(cfg1,results);
        else
            perms = go_testNetworks_general(cfg1,results); 
        end
        disp('Plotting...')
        if(disp_concat==1)    
            go_viewNetworkComponents_general_concat_interface(cfg2,results,perms);
        else
            go_viewNetworkComponents_general_separated_interface(cfg2,results,perms);
        end
        assignin('base','perms',perms)
    elseif(dist==0)
        cfg             = [];
        cfg.threshold   = thresh;
        cfg.label=label;
        disp('Plotting...')
        if(disp_concat==1)    
            go_viewNetworkComponents_general_concat_interface(cfg,results);
        else
            go_viewNetworkComponents_general_separated_interface(cfg,results);
        end        
    end
end

disp('Plot Completed.')


% Update handles structure
guidata(hObject, handles);


function editNICs_Callback(hObject, eventdata, handles)
% hObject    handle to editNICs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNICs as text
%        str2double(get(hObject,'String')) returns contents of editNICs as a double
clear global NICs
global NICs
NICs=str2num(get(handles.editNICs,'String'));

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in DistYes.
function DistYes_Callback(hObject, eventdata, handles)
% hObject    handle to DistYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DistYes
clear global dist
global dist
val_method = get(hObject,'value');
if(val_method)
    dist=1;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DistNo.
function DistNo_Callback(hObject, eventdata, handles)
% hObject    handle to DistNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DistNo
clear global dist
global dist
val_method = get(hObject,'value');
if(val_method)
    dist=0;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in LabelYes.
function LabelYes_Callback(hObject, eventdata, handles)
% hObject    handle to LabelYes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LabelYes
clear global label
global label
val_method = get(hObject,'value');
if(val_method)
    label=1;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in LabelNo.
function LabelNo_Callback(hObject, eventdata, handles)
% hObject    handle to LabelNo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LabelNo
clear global label
global label
val_method = get(hObject,'value');
if(val_method)
    label=0;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DispConcat.
function DispConcat_Callback(hObject, eventdata, handles)
% hObject    handle to DispConcat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispConcat
clear global disp_concat
global disp_concat
val_method = get(hObject,'value');
if(val_method)
    disp_concat=1;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in DispSep.
function DispSep_Callback(hObject, eventdata, handles)
% hObject    handle to DispSep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispSep
clear global disp_concat
global disp_concat
val_method = get(hObject,'value');
if(val_method)
    disp_concat=0;
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ComputeButton.
function ComputeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global results
clear global timeElapsed
global cmat_list
global NICs
global results
global timeElapsed
global data_nb
global newS_noise
global n_parcels
global time_wind
global method_id

set(handles.text8,'visible','off')
set(handles.time_elap,'visible','off')
set(handles.uipanel9,'visible','off')
set(handles.buttonGo,'visible','off')

pause(0.1);

switch method_id
case 1
    disp('ICA-JADE Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 1; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        cfg.val= 1; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end

case 2
    disp('ICA-InfoMax Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 2; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        cfg.val= 2; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end
case 3
    disp('ICA-SOBI Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 3; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        cfg.val= 3; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end
case 4
    disp('ICA-FastICA Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.NPCs        = NICs+5;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 4; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.NPCs        = NICs+5;
        cfg.data        = cmat_list;
        tic
        cfg.val= 4; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end
case 5
    disp('ICA-CoM2 Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 5; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        cfg.val= 5; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end
case 6
    disp('ICA-PSAUD Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        cfg.val= 6; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_sim_ica(cfg); %all
        timeElapsed= toc;
    else      
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        cfg.val= 6; % 1=jade, 2=infomax, 3=sobi, 4=fastica, 5=com2, 6=psaud
        results= go_decomposeConnectome_general_ica(cfg); %all
        timeElapsed= toc;
    end
case 7
    disp('PCA Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        results= go_decomposeConnectome_general_sim_pca(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        results= go_decomposeConnectome_general_pca(cfg); %all
        timeElapsed= toc;
    end
case 8
    disp('NMF Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        tic
        results= go_decomposeConnectome_general_sim_nmf(cfg); %all
        timeElapsed= toc;
    else     
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        tic
        results= go_decomposeConnectome_general_nmf(cfg); %all
        timeElapsed= toc;
    end
case 9
    disp('K-means Method selected.')
    if(data_nb==4)
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.newS_noise        = newS_noise;
        cfg.n_parcels        = n_parcels;
        cfg.time_wind        = time_wind;
        cfg.val= 1; % 1=Sample_init, 2=Plus_init
        tic
        results= go_decomposeConnectome_general_sim_kmeans(cfg); %all
        timeElapsed= toc;
    else    
        cfg             = [];
        cfg.NICs        = NICs;
        cfg.data        = cmat_list;
        cfg.val= 1; % 1=Sample_init, 2=Plus_init
        tic
        results= go_decomposeConnectome_general_kmeans(cfg); %all
        timeElapsed= toc;
    end
end

disp('Computation Done.')
assignin('base','results',results)
assignin('base','timeElapsed',timeElapsed)

set(handles.text8,'visible','on')
set(handles.time_elap,'visible','on')
set(handles.time_elap,'String',[num2str(timeElapsed) ' sec']);
set(handles.uipanel9,'visible','on')
set(handles.buttonGo,'visible','on')

global thresh
global dist
global label
global disp_concat
thresh = str2num(get(handles.editThresh,'String'));
dist = get(handles.DistYes,'value');
label = get(handles.LabelYes,'value');
disp_concat = get(handles.DispConcat,'value');

% Update handles structure
guidata(hObject, handles);



function editThresh_Callback(hObject, eventdata, handles)
% hObject    handle to editThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editThresh as text
%        str2double(get(hObject,'String')) returns contents of editThresh as a double
clear global thresh
global thresh
thresh=str2num(get(handles.editThresh,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editThresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editThresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global cmat_list
clear global data_nb
global cmat_list
global data_nb
data_nb=5;

set(handles.menuData,'BackgroundColor',[1 1 1])
set(handles.pushbutton3,'BackgroundColor',[1,1,1])
set(handles.msgUp,'visible','off')

selpath=uigetdir(pwd, 'Select a folder');
disp('Uploading Data...');
files = dir(fullfile(selpath, '*.mat'));
if(size(files,1)==0)
    errordlg('Folder is empty','Error');
    disp('Folder empty.');
    return;
end
for i=1:size(files,1)
    names{i} = files(i).name;
    cmat_list{i}= [selpath '\' names{i}];
    ss=load(cmat_list{i});
    name_ss=fieldnames(ss);
    if(~isfield(ss,'cmat'))
        errordlg(['Please check your structure variable format and name in file ' names{i}],'Error');
        disp('Structure format or name is wrong: refer to readme guide');
        return;
    elseif(~isfield(ss.cmat,'connectivity'))
        errordlg({['Field connectivity is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on connectivity field for file ' names{i}]);
        return;
    elseif(~isfield(ss.cmat,'n_trials'))
        errordlg({['Field n_trials is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on n_trials field for file ' names{i}]);
        return;
    elseif(~isfield(ss.cmat,'window'))
        errordlg({['Field window is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on window field for file ' names{i}]);
        return;
    elseif(~isfield(ss.cmat,'bpfreq'))
        errordlg({['Field bpfreq is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on bpfreq field for file ' names{i}]);
        return;
    elseif(~isfield(ss.cmat,'time'))
        errordlg({['Field time is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on time field for file ' names{i}]);
        return;
    elseif(~isfield(ss.cmat,'n_parcels'))
        errordlg({['Field n_parcels is missing in file ' names{i}], 'Please fix and Try Again'},'Error');
        disp(['Check on n_parcels field for file ' names{i}]);
        return;
    else
        disp(['Data File ' names{i} ' uploaded']);
    end
end
disp('Sucessfully uploaded.');
set(handles.msgUp,'visible','on')
set(hObject,'BackgroundColor',[0.95,1,0.95])
set(handles.menuData,'BackgroundColor',[1,1,1])
% Update handles structure
guidata(hObject, handles);
