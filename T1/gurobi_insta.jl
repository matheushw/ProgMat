using JuMP
using Gurobi
using DelimitedFiles

const GRB_ENV = Gurobi.Env()

# Criando o modelo com o resolvedor Gurobi sem heurística e tempo limite de 30min
solver = () -> Gurobi.Optimizer(GRB_ENV)

# walkdir("instancias/insta")
files = readdir("instancias/insta"; join=true)

for f in files
    model = Model(solver)
    set_optimizer_attribute(model, "TimeLimit", 30)
    set_optimizer_attribute(model, "Heuristics", 0.0)
    set_optimizer_attribute(model, "OutputFlag", 0)
    
    c = readdlm(f, Int)

    n = size(c)[1]

    # Definindo variável de decisão -> Xij = {0,1}
    @variable(model,x[i=1:n,j=1:n],Bin)

    # Função objetivo
    @objective(model, Max, sum(c[i, j] * x[i, j] for i in 1:n, j in 1:n))

    # Restrições para garantir a saída de todo vértice
    for i in 1:n
        @constraint(model,sum(x[i,j] for j in 1 : n) == 1)
    end

    # Restrições para garantir a chegada em cada vértice
    for j in 1:n
        @constraint(model,sum(x[i,j] for i in 1:n) == 1)
    end
    
    # Trazendo uma solução otima
    optimize!(model)
    
    println("File name -> ",  f)
    println("Agents -> ",  n)
    println("Solve time -> ",  solve_time(model))
    println("\n-----------------------------\n")
    
end
