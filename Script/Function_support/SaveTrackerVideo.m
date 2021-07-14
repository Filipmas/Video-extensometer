function x = SaveTrackerVideo(Tracker_frames)

savevideo = questdlg('Save video for the selected point(s)?','Save?','Yes','No','Yes');

switch savevideo
    case 'Yes'
        currentfolder = pwd;
        [videofile,path] = uiputfile('*.*','Save as',currentfolder);
        videoname = fullfile(path,videofile);

        diskLogger = VideoWriter(videoname,'Uncompressed AVI');
        set(diskLogger,'FrameRate',30);
        open(diskLogger);

        numFrames = n_steps+1;
        for i = 1:numFrames
            writeVideo(diskLogger,Tracker_frames(i));
        end
        close(diskLogger)
    case 'No'
end
end