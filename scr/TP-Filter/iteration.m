function [inc,Out_First,Out_Last] = iteration(Out, LorT, events, method, time, Gama)
    % LorT = Length if using annihiCFting filter
    % LorT = Threshold if using fourier filter
    error = zeros(length(Out),1);
    for i=1:length(Out)
        error(i) = Out(i).error;
    end
    
	% Compare error sequence
    Serror = zeros(length(Out),time);
	
	% Actual error sequence
    ActError = zeros(length(Out),time+1);
	ActError(:,1) = error;
    
    error_TP = error;
    dummyOut = Out;
	
	% Store the Cost function result.
    CF = zeros(time, length(Out), length(Gama));
	
    for j = 1:time
        fprintf('iteration %d\n',j);
        dummyTP = error_TP;
		
        if strcmp(method,'annihilating')
            Out_A = annihilating(dummyOut,LorT, events);
        elseif strcmp(method,'fourier')
            Out_A = fourier(dummyOut,LorT, events);
        else
            fprintf('error method');
            break;
        end
		
		for i=1:length(Out)
			error_TP(i) = Out_A(i).error;
        end
        
        ActError(:,j+1) = error_TP;
		
        L = zeros(length(Out),length(Gama));
		
        for l = 1:length(Out)
            for k = 1:length(Gama)
                L(l,k) = norm(sqrt(1-Gama(k))*(Out_A(l).y-Out_A(l).A*Out_A(l).x_reconstr),2)+ ...
                    norm(sqrt(Gama(k))*(Out_A(l).Matrix*Out_A(l).x_reconstr));
            end
        end

        CF(j,:,:) = L;
		
		% Compare previous error with the current error. If previous smaller, then 1, else if previous larger then -1, else 0.
        Serror(:,j) = double((dummyTP./error_TP)<1)-double((dummyTP./error_TP)>1);
		
        dummyOut = Out_A;
        if j==1
            Out_First = Out_A;
        end
		
		
    end
    
    Out_Last = Out_A;
    
    inc.ActError = ActError;
	
    inc.incumulate = sum(Serror==1,2);
    inc.decumulate = sum(Serror==-1,2);
    inc.zerocumulate = sum(Serror==0,2);
	
    inuninterrupted = uninterrupt(Serror,1);
    deuninterrupted = uninterrupt(Serror,-1);
    zerouninterrupted = uninterrupt(Serror,0);
    
    inc.inuninterrupted = inuninterrupted;
    inc.deinterrupted = deuninterrupted;
    inc.zerouninterrupted = zerouninterrupted;
    
    inc.indiff = inc.incumulate - inuninterrupted;
    inc.dediff = inc.decumulate - deuninterrupted;
    inc.zerodiff = inc.zerocumulate - zerouninterrupted;
    
    inc.Serror = Serror;
   	inc.Lagrangian = CF;

end