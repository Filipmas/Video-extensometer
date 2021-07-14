function  x = PlayTrackerVideo(tracker_frames)


answer = questdlg('Play the video?','Tracker','Yes','No','No');
switch answer
    case 'Yes'
        implay(tracker_frames)
    case 'No'
end

% Per clickare il comando che adatta l'immagine alla finestra
set(0,'showHiddenHandles','on');
fig_handle = gcf ;  
fig_handle.findobj; % to view all the linked objects with the vision.VideoPlayer 
ftw = fig_handle.findobj ('TooltipString', 'Maintain fit to window');   % this will search the object in the figure which has the respective 'TooltipString' parameter.
ftw.ClickedCallback();  % execute the callback linked with this object 
clear ftw fig_handle

end