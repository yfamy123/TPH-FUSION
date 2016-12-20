function [mse] = F_cutoff(Out, T)
    A = Out.A;
    x = Out.x_reconstr;
    y = Out.y; 
    
    [Matrix,fm] = cut_off(x,T);
    len = length(Matrix);
    recon_events_zero = zeros(length(x),len);
    recon_error_zero = zeros(1,len);

    for j = 1:len
        C_high = Matrix(j).C_high;
        r = Matrix(j).r;

        recon_events_zero(:,j) = pinv([A; C_high])*[y; zeros(r,1)];   %[A C]*x = [y;zeros]
        recon_events_zero(:,j) = real(recon_events_zero(:,j));
        recon_error_zero(j) = mean((recon_events_zero(:,j) - x).^2,1);
    end
    mse = recon_error_zero';
end