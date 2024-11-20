%-----------------------------------------------------------------------
% Xiaodong Zhang; Weihua Zhao
%-----------------------------------------------------------------------
function fisher_z = fisherZ(r)
    
    r = single(r);
    fisher_z = real(0.5 * log((1 + r) ./ (1 - r)));
    for row = 1:size(r,1)
        for cow = 1:size(r,2)
            if r(row,cow) == 1 || r(row,cow) == -1
                fisher_z(row,cow) = r(row,cow);
                if row == cow
                    fisher_z(row,cow) = 0;
                end
            end
        end
    end
end
