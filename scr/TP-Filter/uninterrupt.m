function [a] = uninterrupt(Serror,idx)
    [len,time] = size(Serror);
    a = zeros(len,1);
    for i = 1:len
        bestCount = 0;
        for j = 1:time
            if Serror(i,j) == idx
                bestCount = bestCount + 1;
            else
                a(i) = max(bestCount,a(i));
                bestCount = 0;
            end
        end
        a(i) = max(bestCount,a(i));
    end
end