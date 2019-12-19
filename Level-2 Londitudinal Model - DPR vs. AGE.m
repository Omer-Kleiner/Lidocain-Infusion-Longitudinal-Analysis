%% curvefit.m  Curve fitting demonstration code
clc; clear;
%% Load univeriable Data Set
mat=xlsread('longitudinal Data set');

%set loop variables
Subjectarray = mat(:,1)                           % subject array
SubjectList = unique(Subjectarray)                % make list of subject
SubjectCount = length(SubjectList)                % count subject
Trialarray=mat(:,2)                               % trial array
TrialList = unique(Trialarray)                    % make list of trials
TrialCount = length(TrialList)                    % count trial
k = 1;

%set plotting variables
x=(1:3)';                                         % set x array
ytotal=x;                                         % set y array
XT = cell(SubjectCount,1);                        % set design matrix array
XTR = cell(SubjectCount,1);                        % set design matrix array
shiftVar=0

%% create loop for each Subject
for j=1:SubjectCount;
    
XTA = ones(TrialCount,6);                       % set design matrix

% set subject dependent x and y values
for i=1:length(Subjectarray);


    if mat(i,1)== j;
    
        dx(k)= mat(i,2);% x values are diffrent treatments
        dy(k)= mat(i,5);
        k=k+1;
    end

end

fitfn = @( x, a, b) a*(x)+ b;

% make the error function (sum-of-squares)
% (see steps1.m for a step-by-step construction of this function)
errfn = @( p ) sum( ( fitfn(dx,p(1),p(2)) - dy ).^2 );

% minimize the error function
phat = fminsearch(errfn,[ 0 0 ]);

% report results of fit
fprintf(1,'fit1:  y = (%.2f)x + (%.2f) \n',phat(1),phat(2));

% final y function
y= phat(1)*x + phat(2);

%mvregress does not accept negative numbers. This function finds any y
%values below 0 and compares them to one another. the most negative number
%is saved and later the entire plot is shifted up so that the most negative
%point on the graph iz zero. Because this model is comparing the two
%diffrent populations this shift will not affect the outcome.
for i=1:length(x)
    if y(i)<0
       if abs(y(i))>shiftVar
        shiftVar=abs(y(i))
       end
    end
end
   
for i=1:length(Subjectarray);
  
    if mat(i,1)== j;
ytotal(:,j)= [y]            % store line function of each line of each regression in single matrix
    if mat(i,7)>=65          % set predictor variable function in design matrix
     XTA(:,2)=0         
     end
XTA(:,3)=x              % set x value in design matrix
XTA(:,4)=(x.^2)        % set x squared value in design matrix
XTA(:,5)= ((XTA(:,2)).*(XTA(:,3))) % set x value as a function of the predictor variable in design matrix
XTA(:,6)=((XTA(:,2)).*(XTA(:,4))) %setsquared as a function of the predictor variable in design matrix
XT{j}=XTA                  % add design matrix to matrice array
    end

    %Note: Must devide the deign Matrices values by 100 to allow for
    %consistent scale when using the regression function. Will be re-added
    %once function is compete.
    
end

%reset loop variables
k = 1;
dx=0;
dy=0;
end

yfinal = (shiftVar+1+ytotal')

%% Create aveage line of regression
[b,sig,E,V,loglikF] = mvregress(XT,yfinal);   %annalyze reggresion of design matrice array and y function matrix
[b sqrt(diag(V))]

% define which component matrices apply to which predictor variable
for i=1:length(XT)
    if XT{i}(1,2)==0
    Yhatf = XT{i}*b;
    else
    Yhatm = XT{i}*b;
    end
end


% Plot Level-2 Model
figure()
plot(x',yfinal)
hold on
hf = plot(x,Yhatf,'k--','LineWidth',2);
hm = plot(x,Yhatm,'k','LineWidth',2);
legend([hf,hm],'Females','Males','Location','NorthWest')
title('Duration of Pain Relief by Age')
ylabel('DPR')
xlabel('Treatment')
hold off

%Define a reduced model
for i=1:(SubjectCount)
XTR{i}= XT{i}(:,1:4)
end

%fit a reduced model----Note: I have tried for hours to get this function
%to accept my reduced model but have been unsuccseful. this is where my
%model breaks
[bR,sigR,ER,VR,loglikR] = mvregress(XTR,yfinal);
[bR,sqrt(diag(VR))]

%likelihood ratio test gives a p-valu to test the hypothesis
LR = 2*(loglikF-loglikR);
pval = 1 - chi2cdf(LR,2);