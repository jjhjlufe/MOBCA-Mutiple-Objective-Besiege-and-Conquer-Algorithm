classdef MOBCAGrid < ALGORITHM
% <multi> <real/integer>
% Multi-Objective Besiege and Conquer Alogrithm
% BCB --- 0.2 --- Set BCB
% nSoldiers --- 3 --- Set soldiers for each armies
% div --- 10 --- Set the division number of grids

%------------------------------- Reference --------------------------------
% Jiang , J.; Wu, J.; Luo, J.;Yang, X.; Huang, Z. MOBCA: Multi-Objective
% Besiege and Conquer Algorithm. Biomimetics 2024, 9, 316. 
% https://doi.org/10.3390/biomimetics9060316
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Generate random population
            [BCB,nSoldiers,div] = Algorithm.ParameterSet(0.2,3,10);
            nArmies             = fix(Problem.N/nSoldiers);

            %% Generate random population
            Population          = Problem.Initialization(nArmies);
            Archive             = Population;
            %% Optimization
            while Algorithm.NotTerminated(Archive)
                REP        = REPSelection(Archive.objs,nArmies,div);
                Offspring  = OperatorBCAGrid(Problem,Population,BCB,Archive(REP),nSoldiers,nArmies);
                Archive    = UpdateArchive([Archive,Offspring],Problem.N,div);
                Population = BCAUpdatePop(Archive,Population,nArmies,div);
            end
        end
    end
end