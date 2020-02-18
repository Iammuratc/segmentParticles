function [result] = isSpherical(V,A,threshold)
    sphericity=((36*pi*V^2)^(1/3))/A;
    if sphericity > threshold
        result=true;
    else
        result=false;
    end
end