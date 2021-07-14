close all

set(0,'DefaultFigureColor','white')

%% Loading data

currentfolder = pwd;
filename = uigetfile(currentfolder,'Select NCORR output data');
data_ncorr = load(filename);

%% Extract data from Ncorr

% Queste informazioni sono in generale utili sia per la funzione di tracker che di estensometro

refimage = fullfile(data_ncorr.reference_save.path,data_ncorr.reference_save.name);
logical_mask = data_ncorr.reference_save.roi.mask;

coeff_pixel = data_ncorr.data_dic_save.dispinfo.pixtounits;      % Coefficiente di conversione dei pixel
units = data_ncorr.data_dic_save.dispinfo.units;                 % Unità di misura
pixel_spacing = data_ncorr.data_dic_save.dispinfo.spacing;       % Numero di pixel tra 2 nodi allineati

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract displacement from data_Ncorr

% In questa sezione vengono estratti gli spostamenti di tutti i nodi da cui andare a pescare le
% informazioni successivamente. Si tratta di vettori di matrici.
% Questi spostamenti sono utili sia per la funzione di estensometro che di tracker.

[M,N] = size(data_ncorr.data_dic_save.displacements(1).plot_u_dic);
n_steps = size(data_ncorr.data_dic_save.displacements,2);

displacements_U = zeros(M,N,n_steps);
displacements_V = zeros(M,N,n_steps);

for i = 1:n_steps           % Spostamenti in pixel rispetto alla reference image
    displacements_U(:,:,i) = data_ncorr.data_dic_save.displacements(i).plot_u_dic; 
    displacements_V(:,:,i) = data_ncorr.data_dic_save.displacements(i).plot_v_dic;
end

% Correggo un eventuale cambiamento della reference image durante la prova
displacements_U = RefUpdateDisplacementsMatrix(displacements_U,data_ncorr);
displacements_V = RefUpdateDisplacementsMatrix(displacements_V,data_ncorr);

% Nodo centrale dell'immagine
x_center = round(N/2);
y_center = round(M/2);

%% Select the function to use

prompt = 'Choose the function:';
titlebox = 'Tracker and/or extensometer';
analysis_type = questdlg(prompt,titlebox,'Tracker 2D','Extensometer','Tracker and extensometer','Tracker and extensometer');
switch analysis_type
    case 'Tracker 2D'
        tracker_function = true;
        extensometer_function = false;
    case 'Extensometer'
        tracker_function = false;
        extensometer_function = true;
    case 'Tracker and extensometer'
        tracker_function = true;
        extensometer_function = true;
end


%% Tracker 2D

if tracker_function
    
    x_center = round(N/2);
    y_center = round(M/2);
    
    % Scelta dei nodi da tracciare
    GetPointTrackerApp(refimage,logical_mask,coeff_pixel,units,pixel_spacing);
    
    n_points = size(tracker_point,1);   % Numero di nodi da tracciare
    
    center_node = zeros(n_points,2);
    center_node(:,1) = x_center;
    center_node(:,2) = y_center;
    points_node_distance = tracker_point(:,2:3);           % Distanza dei nodi dal centro, con segno
    points_nodes = center_node + points_node_distance;     % Posizioni nodali dei nodi da tracciare
    
    % Estraggo gli spostamenti dei nodi da tracciare in una matrice.
    displacements_nodes_tracker = zeros(n_steps,2,n_points);
    for i = 1:n_points                  % Spostamenti dei nodi in pixel
        xi_node = points_nodes(i,1);
        yi_node = points_nodes(i,2);
        for j = 1:n_steps
             displacements_nodes_tracker(j,1,i) = displacements_U(yi_node,xi_node,j);
             displacements_nodes_tracker(j,2,i) = displacements_V(yi_node,xi_node,j);
        end
    end
    % NB: gli indici nel ciclo for sono invertiti perché si lavora con una matrice dove il numero della
    % riga corrisponde alla Y mentre il numero della colonna alla X. Tenuto conto ora dell'inversione
    % degli indici non sarà necessario tornarci in seguito. Gli spostamenti sono ancora in PIXEL.
    
    % Acquisizione dei frame con i punti evidenziati.
    Tracker_frames = Tracker2DFrameAcquiring(data_ncorr,tracker_point,displacements_nodes_tracker,...
                    n_points,n_steps,pixel_spacing);
    
    % Riproduzione del video con consenso
    PlayTrackerVideo(Tracker_frames);
    
    % Salvataggio del video con consenso
    SaveTrackerVideo(Tracker_frames);
    
    % Plotting delle traiettorie
    displacements_nodes_tracker_scaled = displacements_nodes_tracker * coeff_pixel;
    Tracker2DPlotTrajectories(tracker_point,displacements_nodes_tracker_scaled,n_steps,units);
    
    % Salvataggio dei risultati nella struttura Matalb "Tracked_pints"
    saveresults = questdlg('Save results for the selected point(s)?','Save?','Yes','No','Yes');
    switch saveresults
        case 'Yes'
            if exist('Tracker_results','var')
                 clear('Tracker_results');
            end
            Tracker_results = struct;
            for ii = 1:n_points
                Tracker_results.Tracked_points(ii).PointsID = tracker_point(ii,1);
                Tracker_results.Tracked_points(ii).Coordinates_pixel = tracker_point(ii,2:3)*(pixel_spacing+1);
                Tracker_results.Tracked_points(ii).Coordinates_nodes = tracker_point(ii,2:3);
                Tracker_results.Tracked_points(ii).Displacement_U_pixel = displacements_nodes_tracker(:,1,ii);
                Tracker_results.Tracked_points(ii).Displacement_V_pixel = displacements_nodes_tracker(:,2,ii);
                Tracker_results.Tracked_points(ii).Displacement_U_units = displacements_nodes_tracker_scaled(:,1,ii);
                Tracker_results.Tracked_points(ii).Displacement_V_units = displacements_nodes_tracker_scaled(:,2,ii);
            end
            Tracker_results.DIC_info = data_ncorr.data_dic_save.dispinfo;
            uisave('Tracked_results','.')
        case 'No'
    end
