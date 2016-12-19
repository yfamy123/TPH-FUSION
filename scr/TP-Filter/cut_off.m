function [Matrix,fm] = cut_off(events,threshold)
    fm=fft(events);
    n = length(threshold);
    for i = 1:n
       mask = abs(fm) > max(abs(fm))/threshold(i);
       Matrix(i).C = dftmtx(length(events));   %Discrete Fourier transform matrix.
       Matrix(i).C_high = Matrix(i).C(mask==0,:);
       [Matrix(i).r,Matrix(i).c]=size(Matrix(i).C_high);
    end
end
