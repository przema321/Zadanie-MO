
using JuMP
using CSV
using DataFrames
#using AmplNLWriter


data_mass = dropmissing(CSV.read("plecak.csv"))
data_plan = CSV.read("plan.csv")

plan_summary = by(data_plan, [:Przedmiot], plan_summary -> size(plan_summary, 1))
mass_summary = by(data_mass, [:Przedmiot], mass_summary -> sum(mass_summary[:Waga]))

przybory_mass = mass_summary[mass_summary[:Przedmiot] .== "Przybory", :][:x1] / 1000

mass_summary = mass_summary[mass_summary[:Przedmiot] .!= "Przybory", :]

dict_plan = Dict(zip(plan_summary[:Przedmiot], plan_summary[:x1]))
dict_mass = Dict(zip(mass_summary[:Przedmiot], mass_summary[:x1]))

data_in= DataFrame(Przedmiot = String[],
    Sztuk = Int64[],
    Waga = Float64[])

for row in 1:size(plan_summary, 1)
    course = plan_summary[:Przedmiot][row]
    push!(data_in,[course, get(dict_plan, course, 0), get(dict_mass, course, 0) / 1000])
end
println(data_in)

course_no = size(data_in,1)
max_course_occurrences = maximum(data_in[:Sztuk])
days = 5
max_per_day = 8
min_per_day = 3


avg_mass = sum(data_in[:Sztuk].*data_in[:Waga]) / days + przybory_mass[1]

course_map = Dict(zip(1:course_no, data_in[:Przedmiot]))
mass_map = Dict(zip(1:course_no, data_in[:Waga]))


max_occurences_per_day  = 2
if max_occurences_per_day < max_course_occurrences
    max_course_occurrences = max_occurences_per_day
end



print("Masa przyborów: ")
println(przybory_mass[1])


