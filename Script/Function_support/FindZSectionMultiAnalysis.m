function x = FindZSectionMultiAnalysis(section_index,Points,n_analysis,nframesV,tolerance)

nsection = size(section_index,2);
Nframes = sum(nframesV,1) - (n_analysis-1);
Z = zeros(n_analysis,nsection);

Z_media = zeros(Nframes,nsection);

    for jj = 1:nsection
        frame_count = 1;    % Quantità necessaria a combinare i risultati ottenuti dalle analisi.

            % Inizializzo l'altezza di partenza della sezione

        Z_media(1,jj) = mean(Points(1).coordinates(section_index(jj).index,3,1),'omitnan');

        for yy = 1:n_analysis

            % Vettori ausiliari che conterranno le grandezze per la singola analisi
        z_mean = zeros(nframesV(yy),1);

        actual_section_index = section_index(jj).index;   % Gli indiici dei nodi della sezione attuale

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
            z_mean(i) = mean(section(:,3,i),'omitnan');
        end

        % Aggiungo il vettore dell'analisi attuale al vettore globale Z.
        Z_media(frame_count+1:frame_count+nframesV(yy)-1,jj) = z_mean(2:nframesV(yy));

        fc = nframesV(1:yy);
        frame_count = sum(fc) - (yy-1);

        Z(yy,jj) = mean(section(:,3,nframesV(yy)),'omitnan');

        end
    end
    
    x = Z_media;
    
end