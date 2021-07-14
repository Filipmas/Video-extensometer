clear all
set(0,'DefaultFigureColor','white')

%% Loading 

n_analysis = inputdlg('How many analysis?  ');
n_analysis = str2double(n_analysis);

filenames = cell(n_analysis,1);

currentfolder = pwd;
for ii = 1:n_analysis
    tit = ['Select n.' num2str(ii) ' MultiDIC STEP3 output file'];
    [file,path] = uigetfile(currentfolder,tit);
    filenames{ii} = fullfile(path,file);
    currentfolder = path;
end
 clear tit
% currentfolder = pwd;
% [filename,path] = uigetfile(currentfolder,'Select MultiDIC STEP3 output file');
% filename = fullfile(path,filename);

nframesV = zeros(n_analysis,1);    % Vettore del numero di frame per ogni analisi
nnodesV = zeros(n_analysis,1);     % Vettore del numero di nodi per ogni analisi
Points = struct;

for ii = 1:n_analysis
    data = load(filenames{ii});
    mainstruct = fieldnames(data);
    data = getfield(data,char(mainstruct));          % Per rinominare la struttura principale
    
    nframesV(ii) = size(data.Points3D,1);
    nnodesV(ii) = size(data.Points3D{1,1},1);
    points = zeros(nnodesV(ii),3,nframesV(ii));
    for jj = 1:nframesV(ii)
        points(:,:,jj) = data.Points3D{jj,1};
    end
    
    Points(ii).coordinates = points;
end

Nframes = sum(nframesV,1) - (n_analysis-1);  % Numero totale di frames considerando tutte le analisi

% A questo punto ho una struttura Points che contiene le coordinate dei nodi negli istanti di tempo
% per tutte le analisi eseguite.

%% Select the function to use

prompt = 'Choose the function:';
titlebox = 'Point(s) and/or section(s)?';
analysis_type = questdlg(prompt,titlebox,'Point Tracker','Sections Tracker','Point and Sections Tracker','Point and Sections Tracker');
switch analysis_type
    case 'Point Tracker'
        tracker_function = true;
        section_function = false;
    case 'Sections Tracker'
        tracker_function = false;
        section_function = true;
    case 'Point and Section Tracker'
        tracker_function = true;
        section_function = true;
end

%% Point Tracker

if tracker_function
     % Matrice contenente le coordinate die nodi all'istante iniziale
     Points3D_0 = Points(1).coordinates(:,:,1);  
     %Selezioni dei nodi da tracciare
     GetPointTracker3D(Points3D_0) 

     npoints_tracker = size(tracker3D_point,1);   % Numero di nodi da tracciare

     [tracker_position,tracker_displacements,NodeError] = Tracker3DMultiAnalysis(tracker3D_point,Points,n_analysis,nframesV);
     % tracker_position e tracker_displacements sono le posizioni e gli spostamenti dei nodi da
     % tracciare mentre NodeError è l'errore l'errore commesso nel momento in cui bisogna aggiornare il
     % nodo che si sta tracciando.

     % Plotting delle traiettorie
     Tracker3DPlotting(tracker3D_point,tracker_position);

     % Salvataggio dei risultati del tracker
     saveresults = questdlg('Save results for the selected point(s)?','Save?','Yes','No','Yes');
        switch saveresults
            case 'Yes'
                if exist('Tracker3D_results','var')
                     clear('Tracker3D_results');
                end
                PointTracker_results = struct;
                PointTracker_results.MultiDIC_file = filenames;
                PointTracker_results.N_analysis = n_analysis;
                PointTrakcer_results.Frames = nframesV;
                for ii = 1:npoints_tracker
                    PointTracker_results.Points(ii).ID = tracker3D_point(ii,1);
                    PointTracker_results.Points(ii).Coordinates = tracker_position(:,:,ii);
                    PointTracker_results.Points(ii).Displacements = tracker_displacements(:,:,ii);
                    PointTracker_results.Points(ii).NodeUpdateError = NodeError(:,ii);
                end
                uisave('Tracker3D_results','.')
            case 'No'
        end
end
    
%% Section Tracker

if section_function
    
    GetMultipleSectionPoint3D(Points(1).coordinates);
    nsection = size(sectionID,1);      % Numero delle sezioni da seguire

    % Inizializzazione vettori
    Rotation = zeros(Nframes,nsection);
    Centro = zeros(Nframes,2,nsection);
    Z_media = zeros(Nframes,nsection);
    Displacement_section = zeros(Nframes,nsection);
    Section_extensometer = [0,0];
    Strain_extensometer = zeros(Nframes,2);
    
    % Calcolo delle rotazioni
    if RotationAnalysis
        center0 = questdlg('Consider the center of rotation in the origin (0,0)?','Center','Yes','No','Yes');
        switch center0
            case 'Yes'
                originCenter = true;
            case 'No'
                originCenter = false;
        end
        [Rotation,Centro] = FindRotationMultiAnalysis(section_index,Points,n_analysis,nframesV,tolerance,originCenter);
    end
    
    % Calcolo degli spostamenti e dell'allungamento
    if AxialAnalysis
        Z_media = FindZSectionMultiAnalysis(section_index,Points,n_analysis,nframesV,tolerance);
        for tt = 1:Nframes
            Displacement_section(tt,:) = Z_media(tt,:) - Z_media(1,:);
        end
        [section_extensometer,Strain_extensometer,isextensometer] = AxialStrainMultiAnalysis(sectionID,Z_media);
    end
    
    % Plotting spostamenti e rotazioni
    Extensometer3DPlotting(sectionID,Rotation,Z_media,Centro);
    
    % Salvataggio risultati delle sezioni
    
    saveresults = questdlg('Save results for the selected section(s)?','Save?','Yes','No','Yes');

    if exist('Section_results','var')
        clear('Section_results');
    end
    
    switch saveresults
        case 'Yes'
            Section_results = struct;
            Section_results.MultiDIC_output = filenames;
            Section_results.N_analysis = n_analysis;
            Section_results.Frames = nframesV;
            for ii = 1:nsection
                Section_results.Section(ii).SectionID = sectionID(ii);
                Section_results.Section(ii).Z_coordinate = Z_media(:,ii);
                Section_results.Section(ii).Z_displacement = Displacement_section(:,ii);
                Section_results.Section(ii).Rotation = Rotation(:,ii);
                Section_results.Section(ii).Tolerance = tolerance(ii);
                Section_results.Section(ii).Index = section_index(ii).index;
                Section_results.Section(ii).Center_rotation = Centro(:,:,ii);
            end
            
            Section_results.Axial_deform.Top_Section = section_extensometer(1);
            Section_results.Axial_deform.Bot_Section = section_extensometer(2);
            Section_results.Axial_deform.True_strain = Strain_extensometer(:,1);
            Section_results.Axial_deform.Eng_strain = Strain_extensometer(:,2);
            
            uisave('Section_results','.');
        case 'No'
    end
end