function Offspring = OperatorBCAGrid(Problem,Parent,BCB,Archive,nSoldiers,nArmies)
%OperatorPSO - The operator of particle swarm optimization.
%
%   Off = OperatorPSO(Pro,P,Pbest,Gbest) uses the operator of particle
%   swarm optimization to generate offsprings for problem Pro based on
%   particles P, personal best particles Pbest, and global best particles
%   Gbest. P, Pbest, and Gbest should be arrays of SOLUTION objects, and
%   Off is also an array of SOLUTION objects. Each object of P, Pbest, and
%   Gbest is used to generate one offspring.
%
%   Off = OperatorPSO(Pro,P,Pbest,Gbest,W) specifies the parameter of the
%   operator, where W is the inertia weight.
%
%   Example:
%       Off = OperatorPSO(Problem,Population,Pbest,Gbest)

%------------------------------- Reference --------------------------------
% C. A. Coello Coello and M. S. Lechuga, MOPSO: A proposal for multiple
% objective particle swarm optimization, Proceedings of the IEEE Congress
% on Evolutionary Computation, 2002, 1051-1056.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Parameter setting
    ParticleDec = Parent.decs;
    ArchiveDec = Archive.decs;
    [N,D]       = size(ParticleDec);
%     leader_rand=rand(size(ArchiveDec,1),D);
%     leader_pos=ArchiveDec.*leader_rand;
%     virtual_leader=sum(leader_pos,1)/size(ArchiveDec,1);
    Offspring=[];
    %% Particle swarm optimization
    for i=1:nArmies
        for j=1:nSoldiers
            r=randi(nArmies,1);
            while(i==r)
                r=randi(nArmies,1);
            end
            for d=1:D
                if rand<BCB
                    alpha=rand*2*pi;
%                     soldiers(j,d)=virtual_leader(d)+abs(ParticleDec(r,d)-ParticleDec(i,d))*sin(alpha);
                    soldiers(j,d)=ArchiveDec(i,d)+abs(ParticleDec(r,d)-ParticleDec(i,d))*sin(alpha);
                else
                    beta=rand*2*pi;
                    soldiers(j,d)=ParticleDec(r,d)+abs(ParticleDec(r,d)-ParticleDec(i,d))*cos(beta);
                end% end BCB
                soldiers(j,d)=max(min(soldiers(j,d),Problem.upper(d)),Problem.lower(d));
            end% end D
        end% end nSoldiers
        Offspring=[Offspring;soldiers];
    end% end nArmies
    Offspring = Problem.Evaluation(Offspring);
end