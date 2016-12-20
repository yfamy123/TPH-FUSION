function [Out_F] = fourier(Out, threshold, events)
    for i = 1:length(Out)
        reconX = Out(i).x_reconstr;
        A = Out(i).A;
        y = Out(i).y;
        [Matrix,fm] = cut_off(reconX,threshold);
        len = length(Matrix);
        recon_events_zero = zeros(length(events),len);
        recon_error_zero = zeros(1,len);
        
        for j = 1:len
            C_high = Matrix(j).C_high;
            r = Matrix(j).r;

            recon_events_zero(:,j) = pinv([A; C_high])*[y; zeros(r,1)];   %[A C]*x = [y;zeros]
            recon_events_zero(:,j) = real(recon_events_zero(:,j));
            recon_error_zero(j) = mean((recon_events_zero(:,j) - events).^2,1);
        end
        
        Out_F(i).x_reconstr = recon_events_zero;
        Out_F(i).A = A;
        Out_F(i).y = y;
        Out_F(i).Matrix = Matrix(1).C_high;
        Out_F(i).error = recon_error_zero';
        Out_F(i).muvars = Out(i).muvars;
    end
