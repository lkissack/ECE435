function [Eint] = Einternal(vi, vi_minus, vi_plus, alpha, beta)
continuity = alpha*abs(vi - vi_minus)^2;
curvature = beta*abs(vi_minus - 2*vi + vi_plus)^2;

Eint = 0.5*(continuity + curvature);

end

