function [x,y] = coordnormalize(axis,X_coord,Y_coord)

% Questa function trasforma le coordinate rispetto agli assi nel corrispondente valore normalizzato
% rispetto alla figure. 
% Funziona solo per scale lineari!

 Xscale = axis.XScale;
 Yscale = axis.YScale;
 
 if isequal(Xscale,'linear')
     if isequal(Yscale,'linear')
 
         Xlim1 = axis.XLim(1);      Xlim2 = axis.XLim(2);
         Ylim1 = axis.YLim(1);      Ylim2 = axis.YLim(2);
        
         if isequal(axis.XAxis.Direction,'reverse')
             Xlim1 = axis.XLim(2);      Xlim2 = axis.XLim(1);
         end
         
         if isequal(axis.YAxis.Direction,'reverse')
             Ylim1 = axis.YLim(2);      Ylim2 = axis.YLim(1);
         end
         
         x_pos = axis.Position(1);
         y_pos = axis.Position(2);
         
         x_length = axis.Position(3);
         y_length = axis.Position(4);

         x = x_pos + x_length * (X_coord-Xlim1) / (Xlim2-Xlim1);
         y = y_pos + y_length * (Y_coord-Ylim1) / (Ylim2-Ylim1);
         
     else
         disp('The y-axis is not linear')
     end
 else
     disp('The x-axis is not linear')
 end
 
end