using JuMP
using DelimitedFiles
using Cbc
using MathOptInterface
using CSV
using DataFrames

const MOI = MathOptInterface

fileName = []
agentsNumber = []
solveTime = []
isOptimalSolution = []
solution = []

# Obtendo o nome de todas as instâncias
files = readdir("instancias/instb"; join=true)

# Iterando sob cada instância
for f in files

    # Criando o modelo que usa o CBC solver
    model = Model(Cbc.Optimizer)
    set_optimizer_attribute(model, "seconds", 60 * 30)
    set_optimizer_attribute(model, "Heuristics", "off")
    set_optimizer_attribute(model, "logLevel", 0)

    # Lendo a matriz de custo
    c = readdlm(f, Float64)

    # Checando o tamanho das linhas da matriz
    n = size(c)[1]

    # Definindo variável de decisão -> Xij = {0,1}
    @variable(model,x[i=1:n,j=1:n], Bin)

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
    JuMP.optimize!(model)

    push!(fileName, f)
    push!(agentsNumber, n)
    push!(solveTime, solve_time(model))
    push!(isOptimalSolution, termination_status(model) == MOI.OPTIMAL)
    push!(solution, objective_value(model))

    println("File name -> ", f)
end

const dataFrame = DataFrame(
    file_name = fileName,
    agents_number = agentsNumber,
    solve_time = solveTime,
    is_optimal_solution = isOptimalSolution,
    solution = solution
)

CSV.write("cbc_data_instb.csv", dataFrame)

println(dataFrame)
