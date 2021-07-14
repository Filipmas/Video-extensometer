function x = Extensometer3DPlotting(sectionID,Rotation,Z_media,Centro)

nsection = size(sectionID,1);

figure
hold on
for i = 1:nsection
    plot(Rotation(:,i),'DisplayNam',['Section ' num2str(sectionID(i))])
end
grid on
legend('Location','bestoutside')
xlabel('Frames','Fontsize',14)
ylabel('Rotation [rad]','Fontsize',14)

figure
hold on
for i = 1:nsection
    plot(Z_media(:,i),'DisplayNam',['Section ' num2str(sectionID(i))])
end
grid on
legend('Location','bestoutside')
xlabel('Frames','Fontsize',14)
ylabel('Z mean','Fontsize',14)

figure
hold on
for i = 1:nsection
    plot(Centro(:,1,i),Centro(:,2,i),'DisplayNam',['Section ' num2str(sectionID(i))])
end
grid on
title('Center of rotation','Fontsize',14)
legend('Location','bestoutside')
xlabel('x','Fontsize',14)
ylabel('y','Fontsize',14)

end