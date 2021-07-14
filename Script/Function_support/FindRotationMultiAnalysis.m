function [x,y] = FindRotationMultiAnalysis(section_index,Points,n_analysis,nframesV,tolerance,originCenter)

nsection = size(section_index,2);
Nframes = sum(nframesV,1) - (n_analysis-1);
Z = zeros(n_analysis,nsection);

Rotation = zeros(Nframes,nsection);
Centro = zeros(Nframes,2,nsection);

for jj = 1:nsection
        frame_count = 1;    % Quantità necessaria a combinare i risultati ottenuti dalle analisi.

        for yy = 1:n_analysis

            % Vettori ausiliari che conterranno le grandezze per la singola analisi
        rotation = zeros(nframesV(yy),1);
        centro = zeros(nframesV(yy),2);

        actual_section_index = section_index(jj).index;   % Gli indici dei nodi della sezione attuale

        if yy>1  % Con più analisi è necessario ritracciare i nodi della sez. conoscendone la Z media
            actual_section_index = findSection3D(Points(yy).coordinates(:,:,1),Z(yy-1,jj),tolerance(jj));
        end

        section = zeros(length(actual_section_index(jj)),3,nframesV(yy)); %Coordinate dei nodi della sez.

        for h = 1:3
            for l = 1:length(actual_section_index)
                section(l,h,:) = Points(yy).coordinates(actual_section_index(l),h,:);
            end
        end

        for i = 2:nframesV(yy)
            [xc,yc,rot] = findRotation(section(:,1:2,i-1:i),originCenter);
            rotation(i) = rotation(i-1) + rot;
            centro(i,1) = xc;
            centro(i,2) = yc;
        end

        Rotation(frame_count+1:frame_count+nframesV(yy)-1,jj) = rotation(2:nframesV(yy));
        Centro(frame_count+1:frame_count+nframesV(yy)-1,1:2,jj) = centro(2:nframesV(yy),1:2);

        % Attualizzare la rotazione
        Rotation(frame_count+1:frame_count+nframesV(yy)-1,jj) = Rotation(frame_count+1:frame_count+nframesV(yy)-1,jj) ...
                                                              + Rotation(frame_count,jj);

        fc = nframesV(1:yy);
        frame_count = sum(fc) - (yy-1);

        Z(yy,jj) = mean(section(:,3,nframesV(yy)),'omitnan');

        end
end
    
x = Rotation;
y = Centro;

end