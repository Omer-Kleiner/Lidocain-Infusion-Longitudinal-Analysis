%% curvefit.m  Curve fitting demonstration code
clc; clear;
%% Load univeriable Data Set
mat=xlsread('longitudinal Data set');

%set loop variables
a = mat(:,1);                           % subject array
SubjectList = unique(a);                % make list of subject
SubjectCount = length(SubjectList);     % count subject
squareGrid=ceil(SubjectCount.^0.5);     % Squareroot of number of subjects
k = 1;

%set plotting variables
x=(1:3)';

%% create loop for each Subject
for j=1:SubjectCount;

% set subject dependent x and y values
for i=1:length(a);
  
    if mat(i,1)== j;
    
        dx(k)= mat(i,2); % x values are diffrent treatments
        dy(k)= mat(i,4); % y values are Percentage of Relief
        k=k+1;
    end

end

%% sum-of-squares curve fitting

% make the fitting function
fitfn = @( x, a, b) a*(x)+ b;

% make the error function (sum-of-squares)
errfn = @( p ) sum( ( fitfn(dx,p(1),p(2)) - dy ).^2 );

% minimize the error function
phat = fminsearch(errfn,[ 0 0 ]);

% report results of fit
fprintf(1,'fit1:  y = (%.2f)x + (%.2f) \n',phat(1),phat(2));


y= phat(1)*x + phat(2);


% create emprical growth plot
subplot(squareGrid,squareGrid,j);        %squareGrid ensures function is scalable
hold on
plot(dx,dy,'k.','MarkerSize',8);
plot(x,y,'k');
hold off
axis([1 3 -15 100]);
xlabel 'Treatment';
ylabel 'PPR';
txt1 = (['ID ' num2str(j)]);
text(2.25,90,txt1);
box off

%reset loop variables
k = 1;
dx=0;
dy=0;
end