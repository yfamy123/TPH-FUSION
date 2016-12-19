function LG_ratio_plot(Inc, Out, xdim, ydim, Gama, name)

    ActError = Inc.ActError;
    E_All = ActError;
    E_Itr = ActError(:,2:end);
    
    % error and index for the best situation
    IdxB = zeros(length(Out),1);
    errorB = zeros(length(Out),1);
    
    % error and index for the worst situation
    IdxW = zeros(length(Out),1);
    errorW = zeros(length(Out),1);

    % error and index for the stop criteria
    IndS = zeros(length(Out),length(Gama));
    errorS = zeros(length(Out),length(Gama));
    errorI = zeros(length(Out),length(Gama));

    CF = Inc.Lagrangian;

    % Compare with H-Fusion
    for i = 1:length(Out)
        [errorB(i),IdxB(i)] = min(E_All(i,:));
        [errorW(i),IdxW(i)] = max(E_All(i,:));
        for j = 1:length(Gama)
            [m,d] = min(CF(:,i,j));
            IndS(i,j) = d;
            errorS(i,j) = E_All(i,d+1); 
        end
    end

    relLossSP = errorS - repmat(errorB,1,length(Gama));
    relLossSP = bsxfun(@rdivide, relLossSP, E_All(:,1));
    relGainSP = repmat(errorW,1,length(Gama)) - errorS;
    relGainSP = bsxfun(@rdivide, relGainSP, E_All(:,1));
    s = size(relGainSP);
    for i = 1:s(1)
        for j = 1:s(2)
            if relGainSP(i,j) == 0
                relGainSP(i,j) = 1e-10;
            end
        end
    end

    LG_ratio_All = relLossSP./relGainSP;
    
    
    % Compare with the first iteration
    for i = 1:length(Out)
        [errorB(i),IdxB(i)] = min(E_Itr(i,:));
        [errorW(i),IdxW(i)] = max(E_Itr(i,:));
        for j = 1:length(Gama)
            [m,d] = min(CF(:,i,j));
            IndS(i,j) = d;
            errorI(i,j) = E_Itr(i,d);
        end
    end
    
    relLossI = errorS - repmat(errorB,1,length(Gama));
    relLossI = bsxfun(@rdivide, relLossI, E_All(:,1));
    relGainI = repmat(errorW,1,length(Gama)) - errorI;
    relGainI = bsxfun(@rdivide, relGainI, E_All(:,1));
    s = size(relGainI);
    for i = 1:s(1)
        for j = 1:s(2)
            if relGainI(i,j) == 0
                relGainI(i,j) = 1e-10;
            end
        end
    end

    LG_ratio_Itr = relLossI./relGainI;

    Xs = zeros(length(Out),1);
    Ys = zeros(length(Out),1);

    for i = 1:length(Out)
        Xs(i) = Out(i).muvars(1);
        Ys(i) = Out(i).muvars(2);
    end
    Xs = reshape(Xs,ydim,xdim);
    Ys = reshape(Ys,ydim,xdim);

    for k = 1:length(Gama)
        figure;
        subplot(2,1,1)
        pcolor(Xs,Ys,reshape(log10(LG_ratio_Itr(:,k)),ydim,xdim));
        colorbar;
        caxis([-15 15])
        title(strcat(name,' L/G ration compare to ITR-1'),'FontSize',16);
        xlabel('RD','FontSize',16)
        ylabel('Shift','FontSize',16)

        subplot(2,1,2)
        pcolor(Xs,Ys,reshape(log10(LG_ratio_All(:,k)),ydim,xdim));
        colorbar;
        caxis([-15 15])
        title(strcat(name,' L/G ration compare to H-Fuse'),'FontSize',16);
        xlabel('RD','FontSize',16)
        ylabel('Shift','FontSize',16)
    end
end

