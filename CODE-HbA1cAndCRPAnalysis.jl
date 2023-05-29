using Pkg

Pkg.add("IJulia")
Pkg.add("DataFrames")
Pkg.add("Gadfly")
Pkg.add("StatsBase")
Pkg.add("Distributions")
Pkg.add("CSV")

using IJulia
using DataFrames
using Gadfly
using StatsBase
using Distributions
using CSV

df = DataFrame(CSV.File("Raw_data.csv"))

#Making sure there are no NA-values and looking at the data types
describe(df)

#Changing the values of Cat1
# A was Minor infections
# B was Major infections
nrows, ncols = size(df)
for r in 1:nrows # Loop through all the rows
    infection_var = df[r, :Cat1] # variable creation
    if ismissing(infection_var)
        elseif infection_var == "A"
        df[!,:Cat1] = convert.(String31,df[!,:Cat1])
        df[r, :Cat1] = "Minor infection"
        elseif infection_var == "B"
        df[!,:Cat1] = convert.(String31,df[!,:Cat1])
        df[r, :Cat1] = "Major infection"
    else
    end
end

#Changing the values of Cat2
for r in 1:nrows
    gender_var = df[r, :Cat2]
    if ismissing(gender_var)
        elseif gender_var == "C" || gender_var == "X" || gender_var == "R" # OR
        df[!,:Cat2] = convert.(String15,df[!,:Cat2])
        df[r, :Cat2] = "Female"
        elseif gender_var == "L" || gender_var == "B" || gender_var == "F"
        df[!,:Cat2] = convert.(String15,df[!,:Cat2])
        df[r, :Cat2] = "Male"
    else
    end
end

#Changing the values of Var1
const fractional_digits = 0
for r in 1:nrows
    age_var = df[r, :Var1]
    if ismissing(age_var)
    else
        df[!,:Var1] = floor.(df[:,:Var1], digits=fractional_digits)
    end
end

# Renaming the columns
rename!(df, [:Cat1, :Cat2, :Var1, :Var2, :Var3] .=> [:Infection, :Gender, :Age, :HbA1c, :CRP])
first(df)

#Count of number per group of infection
inf_groups = combine(groupby(df, :Infection), d -> DataFrame(Number = size(d,1)))

#Count of number per group of gender
gender_groups = combine(groupby(df, :Gender), d -> DataFrame(Number = size(d,1)))

floor.(Int, mean(df.Age))

describe(df.HbA1c)

describe(df.CRP)

#Using the Gadfly package
plot(df, x = "Infection", y = "Age", Geom.boxplot, Guide.title("Age analysis by type of infection"), Guide.xlabel("Type of infection"), Guide.ylabel("Age"))

plot(df, x = "Gender", y = "Age", Geom.boxplot, Guide.title("Age analysis by gender"), Guide.xlabel("Gender"), Guide.ylabel("Age"), Theme(default_color=colorant"red"))

plot(df, x = "Age", color = "Infection", Geom.density, Guide.title("Age distribution by type of infection"), Guide.xlabel("Age"), Guide.ylabel("Distribution"))

plot(df, x = "Age", color = "Gender", Geom.density, Guide.title("Age distribution by gender"), Guide.xlabel("Age"), Guide.ylabel("Distribution"))

plot(df, x = "Infection", y = "HbA1c", Geom.boxplot, Guide.title("HbA1c analysis by type of infection"), Guide.xlabel("Type of infection"), Guide.ylabel("HbA1c"))

plot(df, x = "HbA1c", color = "Infection", Geom.density, Guide.title("HbA1c distribution by type of infection"), Guide.xlabel("HbA1c"), Guide.ylabel("Distribution"))

plot(df, x = "Gender", y = "HbA1c", Geom.boxplot, Guide.title("HbA1c analysis by gender"), Guide.xlabel("Gender"), Guide.ylabel("HbA1c"), Theme(default_color = colorant"orange"))

plot(df, x = "Infection", y = "CRP", Geom.boxplot, Guide.title("CRP analysis by type of infection"), Guide.xlabel("Type of infection"), Guide.ylabel("CRP"))

plot(df, x = "Gender", y = "CRP", Geom.boxplot, Guide.title("CRP analysis by gender"), Guide.xlabel("Gender"), Guide.ylabel("CRP"), Theme(default_color = colorant"green"))
