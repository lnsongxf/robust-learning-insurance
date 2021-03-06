function [ domain, c, PolicyRulesStore]=TuneValueFunction(Para,c,Q,domain,PolicyRulesStore,MaxTuneIter)
Para.KTR.lb=[Para.Delta Para.Delta -inf, -inf];
Para.KTR.ub=[Para.y-Para.Delta Para.y-Para.Delta  inf inf];


for iter=1:MaxTuneIter
    OptContract=PolicyRulesStore(1,:);
    % Initialize the initial guess for the policy rules that the inner
    % optimization will solve
   for ctr=1:Para.vGridSize        
        InitContract=OptContract;
        % INNER OPTIMIZATION
        strucOptimalContract=SolveInnerOptimization(domain(ctr),InitContract,Para,c,Q) ;      
             PolicyRulesStore(ctr,:)=strucOptimalContract.Contract;   
                QNew(ctr)=strucOptimalContract.QNew;
     ExitFlag(ctr)=strucOptimalContract.ExitFlag
    end
    % UPDATE NEW COEFF
    
   [ cNew ] = (FitConcaveValueFunction(Q,QNew',domain',domain(1:2:end)'))';
   cold=c;
   c=Para.grelax*cold+(1-Para.grelax)*cNew;
    toc
   
end
vMin=max
if ResMapConsumptionToValue((Para.y-Para.Delta)*.99,min(domain),c,Q,Para,domain',PolicyRulesStore,2)>0
vMin=fzero(@(v) ResMapConsumptionToValue((Para.y-Para.Delta)*.99,v,c,Q,Para,domain',PolicyRulesStore,2) ,min(domain));
end
vMin= max(vMin,min(PolicyRulesStore(:,3:4)));
if ResMapConsumptionToValue((Para.Delta)*1.01,max(domain),c,Q,Para,domain',PolicyRulesStore,1)<0
vMax=fzero(@(v) ResMapConsumptionToValue((Para.Delta)*1.01,v,c,Q,Para,domain',PolicyRulesStore,1) ,max(domain));
end
 vMax=min(vMax,max(PolicyRulesStore(:,3:4)));

domain=linspace(vMin,vMax,Para.vGridSize);