end

%% Extensometer 2D

if extensometer_function
    
    x_center = round(N/2);
    y_center = round(M/2);
    
    % Scelta dei punti in cui posizionare l'estensometro
    GetExtensometerPointApp(refimage,logical_mask,coeff_pixel,units,pixel_spacing);

    xc_node = extensometer_point(1,1); yc_node = extensometer_point(1,2);
    x1_node = extensometer_point(2,1); x2_node = extensometer_point(2,2);
    y1_node = extensometer_point(3,1); y2_node = extensometer_point(3,2);
    
    % Distanza in pixel dal centro dell'immagine
    xc_px = xc_node * (pixel_spacing+1);
    yc_px = yc_node * (pixel_spacing+1);
    
    % Posizioni nodali dei vari punti
    x_center = x_center + xc_node;    y_center = y_center + yc_node;
    x_1 = x_center - x1_node;         x_2 = x_center + x2_node;
    y_1 = y_center - y1_node;         y_2 = y_center + y2_node;
    
    
    % Spostamenti dei nodi
    displacement_x1_ext = zeros(n_steps,1);   displacement_x2_ext = zeros(n_steps,1);
    displacement_y1_ext = zeros(n_steps,1);   displacement_y2_ext = zeros(n_steps,1);
    for i = 1:n_steps
        displacement_x1_ext(i) = displacements_U(y_center,x_1,i);
        displacement_x2_ext(i) = displacements_U(y_center,x_2,i);
        displacement_y1_ext(i) = displacements_V(y_1,x_center,i);
        displacement_y2_ext(i) = displacements_V(y_2,x_center,i);
    end

    % Strain
    l_x = zeros(n_steps,1);    l_y = zeros(n_steps,1);
        % Distanze iniziali
        l0_x = abs((x_2-x_1)*(pixel_spacing+1));    % Distanza iniziale in pixel
        l0_y = abs((y_2-y_1)*(pixel_spacing+1));    % Distanza iniziale in pixel
        
    strains = ExtensometerStrains(displacement_x1_ext,displacement_x2_ext,displacement_y1_ext,...
                displacement_y2_ext,x_1,x_2,y_1,y_2,n_steps,pixel_spacing);
                
    % Plotting risultati
    ExtensometerPlot(displacement_x1_ext,displacement_x2_ext,displacement_y1_ext,...
                displacement_y2_ext,strains,coeff_pixel,units);
            
    % Salvataggio dei risultati nella struttura Matlab "Extensometer_results"
    saveresults = questdlg('Save results for the selected point(s)?','Save?','Yes','No','Yes');

    switch saveresults
        case 'Yes'
            if exist('Extensometer_results','var')
                 clear('Extensometer_results');
            end
            Extensometer_results = struct;
            Extensometer_results.Center.Pixel = [xc_px,yc_px];
            Extensometer_results.Center.Nodes = [xc_node,yc_node];

            Extensometer_results.Points(1).ID = 'X_1';
            Extensometer_results.Points(2).ID = 'X_2';
            Extensometer_results.Points(3).ID = 'Y_1';
            Extensometer_results.Points(4).ID = 'Y_2';

            Extensometer_results.Points(1).Coordinates_pixel = [     x_1,  y_center] * (pixel_spacing+1);
            Extensometer_results.Points(2).Coordinates_pixel = [     x_2,  y_center] * (pixel_spacing+1);
            Extensometer_results.Points(3).Coordinates_pixel = [x_center,       y_1] * (pixel_spacing+1);
            Extensometer_results.Points(4).Coordinates_pixel = [x_center,       y_2] * (pixel_spacing+1);
            
            Extensometer_results.Points(1).Nodes_distance = [ -x1_node,        0];
            Extensometer_results.Points(2).Nodes_distance = [  x2_node,        0];
            Extensometer_results.Points(3).Nodes_distance = [        0, -y1_node];
            Extensometer_results.Points(4).Nodes_distance = [        0,  y2_node];
            
            Extensometer_results.Points(1).Displacement_pixel = displacement_x1_ext;
            Extensometer_results.Points(2).Displacement_pixel = displacement_x2_ext;
            Extensometer_results.Points(3).Displacement_pixel = displacement_y1_ext;
            Extensometer_results.Points(4).Displacement_pixel = displacement_y2_ext;
            Extensometer_results.Points(1).Displacement_units = displacement_x1_ext*coeff_pixel;
            Extensometer_results.Points(2).Displacement_units = displacement_x2_ext*coeff_pixel;
            Extensometer_results.Points(3).Displacement_units = displacement_y1_ext*coeff_pixel;
            Extensometer_results.Points(4).Displacement_units = displacement_y1_ext*coeff_pixel;
            
            Extensometer_results.Strains.Exx_true = strains(:,1,2);
            Extensometer_results.Strains.Eyy_true = strains(:,2,2);
            Extensometer_results.Strains.Exx_engineering = strains(:,1,1);
            Extensometer_results.Strains.Eyy_engineering = strains(:,1,2);
            
            Extensometer_results.DIC_info = data_ncorr.data_dic_save.dispinfo;
            
            uisave('Extensometer_results','.')
        case 'No'
    end

end

