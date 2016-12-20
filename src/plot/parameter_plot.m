function parameter_plot(Out, Ltest, Ttest, config_rep_dur, config_rep_over)

    Ldim = length(Ltest);
    Tdim = length(Ttest);
    RDdim = length(config_rep_dur);
    Sdim = length(config_rep_over);
    error_L_RD = zeros(Ldim,RDdim);
    error_T_RD = zeros(Tdim,RDdim);
    error_L_Shift = zeros(Ldim,Sdim);
    error_T_Shift = zeros(Tdim,Sdim);

    
%     Annihilating Length selection
    for i = 1:Ldim
        for j = 1:RDdim
            fprintf('looping %d %d\n',i,j);
            error_L_RD(i,j) = A_length(Out(8+(j-1)*30), Ltest(i));
        end
    end
    
    x_L_RD = repmat(Ltest',1,RDdim);
    y_L_RD = repmat(config_rep_dur,Ldim,1);

    figure;
    pcolor(y_L_RD,x_L_RD,log10(error_L_RD))
    colorbar;
    ylabel('TPH-FUSION(A) length')
    xlabel('RD')
    title('TPH-FUSION(A) length based on H-FUSION reconstructed sequence')
    
    for i = 1:Ldim
        for j = 1:Sdim
            fprintf('looping %d %d\n',i,j);
            error_L_Shift(i,j) = A_length(Out(300+j), Ltest(i));
        end
    end
    
    x_L_S = repmat(Ltest',1,Sdim);
    y_L_shift = repmat(config_rep_over,Ldim,1);

    figure;
    pcolor(y_L_shift,x_L_S,log10(error_L_Shift))
    colorbar;
    ylabel('TPH-FUSION(A) length')
    xlabel('Shift')
    title('TPH-FUSION(A) length based on H-FUSION reconstructed sequence')
    
    
%     Fourier Cut-Off selection
    for j = 1:RDdim
        fprintf('looping %d\n',j);
        error_T_RD(:,j) = F_cutoff(Out(8+(j-1)*30), Ttest);
    end
    
    x_T_RD = repmat(Ttest',1,RDdim);
    y_T_RD = repmat(config_rep_dur,Tdim,1);

    figure;
    pcolor(y_T_RD,x_T_RD,log10(error_T_RD))
    colorbar;
    ylabel('TPH-FUSION(F) cut-off')
    xlabel('RD')
    title('TPH-FUSION(F) cut-off based on H-FUSION reconstructed sequence')
    
    
    for j = 1:Sdim
        fprintf('looping %d\n',j);
        error_T_Shift(:,j) = F_cutoff(Out(300+j), Ttest);
    end
    
    x_T_S = repmat(Ttest',1,Sdim);
    y_T_shift = repmat(config_rep_over,Tdim,1);

    figure;
    pcolor(y_T_shift,x_T_S,log10(error_T_Shift))
    colorbar;
    ylabel('TPH-FUSION(F) cut-off')
    xlabel('Shift')
    title('TPH-FUSION(F) cut-off based on H-FUSION reconstructed sequence')

    
end