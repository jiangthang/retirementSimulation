format longG

annualIncome = 66800;
savingRate = 0.0597;
annualExpense = 47008.58;


n = 10000;
n_sim = 1;
success = Inf*ones(1,n);
successAll = Inf*ones(1,n_sim);
wRetire = Inf*ones(1,n);
wDeath = Inf*ones(1,n);
failYear = [];

siml = Inf*ones(n,70);

for k = 1: n_sim

    for j = 1:n
        success(j) = 1;
    
        u = rand;
        finish = deathAge(u) - 30;
        
        w = Inf*ones(1,finish);
        w(1) = annualIncome*savingRate;
        siml(j,1) = w(1);
        r = 0.074+0.11*my_laplace(1,finish);
        
        for i = 2:finish
            if i <= 35
                w(i) = w(i-1)*(exp(r(i-1))) + w(1);
            else
                w(i) = (w(i-1)-annualExpense)*(exp(r(i-1)));

                if w(i) <= 0
                    if success(j) == 1
                        success(j) = 0;
                        failYear(end+1) = i+30;
                    end
                end
            end

            siml(j,i) = w(i);
        end
        
        wDeath(j) = w(i);
        wRetire(j) = w(35);   
    end

success;
numSuccess = sum(success);
successAll(k) = numSuccess;

end





function r = my_laplace(start, finish)
    r = ones(start, finish);
    for i = start:finish
        x1 = -log(1-rand);
        x2 = -log(1-rand);
        
        z = x1-x2;
        r(i) = z;
    end
end

function age = deathAge(u)
   
    x = 1/0.5627*log(u/(0.0148/0.5627)+1);

        if x<2
            age = floor(65+(x-1)*5);
        elseif x<3
            age = floor(70+(x-2)*5);
        elseif x<4
            age = floor(75+(x-3)*5);
        elseif x<5
            age = floor(80+(x-4)*5);
        elseif x<6
            age = floor(85+(x-5)*5);
        elseif x<7
            age = floor(90+(x-6)*10);
        end

end
