function iteration_uninterrupt_plot(Out, Inc, xdim, ydim, time, name)
    len = length(Out);
    Xs = zeros(len,1);
    Ys = zeros(len,1);

    for i = 1:len
        Xs(i) = Out(i).muvars(1);
        Ys(i) = Out(i).muvars(2);
    end
    
    Xs = reshape(Xs,ydim,xdim);
    Ys = reshape(Ys,ydim,xdim);
    
    inuninterrupted = reshape(Inc.inuninterrupted,ydim,xdim);
    deuninterrupted = reshape(Inc.deinterrupted,ydim,xdim);
    zerouninterrupted = reshape(Inc.zerouninterrupted,ydim,xdim);
    
    figure;
    colormap(jet(time+1));
    
    subplot(1,3,1);
    pcolor(Xs,Ys,inuninterrupted);
    ylabel('Shift','FontSize',16);
    xlabel('RD','FontSize',16);
    title(strcat(name, ' uninterrupt increase'),'FontSize',16)
    caxis([0,time])
    
    subplot(1,3,2);
    pcolor(Xs,Ys,deuninterrupted);
    ylabel('Shift','FontSize',16);
    xlabel('RD','FontSize',16);
    title(strcat(name, ' uninterrupt degradation'),'FontSize',16)
    caxis([0,time])
    
    subplot(1,3,3);
    pcolor(Xs,Ys,zerouninterrupted);
    ylabel('Shift','FontSize',16);
    xlabel('RD','FontSize',16);
    title(strcat(name, ' uninterrupt Inactivity'),'FontSize',16)
    colorbar
    caxis([0,time])
end