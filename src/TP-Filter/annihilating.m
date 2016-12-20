function [Out_A] = annihilating(Out, L, events)

    len_L = length(L);
    len_Out = length(Out);
	
    for l = 1:len_Out
        reconX = Out(l).x_reconstr;
        A = Out(l).A;
        y = Out(l).y;
        Out_A(l).A = A;
        Out_A(l).y = y;
        N = length(reconX);
        xhat = zeros(len_L,N);
        error = zeros(len_L,1);
		
        for i = 1:len_L
            reconX = reconX.';
            Xmat=zeros(N-L(i)+1,L(i));
			
            for s=1:N-L(i)+1,
                Xmat(s,:)=reconX(s:s+L(i)-1);
            end

            Ymat=Xmat.'*Xmat; % small LxL matrix
            [U,Sigma,V]=svd(Ymat); % only need eigenvec corr to smallest eigenvalue, but since only LxL matrix, use full SVD here
            h=U(:,end);
            c1=[h(1); zeros(N-L(i),1)];
            r1=zeros(1,N);
            r1(1:L)=h.';
            H=toeplitz(c1,r1);

            xhat(i,:) = (pinv([A; H])*[y; zeros(N-L(i)+1,1)]).';
            error(i) = mean((xhat(i,:)' - events).^2,1);
			
        end
        
        Out_A(l).muvars = Out(l).muvars;
        Out_A(l).Matrix = H;
        Out_A(l).x_reconstr = xhat';
        Out_A(l).error = error;
    end
    
    