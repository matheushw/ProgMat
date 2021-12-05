using JuMP
using DelimitedFiles
using Gurobi
using MathOptInterface
using CSV
using DataFrames

const MOI = MathOptInterface

# Criando os arrays que irão armazenar os dados de resolução de cada instância
fileName = []
tasksNumber = []
agentsNumber = []
solveTime = []
solution = []
isOptimalSolution = []
nodeCount = []
bounds = []
dualObjective = []
relativeGap = []

const GRB_ENV = Gurobi.Env()

# Criando uma instância do solver Gurobi
solver = () -> Gurobi.Optimizer(GRB_ENV)

# Obtendo o nome de todas as instâncias
files = readdir("ip2"; join=true)

# m (numero de agentes) n (numero de tarefas)
# for (agentes)
    # x_ij (satisfação/lucro por alocar a tarefa j ao agente i)
# for (agentes)
    # a_ij (recurso consumido ao alocar a tarefa j ao agente i)
# for (agentes)
    # cap_i (capacidade do agente i)

# Iterando sob cada instância
for f in files
    # Criando o modelo que usa o Gurobi solver
    model = Model(solver)
    set_optimizer_attribute(model, "TimeLimit", 3 * 60)
    set_optimizer_attribute(model, "Presolve", 0)
    set_optimizer_attribute(model, "VarBranch", 0)
    set_optimizer_attribute(model, "OutputFlag", 1)

    inst = open(f)

    m, n = split(readline(inst), " ")
    
    n = parse(Int64, n)
    m = parse(Int64, m)

    c = Array{Float64}(undef, m, n)
    a = Array{Float64}(undef, m, n)
    cap = Array{Float64}(undef, m)

    for i in 1:m
        line = split(readline(inst), " ")
        for j in 1:n
            c[i, j] = parse(Float64, line[j])
        end
    end

    for i in 1:m
        line = split(readline(inst), " ")
        for j in 1:n
            a[i, j] = parse(Float64, line[j])
        end
    end

    line = split(readline(inst), " ")

    for i in 1:m
        cap[i] = parse(Float64, line[i])
    end
    
    # Definindo variável de decisão -> Xij = {0,1}
    @variable(model, x[i=1:m,j=1:n], Bin)

    # Função objetivo
    @objective(model, Max, sum(c[i, j] * x[i, j] for i in 1:m, j in 1:n))

    # Restrições para garantir a saída de todo vértice
    for j in 1:n
        @constraint(model, sum(x[i, j] for i in 1:m) == 1)
    end

    for i in 1:m
        @constraint(model, sum(a[i, j] * x[i, j] for j in 1:n) <= cap[i])
    end

    # Trazendo uma solução otima
    JuMP.optimize!(model)

    # Adicionando nos arrays os valores referentes a instância em questão e sua solução.
    push!(fileName, f)
    push!(agentsNumber, m)
    push!(tasksNumber, n)
    push!(solveTime, solve_time(model))
    push!(isOptimalSolution, termination_status(model) == MOI.OPTIMAL)
    push!(solution, objective_value(model))
    push!(nodeCount, node_count(model))
    push!(dualObjective, dual_objective_value(model))
    push!(relativeGap, relative_gap(model))

end

const dataFrame = DataFrame(
    file_name = fileName,
    agents_number = agentsNumber,
    tasks_number = tasksNumber,
    solve_time = solveTime,
    is_optimal_solution = isOptimalSolution,
    solution = solution,
    node_count = nodeCount,
    dual_objective = dualObjective,
    relative_gap = relativeGap
)

# Escrevendo esse dataframe em um .csv para uma futura análise dos dados
CSV.write("instances_data_variable_branch_1.csv", dataFrame)

println(dataFrame)