% Given:
P_ABC = get_dist('complete correlation'); %(000, 100, 010, 110, 001, 101, 011, 111)
 
% P_ABC in CG coordinate:
G_ABC = p2cg(3)*P_ABC;

% Filter matrices
M_AC = cgmarginal(3, [1 3]);
M_BC = cgmarginal(3, [2 3]);
M_AB = cgmarginal(3, [1 2]);

% cvx_begin
%     variable x(8); % x is G_A2B1C1
%     subject to 
%         % Equality conditions
%         % G_A2C1 = G_AC
%         M_AC * x == M_AC * G_ABC;
%         % G_B1C1 = G_BC
%         M_BC * x == M_BC * G_ABC;
%         % G_A2B1 = G_A * G_B
%         M_AB * x == kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC);
%         % Nonnegative conditions
%         cg2p(3)*x >= 0;
% cvx_end


%--------------General form---------------

% Concatenate conditions
A = [M_AC;
     M_BC;
     M_AB];
b = [M_AC * G_ABC;
     M_BC * G_ABC;
     kron(cgmarginal(3, [1]) * G_ABC, cgmarginal(3, [2]) * G_ABC)];
G = -cg2p(3);
h = 0;
 
% cvx_begin
%     variable x(8);
%     subject to 
%         % Equality conditions
%         A * x == b;
%         % Inequality conditions
%         G * x <= h;
% cvx_end


%--------------LP standard form---------------
A_ = [G eye(8);
      A zeros(12,8)];
b_ = [zeros(8,1);
      b];

% cvx_begin
%     variable x(16);
%     subject to
%         % Equality conditions
%         A_ * x - b_ == 0;
%         % Nonnegative conditions
%         x >= 0;
% cvx_end



% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): +Inf

%--------------Analysis---------------
fprintf('Rank of A = %d\n', rank(full(A)));

fprintf('Rank of A'' = %d\n', rank(full(A_)));


