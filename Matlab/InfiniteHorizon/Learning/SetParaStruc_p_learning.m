% This sets up the para struc for the case with persistent learning. The
% change is the description of the matrix P_M. Now it is choosen such thatn
% the steadys tate (bayesian) of learning is not degenerate and has a wide
% support (aprox .3 to .7). The data and the plot path has been changed to
% avoid duplication with the satandard case
Para.BenchMark=0;
CompStr=computer;
switch CompStr

case 'PCWIN64'
BaseDirectory='C:\Users\anmol\Dropbox\ProjectRobustLearning\Matlab\';
SL='\';
case 'GLNX86'

BaseDirectory='/home/anmol/Dropbox/ProjectRobustLearning/Matlab/';
SL='/';

    case 'MACI64'
        BaseDirectory ='/Users/meetanmol/Dropbox/ProjectRobustLearning/Matlab/';
SL='/';
    otherwise
BaseDirectory ='/home/apb296/robust-learning-insurance/Matlab/';

SL='/';
end

CompEconPath=[ BaseDirectory 'compecon2011' SL 'CEtools' SL];

addpath(genpath(CompEconPath));

PlotPath=[BaseDirectory 'InfiniteHorizon' SL 'Learning' SL  'Plots' SL];
TexPath=[BaseDirectory 'InfiniteHorizon' SL 'Learning' SL  'Tex' SL];
DataPath=[BaseDirectory 'InfiniteHorizon' SL 'Learning' SL  'Data' SL];
NoLearningPath=[BaseDirectory 'InfiniteHorizon' SL ];
LearningPath=[BaseDirectory 'InfiniteHorizon' SL 'Learning' SL];



mkdir(PlotPath)
mkdir(TexPath)
mkdir(DataPath)
addpath(genpath(CompEconPath));
ybar=1;
g=.3;
theta11=.50000000;
theta12=.50000000;
delta=.9;
theta11*delta/theta12-1;
ra=.5;
pi1=.5;

% Aggregate States
yl=ybar*(1-g);
yh=ybar*(1+g);
%yl=ybar*.1;
%yh=ybar;
YS=[yl;yh];
Y=[yl;yl;yh;yh];
% Idiosyncratic States
sl=.2;
sh=.8;
S=[sl;sh];
% 2 Models
M=[1;2];
MSize=length(M);

%%%%%%%%%%%%%%%%%%%%%
 
% P_M=[.1 .9;
 %      .9 .1];
 P_M=[1 0;
     0 1];


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %Prior

% Theta(i,j)=agent(i) operator(j)
theta21=theta11;
theta22=theta12;
Theta=[theta11 theta12;theta21 theta22];
%Model 1 
p_ylow_ylow(1)=.5;
p_ylow_yhigh(1)=1-p_ylow_ylow(1);
p_yhigh_yhigh(1)=.5;
p_yhigh_ylow(1)=1-p_yhigh_yhigh(1);
p_slow_ylow(1)=.5;
p_shigh_ylow(1)=1-p_slow_ylow(1);
p_slow_yhigh(1)=.5;
p_shigh_yhigh(1)=1-p_slow_yhigh(1);
%Model 2
p_ylow_ylow(2)=.9;
p_ylow_yhigh(2)=1-p_ylow_ylow(2);
p_yhigh_yhigh(2)=.9;
p_yhigh_ylow(2)=1-p_yhigh_yhigh(2);
p_slow_ylow(2)=.9;
p_shigh_ylow(2)=1-p_slow_ylow(2);
p_slow_yhigh(2)=.5;
p_shigh_yhigh(2)=1-p_slow_yhigh(2);



for m =1:MSize
    P(:,:,m) = [p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_ylow_ylow(m)*p_slow_ylow(m) p_ylow_ylow(m)*p_shigh_ylow(m) p_ylow_yhigh(m)*p_slow_yhigh(m) p_ylow_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        p_yhigh_ylow(m)*p_slow_ylow(m) p_yhigh_ylow(m)*p_shigh_ylow(m) p_yhigh_yhigh(m)*p_slow_yhigh(m) p_yhigh_yhigh(m)*p_shigh_yhigh(m) 
        ];
end


 
% 
% for m =1:MSize
%     P(:,:,m) = [c*alpha(m)*beta(m) alpha(m)*(1-c*beta(m)) c*(1-alpha(m))*beta(m) (1-alpha(m))*(1-c*beta(m));
%         alpha(m)*(1-c*beta(m)) c*alpha(m)*beta(m) (1-alpha(m))*(1-c*beta(m)) c*(1-alpha(m))*beta(m);
%         (1-alpha(m))*beta(m)  (1-alpha(m))*(1-beta(m)) alpha(m)*beta(m) alpha(m)*(1-beta(m));
%         (1-alpha(m))*(1-beta(m))  (1-alpha(m))*(beta(m)) alpha(m)*(1-beta(m)) alpha(m)*(beta(m))
%         ];
% end

%Define Struct for Para
pi=[pi1;(1-pi1)];
Pi=[pi pi];
C=['r','r','b','b'];
ZSize=4;
ctol=1e-7;
grelax=.98;

% Parameters for the approximation



ApproxMethod='cheb';
OrderOfApproximation=2;
OrderOfApproximationPi=2;
OrderOfApproximationV=2;
VGridDensityFactor=2;
PiGridDensityFactor=2;

% Parameters for the approximation
ApproxMethod='spli';
OrderOfApproximation=3;
OrderOfApproximationPi=15;
OrderOfApproximationV=20;
OrderOfSpline=3;
VGridDensityFactor=2;
PiGridDensityFactor=1;


NIter=100;
% store the para struc
Para.CompEconPath=CompEconPath;
Para.PlotPath=PlotPath;
Para.TexPath=TexPath;
Para.DataPath=DataPath;
Para.NoLearningPath=NoLearningPath;
Para.LearningPath=LearningPath;
Para.P_M=P_M;
Para.delta=delta;
Para.g=g;
Para.Y=Y;
Para.M=M;
Para.Theta=Theta;
Para.P=P;
Para.RA=ra;
Para.MSize=MSize;
Para.Pi=Pi;
Para.ZSize=ZSize;
Para.ctol=ctol;
Para.grelax=grelax;
Para.ApproxMethod=ApproxMethod;
Para.OrderOfApproximationPi=OrderOfApproximationPi;
Para.OrderOfApproximationV=OrderOfApproximationV;
Para.VGridDensityFactor=VGridDensityFactor;
Para.PiGridDensityFactor=PiGridDensityFactor;
Para.NIter=NIter;
Para.StateName={'$(y_{l},s_{l})$','$(y_{l},s_{h})$','$(y_{h},s_{l})$','$(y_{h},s_{h})$'};
Para.N=10000;



