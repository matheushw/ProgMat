using DelimitedFiles
using Hungarian
using CSV
using DataFrames

fileName = []
agentsNumber = []
solveTime = []
solution = []

# Obtendo o nome de todas as instâncias
files = readdir("instancias/instb"; join=true)

# Iterando sob cada instância
for f in files
    # Lendo a matriz de custo
    c = readdlm(f, Float64)

    # Checando o tamanho das linhas da matriz
    n = size(c)[1]

    start_time = time_ns()
    assignment, cost = hungarian(-c)
    end_time = time_ns()

    elapsed = (end_time - start_time)*1e-9

    push!(fileName, f)
    push!(agentsNumber, n)
    push!(solveTime, elapsed)
    push!(solution, -cost)

    println("File name -> ", f)
    println("Cost -> ", -cost)
end

const dataFrame = DataFrame(
    file_name = fileName,
    agents_number = agentsNumber,
    solve_time = solveTime,
    solution = solution
)

CSV.write("hungarian_data_instb.csv", dataFrame)

println(dataFrame)
