function [bestmem,bestval,nfeval, Individuos_best, guilherme] = differential_evolution(fname,VTR,D,XVmin,XVmax,y,NP,itermax,F,CR,strategy,refresh,icontador)

miyadaira = 0;
guilherme = zeros(NP,D+1);

%-----Initialize population and some arrays-------------------------------

pop = zeros(NP,D); %initialize pop to gain speed

%----pop is a matrix of size NPxD. It will be initialized-------------
%----with random values between the min and max values of the---------
%----parameters-------------------------------------------------------

NPinitial=NP;

for i=1:NP
   pop(i,:) = XVmin + rand(1,D).*(XVmax - XVmin);
end

popold    = zeros(size(pop));       % toggle population
val       = zeros(1,NP);            % create and reset the "cost array"
bestmem   = zeros(1,D);             % best population member ever
bestmemit = zeros(1,D);             % best population member in iteration
nfeval    = 0;                      % number of function evaluations
Individuos_best = zeros(1,itermax); % best evaluations of each iteration

%------Evaluate the best member after initialization----------------------

ibest   = 1;                      % start with first population member
miyadaira = miyadaira + 1;
val(1)  = feval(fname,pop(ibest,:),y,[1 1 miyadaira]);
val = real(val(imag(val) == 0));
bestval = val(1);                 % best objective function value so far
nfeval  = nfeval + 1;

for i=2:NP
	miyadaira = miyadaira + 1;
	val(i) = feval(fname,pop(i,:),y,[1 i miyadaira]);   % check the remaining members
	val = real(val(imag(val) == 0));
    nfeval  = nfeval + 1;
	if (val(i) < bestval)         % if member is better
        ibest   = i;              % save its location
        bestval = val(i);
    end
end
bestmemit = pop(ibest,:);         % best member of current iteration
bestvalit = bestval;              % best value of current iteration

bestmem = bestmemit;              % best member ever

%------DE-Minimization---------------------------------------------
%------popold is the population which has to compete. It is--------
%------static through one iteration. pop is the newly--------------
%------emerging population.----------------------------------------

pm1 = zeros(NP,D);              % initialize population matrix 1
pm2 = zeros(NP,D);              % initialize population matrix 2
pm3 = zeros(NP,D);              % initialize population matrix 3
pm4 = zeros(NP,D);              % initialize population matrix 4
pm5 = zeros(NP,D);              % initialize population matrix 5
bm  = zeros(NP,D);              % initialize bestmember  matrix
ui  = zeros(NP,D);              % intermediate population of perturbed vectors
mui = zeros(NP,D);              % mask for intermediate population
mpo = zeros(NP,D);              % mask for old population
rot = (0:1:NP-1);               % rotating index array (size NP)
rotd= (0:1:D-1);                % rotating index array (size D)
rt  = zeros(NP);                % another rotating index array
rtd = zeros(D);                 % rotating index array for exponential crossover
a1  = zeros(NP);                % index array
a2  = zeros(NP);                % index array
a3  = zeros(NP);                % index array
a4  = zeros(NP);                % index array
a5  = zeros(NP);                % index array
ind = zeros(4);

iter = 1;

logistic_F(1)=F;
logistic_cr(1)=CR;

worst=0.1;

clear NPold

% fprintf(1,' ===================================================================================================================\n');
% fprintf(1,'                          DIFFERENTIAL EVOLUTION ALGORITHM WITH ADAPTIVE POPULATION SIZE                      \n');
% fprintf(1,' ===================================================================================================================\n');
% fprintf(1,'   Strategy implemented by Fran Sérgio Lobato - 16-Sep-2008 \n');
% fprintf(1,' ===================================================================================================================\n');
  
while (iter <= itermax)% & (abs(bestval-worst) > VTR))
      
logistic_F(iter+1)=3.57*logistic_F(iter)*(1-logistic_F(iter));
logistic_cr(iter+1)=3.57*logistic_cr(iter)*(1-logistic_cr(iter));  
 
