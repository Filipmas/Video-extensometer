function [sections,y,isaxial] = AxialStrainMultiAnalysis(sectionID,Z_media)

    prompt = {'Section 1 ID, top :','Section 2 ID, bottom :','1=true strain, 2=engineering strain'};
    title_axial = 'Axial extensometer';
    answer_axial = inputdlg(prompt,title_axial,[1 48],{'0','0','1'});

    answer_axial_str = str2num(char(answer_axial));
    axial_section_ID = answer_axial_str(1:2);
    TrueEng = answer_axial_str(3);

    Nframes = size(Z_media,1);
    strains = zeros(Nframes,2);
    
    [a,b] = ismember(axial_section_ID,sectionID);

    if isequal(axial_section_ID,[0,0]')
        isaxial = false;
    elseif any(not(a))
        isaxial = false;
        warndlg({'At least 1 section ID was not found.',' Axial deformation will not be performed.'},'Warning');
    else
        isaxial = true;
        axial_section = b;

        displacement = zeros(Nframes,2);
        for ii = 2:Nframes
            for jj = 1:2
                displacement(ii,jj) = Z_media(ii,axial_section(jj))-Z_media(1,axial_section(jj));
            end
        end

        initial_distance = Z_media(1,axial_section(1)) - Z_media(1,axial_section(2));
        difference_displacement = displacement(:,1) - displacement(:,2);
        
        
        strains(:,1) = log(1+difference_displacement/initial_distance);
        strains(:,2) = difference_displacement / initial_distance;
        
        if TrueEng==2
            strain_plot = strains(:,2);
            plot_title = 'Engineering Axial Strain';
        else
            strain_plot = strains(:,1);
            plot_title = 'True Axial Strain';
        end

        % Strain plotting
        figure
            subplot(2,1,1)
            title('Displacement','Fontsize',12)
            hold on
            plot(displacement(:,1),'b')
            plot(displacement(:,2),'r')
            legend(['Section ' num2str(axial_section_ID(1))],['Section ' num2str(axial_section_ID(2))],...
                'Location','best','Fontsize',12)
            grid on

            subplot(2,1,2)
            plot(strain_plot,'b')
            title(plot_title,'Fontsize',12)
            legend(['Axial strain beetwen sections ' num2str(axial_section_ID(1)) ' and ' num2str(axial_section_ID(2))],...
                'Location','best','Fontsize',12)
            grid on
            
       sections = axial_section_ID;
       y = strains;
    end