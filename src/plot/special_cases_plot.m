function special_cases_plot(events, Out, Out_A, Out_F, Inc_A, Inc_F, A_case, A_name, F_case, F_name, A_Itr_case, F_Itr_case, A_Itr_name, F_Itr_name)
    
    a = figure;
    plot(events,'b')
    hold on
    plot(Out(A_case).x_reconstr,'y','LineWidth',3)
    hold on
    plot(Out_F(A_case).x_reconstr,'g')
    hold on
    plot(Out_A(A_case).x_reconstr,'r','LineWidth',3)

    legend('TRUTH','H-FUSE','TPH-FUSE(F)','TPH-FUSE(A)')
    title(A_name)
    xlabel('Time(=Event ID)')
    ylabel('Count')
    saveas(a,'Awin.jpg')

    b = figure;
    plot(events,'b')
    hold on
    plot(Out(F_case).x_reconstr,'y','LineWidth',3)
    hold on
    plot(Out_F(F_case).x_reconstr,'g','LineWidth',3)
    hold on
    plot(Out_A(F_case).x_reconstr,'r')
    
    legend('TRUTH','H-FUSE','TPH-FUSE(F)','TPH-FUSE(A)')
    title(F_name)
    xlabel('Time(=Event ID)')
    ylabel('Count')
    saveas(b,'Fwin.jpg')

    figure;
    plot(log(Inc_A.ActError(A_Itr_case,:)),'LineWidth',3)
    hold on 
    plot(log(Inc_F.ActError(F_Itr_case,:)),'LineWidth',3)
    legend(strcat('TPH-FUSION(A) at ', A_Itr_name), strcat('TPH-FUSION(F) at ',F_Itr_name))
    names = {'H-FUSION'; 'ITR-1'; 'ITR-2'; 'ITR-3'; 'ITR-4';'ITR-5'; 'ITR-6'; 'ITR-7'; 'ITR-8';'ITR-9'; 'ITR-10'};
    set(gca,'xtick',[1:11],'xticklabel',names,'FontSize',16)
    title('TPH-FUSION(A) iteration MSE sequece')
    xlabel('Iteration times','FontSize',16)
    ylabel('MSE','FontSize',16)
end