F=logistic_F(iter+1);
CR=logistic_cr(iter+1);

   popold = pop;                   % save the old population

  ind = randperm(4);              % index pointer array

  a1  = randperm(NP);             % shuffle locations of vectors
  rt = rem(rot+ind(1),NP);        % rotate indices by ind(1) positions
  a2  = a1(rt+1);                 % rotate vector locations
  rt = rem(rot+ind(2),NP);
  a3  = a2(rt+1);                
  rt = rem(rot+ind(3),NP);
  a4  = a3(rt+1);               
  rt = rem(rot+ind(4),NP);
  a5  = a4(rt+1);                

  pm1 = popold(a1,:);             % shuffled population 1
  pm2 = popold(a2,:);             % shuffled population 2
  pm3 = popold(a3,:);             % shuffled population 3
  pm4 = popold(a4,:);             % shuffled population 4
  pm5 = popold(a5,:);             % shuffled population 5

  for i=1:NP                      % population filled with the best member
    bm(i,:) = bestmemit;          % of the last iteration
  end

  mui = rand(NP,D) < CR;          % all random numbers < CR are 1, 0 otherwise

  if (strategy > 5)
    st = strategy-5;		  % binomial crossover
  else
    st = strategy;		  % exponential crossover
    mui=sort(mui');	      % transpose, collect 1's in each column
    for i=1:NP
      n=floor(rand*D);
      if n > 0
         rtd = rem(rotd+n,D);
         mui(:,i) = mui(rtd+1,i); %rotate column i by n
      end
    end
    mui = mui';			  % transpose back
  end
  mpo = mui < 0.5;                % inverse mask to mui

  if (st == 1)                      % DE/best/1
    ui = bm + F*(pm1 - pm2);        % differential variation
    ui = popold.*mpo + ui.*mui;     % crossover
  elseif (st == 2)                  % DE/rand/1
    ui = pm3 + F*(pm1 - pm2);       % differential variation
    ui = popold.*mpo + ui.*mui;     % crossover
  elseif (st == 3)                  % DE/rand-to-best/1
    ui = popold + F*(bm-popold) + F*(pm1 - pm2);        
    ui = popold.*mpo + ui.*mui;     % crossover
  elseif (st == 4)                  % DE/best/2
    ui = bm + F*(pm1 - pm2 + pm3 - pm4);  % differential variation
    ui = popold.*mpo + ui.*mui;           % crossover
  elseif (st == 5)                  % DE/rand/2
    ui = pm5 + F*(pm1 - pm2 + pm3 - pm4);  % differential variation
    ui = popold.*mpo + ui.*mui;            % crossover
  end
  
  for ii=1:NP
   for jj=1:D
     if ui(ii,jj)<XVmin(jj);
      ui(ii,jj)=XVmin(jj);
     end
      if ui(ii,jj)>XVmax(jj);
      ui(ii,jj)=XVmax(jj);
     end
   end
  end
  
%   tempfun = zeors(1,NP);
%-----Select which vectors are allowed to enter the new population------------
for i=1:NP
	miyadaira = miyadaira + 1;
	tempval = feval(fname,ui(i,:),y,[iter i miyadaira]);   % check cost of competitor
	if iter == itermax
		guilherme(i,1) = tempval;
		guilherme(i,2:D+1) = ui(i,:);
	end
	tempfun(i) = tempval;
	nfeval  = nfeval + 1;
    if (tempval <= val(i))  % if competitor is better than value in "cost array"
        pop(i,:) = ui(i,:);     % replace old vector with new one (for new iteration)
        val(i)   = tempval;  % save value in "cost array"
        
        %----we update bestval only in case of success to save time-----------
        if (tempval < bestval)      % if competitor better than the best one ever
            bestval = tempval;      % new best value
            bestmem = ui(i,:);      % new best parameter vector ever
        end
    end
end %---end for imember=1:NP
  
  bestmemit = bestmem;       % freeze the best member of this iteration for the coming 
                             % iteration. This is needed for some of the strategies.
 
  [pop val'];                      
%----Output section----------------------------------------------------------
%  fprintf(1,'\n');
  average=1/NP*(sum(tempfun));
  worst=max(tempfun);
  rate=abs(average/worst);
  best_f(iter,:)=[iter bestval];
  rate_ant(iter)=rate;
  best_x(iter,:)=[iter bestmem]; 
  
  if rate>1
   rate=1/rate;
  end
   
  dynpop=round(5*rate+NP*(1-rate));
   
  if iter>1
   if rate<rate_ant(iter-1)
    dynpop=round(5*rate+NPinitial*(1-rate));  
   end
  end
    
  nitrate(iter,:)       = [iter rate];
  nitdynpop(iter,:)     = [iter dynpop];
  Individuos_best(iter) = bestval; 
   
 if dynpop ~= NP 
   [pops,vval,nfevalaux] = popsize(fname,D,XVmin,XVmax,dynpop,NP,F,CR,strategy,pop,val);
   nfeval  = nfeval + nfevalaux;
   pop=[];
   pop=pops;
   NP=dynpop;
   clear a1 rt a2 a3 a4 a5 pm1 pm2 pm3 pm4 pm5 ui bm mui mpo rot rotd val popold
   
   popold = pop;
 
   pm1 = zeros(NP,D);              % initialize population matrix 1
   pm2 = zeros(NP,D);              % initialize population matrix 2
   pm3 = zeros(NP,D);              % initialize population matrix 3
   pm4 = zeros(NP,D);              % initialize population matrix 4
   pm5 = zeros(NP,D);              % initialize population matrix 5
   bm  = zeros(NP,D);              % initialize bestmember  matrix
   ui  = zeros(NP,D);              % intermediate population of perturbed vectors
   mui = zeros(NP,D);              % mask for intermediate population
   mpo = zeros(NP,D);              % mask for old population
   rot = (0:1:NP-1);               % rotating index array (size NP)
   rotd= (0:1:D-1);                % rotating index array (size D)
   rt  = zeros(NP);                % another rotating index array
   rtd = zeros(D);                 % rotating index array for exponential crossover
   a1  = zeros(NP);                % index array
   a2  = zeros(NP);                % index array
   a3  = zeros(NP);                % index array
   a4  = zeros(NP);                % index array
   a5  = zeros(NP);                % index array

   rot = (0:1:NP-1); 
   a1  = randperm(NP);             % shuffle locations of vectors
   rt = rem(rot+ind(1),NP);        % rotate indices by ind(1) positions
   a2  = a1(rt+1);                 % rotate vector locations
   rt = rem(rot+ind(2),NP);
   a3  = a2(rt+1);                
   rt = rem(rot+ind(3),NP);
   a4  = a3(rt+1);               
   rt = rem(rot+ind(4),NP);
   a5  = a4(rt+1);                

   pm1 = popold(a1,:);             % shuffled population 1
   pm2 = popold(a2,:);             % shuffled population 2
   pm3 = popold(a3,:);             % shuffled population 3
   pm4 = popold(a4,:);             % shuffled population 4
   pm5 = popold(a5,:);             % shuffled population 5
  
   val=vval';
 end
 
if (refresh > 0)
    if (rem(iter,refresh) == 0)
       fprintf('Otimização nº: %d\n', icontador)
       fprintf(1,'Iteration: %d,  Best: %1.4f,  F: %1.2f,  CR: %1.2f,  NP: %d\n',iter,bestval,F,CR,NP);        
    end
end
 iter = iter + 1;
 save('Backup.mat');
end %---end while ((iter < itermax) ...

% grava_arquivos(icontador,best_f,best_x,nitrate,nitdynpop)

