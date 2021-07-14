function x = ExtensometerPlot(dx1,dx2,dy1,dy2,strains,coeff_pixel,units)

answer = questdlg('Plot true or engineering strain?','Strain','True','Engineering','True');
switch answer
    case 'True'
        strain_type = 'True';
        eps_x_plot = strains(:,1,1);
        eps_y_plot = strains(:,2,1);
    case 'Engineering'
        strain_type = 'Engineering';
        eps_x_plot = strains(:,1,2);
        eps_y_plot = strains(:,2,2);
end

fontsize = 12;
title_fontsize = 14;

figure

subplot(2,2,1)
    plot(dy1*coeff_pixel,'r'); hold on;
    plot(dy2*coeff_pixel,'b'); hold off;
    grid on;
    title(['Displacement y in ',units],'Fontsize',title_fontsize)
    legend('y_1','y_2','Fontsize',fontsize)
    xlabel('Frames','Fontsize',fontsize)

subplot(2,2,3)
    plot(dx1*coeff_pixel,'r'); hold on;
    plot(dx2*coeff_pixel,'b'); hold off;
    grid on;
    title(['Displacement x in ',units],'Fontsize',title_fontsize)
    legend('x_1','x_2','Fontsize',fontsize,'location','southeast')
    xlabel('Frames','Fontsize',fontsize)

subplot(2,2,2)
    plot(eps_y_plot,'r'); hold on;
    plot(eps_x_plot,'g'); 
    hold off;
    grid on;
    title([strain_type ' strains'],'Fontsize',title_fontsize)
    legend(' \epsilon_{yy} ',' \epsilon_{xx}','Interpreter','tex','Fontsize',fontsize,'location','northwest')
    xlabel('Frames','Fontsize',fontsize)

subplot(2,2,4)
    if mean(eps_y_plot,'omitnan') < mean(eps_x_plot,'omitnan')
        plot(eps_y_plot./eps_x_plot)
    elseif mean(eps_y_plot,'omitnan') > mean(eps_x_plot,'omitnan')
        plot(eps_x_plot./eps_y_plot)
    end
    grid on;
    title('Poisson''s ratio \nu','Fontsize',title_fontsize)
    xlabel('Frames','Fontsize',fontsize)
    
end