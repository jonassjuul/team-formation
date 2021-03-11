
#cd("Dropbox/PhD/JonAustin/Model")
using DelimitedFiles

# Include my functions.....
include("func_Gnp.jl")



#p = 0.1 # Probability of forming simplex
N = 50 # Number of nodes
m = 4 # simplex size
nvar_max = 1000
Nexp = 5

filename=string("Outputs/jl_4simplex","_N",N,"_m",m,"_Nexp",Nexp,".txt")


# Fill simplices with probability p
# -------------

# Keep track of simplices


for nvar=1:nvar_max

    p = 1/(nvar*nvar)
    final_results = Dict()

    println("doing run\t",nvar,"\tout of \t",nvar_max)
    for exp=1:Nexp
        Quadruples = Dict()
        Triples = Dict()
        Pairs = Dict()


        for a=0:N-m 
            for b=a+1:N-(m-1)
                for c=b+1:N-(m-2)
                    for d=c+1:N-(m-3)
                        simplex = [a,b,c,d]
                        random_float = rand(Float64)
                        if (random_float<p)
                            Quadruples[simplex]=1
                            Triples = fill_triples(Triples,simplex)
                            Pairs = fill_pairs(Pairs,simplex)
                        end
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
                    for d=c+1:N-(m-3)
                        simplex = [a,b,c,d]
                        results = find_pattern4(Quadruples,Triples,Pairs,results,simplex)
                    end
                end
            end
        end

        results = normalize_results(results)
        results["p"] = p
        final_results = archive_results(final_results,results,Nexp)
    end
    write_results(filename,final_results)
    #println(results)
end

