%% curvefit.m  Curve fitting demonstration code

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
for j=1:SubjectCount

% set subject dependent x and y values
for i=1:length(a)
  
    if mat(i,1)== j
    
        dyp(k)= mat(i,4)
        dyd(k)= mat(i,5)
        dx(k) = mat(i,2)% x values are diffrent treatments
        dy(k) = dyd(k).*dyp(k)% y values are Integral of Relief
        k=k+1
        
   end

end

fitfn = @( x, a, b) a*(x)+ b;

% make the error function (sum-of-squares)
% (see steps1.m for a step-by-step construction of this function)
errfn = @( p ) sum( ( fitfn(dx,p(1),p(2)) - dy ).^2 );

% minimize the error function
phat = fminsearch(errfn,[ 0 1 0 ]);

% report results of fit
fprintf(1,'fit1:  y = (%.2f)x + (%.2f) \n',phat(1),phat(2));


y= phat(1)*x + phat(2)


% create emprical growth plot
subplot(squareGrid,squareGrid,j)        %squareGrid ensures function is scalable
hold on
plot(dx,dy,'k.','MarkerSize',8)
plot(x,y,'k')
hold off
axis([1 3 -200 2500])
xlabel 'Treatment'
ylabel 'IPR'
txt1 = (['ID ' num2str(j)])
text(2.25,2200,txt1)
box off

%reset loop variables
k = 1
dx=0
dy=0
dyp=0
dyd=0
end