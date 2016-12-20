function [mse] = A_length(Out, L)
    A = Out.A;
    x = Out.x_reconstr';
    y = Out.y; 
    N=length(x);
    Xmat=zeros(N-L+1,L);
    for s=1:N-L+1,
        Xmat(s,:)=x(s:s+L-1);
    end
    % can instead estimate Xmat from a similar time series (not x itself)

    Ymat=Xmat.'*Xmat; % small LxL matrix
    [U,Sigma,V]=svd(Ymat); % only need eigenvec corr to smallest eigenvalue, but since only LxL matrix, use full SVD here
    h=U(:,end);
    c1=[h(1); zeros(N-L,1)];
    r1=zeros(1,N);
    r1(1:L)=h.';
    H=toeplitz(c1,r1);

    % Take measurement reports

    xhat = (pinv([A; H])*[y; zeros(N-L+1,1)]).';
    mse = mean((xhat - x).^2);
    
end