
#cd("Dropbox/PhD/JonAustin/Model")
using DelimitedFiles

# Include my functions.....
include("func_Gnp.jl")



#p = 0.1 # Probability of forming simplex
N = 100 # Number of nodes
m = 3 # simplex size
nvar_max = 100

filename=string("Outputs/jl_3simplex","_N",N,"_m",m,".txt")


# Fill simplices with probability p
# -------------

# Keep track of simplices


for nvar=1:nvar_max

    p = 1/(nvar*nvar)
    println("doing run\t",nvar,"\tout of \t",nvar_max)

    Triples = Dict()
    Pairs = Dict()


    for a=0:N-m 
        for b=a+1:N-(m-1)
            for c=b+1:N-(m-2)
                simplex = [a,b,c]
                random_float = rand(Float64)
                if (random_float<p)
                    Triples[simplex]=1
                    Pairs = fill_pairs(Pairs,simplex)
                end
            end
        end
    end

    # Evaluate prevalence of patterns
    # ------------- 
    results = Dict()
    for a=0:N-m 
        for b=a+1:N-(m-1)
            for c=b+1:N-(m-2)
                simplex = [a,b,c]
                results = find_pattern(Triples,Pairs,results,simplex)
                
            end
        end
    end

    results = normalize_results(results)
    results["p"] = p
    write_results(filename,results)
    #println(results)
end

