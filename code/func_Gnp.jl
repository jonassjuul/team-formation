function fill_pairs(D,simplex)
    for i=1:length(simplex)-1
        for j=i+1:length(simplex)
            D[[simplex[i],simplex[j]]]=1
        end
    end
	return D
end
function fill_triples(D,simplex)
    for i=1:length(simplex)-2
        for j=i+1:length(simplex)-1
            for k=j+1:length(simplex)
                D[[simplex[i],simplex[j],simplex[k]]]=1
            end
        end
    end
	return D
end
function fill_quadruples(D,simplex)
    for i=1:length(simplex)-3
        for j=i+1:length(simplex)-2
            for k=j+1:length(simplex)-1
                for l=k+1:length(simplex)
                    D[[simplex[i],simplex[j],simplex[k],simplex[l]]]=1
                end
            end
        end
    end
	return D
end

function pattern_from_name(name,m)
    pattern = string()
    for i=0:m-2
        if (haskey(name,m-i))
            if (pattern == string()) 
                pattern = string(pattern,m-i,"^",name[m-i])
            else 
                pattern = string(pattern,"-",m-i,"^",name[m-i])

            end
        end
    end
    if (pattern == string()) 
        pattern = '0'

    end

    return pattern
end

function find_pattern(Triples,Pairs,results,simplex)
    name = Dict()
    if (haskey(Triples,simplex)) 
        if (haskey(results,length(simplex))) 
            results[length(simplex)] +=1
        else 
            results[length(simplex)] = 1
        end

    else
        for i=1:length(simplex)-1
            for j=i+1:length(simplex)
                if (haskey(Pairs,[simplex[i],simplex[j]])) 
                    if (haskey(name,2)) 
                        name[2] +=1

                    else 
                        name[2] = 1
                    end
                end
            end
        end

        pattern = pattern_from_name(name,length(simplex))
        if (haskey(results,pattern))
            results[pattern] += 1
        else
            results[pattern] = 1
        end
    end

    return results

end

function find_pattern4(Quadruples,Triples,Pairs,results,simplex)
    name = Dict()
    TakenPairs = Dict()

    if (haskey(Quadruples,simplex)) 
        if (haskey(results,length(simplex))) 
            results[length(simplex)] +=1
        else 
            results[length(simplex)] = 1
        end

    else
        for i=1:length(simplex)-2
            for j=1:length(simplex)-1
                for k=1:length(simplex)
                    three_simplex = [simplex[i],simplex[j],simplex[k]]

                    if (haskey(Triples,three_simplex))
                        if (haskey(name,3)) 
                            name[3] +=1
    
                        else 
                            name[3] = 1
                        end   

                        for ii=1:length(three_simplex)-1
                            for jj=ii+1:length(three_simplex)
                                global TakenPairs[[three_simplex[ii],three_simplex[jj]]] = 1
                            end
                        end

                    end


                end
            end
        end


        for i=1:length(simplex)-1
            for j=i+1:length(simplex)
                if (haskey(Pairs,[simplex[i],simplex[j]]) && haskey(TakenPairs,[simplex[i],simplex[j]])==false) 
                    #println(haskey(TakenPairs,[simplex[i],simplex[j]]))
                    #println("Pair:",[simplex[i],simplex[j]])
                    #println("Dict:",TakenPairs)
                    if (haskey(name,2)) 
                        name[2] +=1

                    else 
                        name[2] = 1
                    end
                end
            end
        end

        pattern = pattern_from_name(name,length(simplex))
        if (haskey(results,pattern))
            results[pattern] += 1
        else
            results[pattern] = 1
        end
    end

    return results

end

function find_pattern5(Quintuples,Quadruples,Triples,Pairs,results,simplex)
    name = Dict()
    TakenPairs = Dict()
    TakenTriples = Dict()


    if (haskey(Quintuples,simplex)) 
        if (haskey(results,length(simplex))) 
            results[length(simplex)] +=1
        else 
            results[length(simplex)] = 1
        end

    else

        # Quintuples
        for i=1:length(simplex)-3
            for j=1:length(simplex)-2
                for k=1:length(simplex)-1
                    for l = 1:length(simplex)
                        four_simplex = [simplex[i],simplex[j],simplex[k],simplex[l]]

                        if (haskey(Quadruples,four_simplex))
                            if (haskey(name,4)) 
                                name[4] +=1
        
                            else 
                                name[4] = 1
                            end   

                            for ii=1:length(four_simplex)-2
                                for jj=ii+1:length(four_simplex)-1
                                    for kk = jj+1:length(four_simplex)
                                        global TakenTriples[[four_simplex[ii],four_simplex[jj],four_simplex[kk]]] = 1
                                        global TakenPairs[[four_simplex[ii],four_simplex[jj]]] = 1
                                        global TakenPairs[[four_simplex[ii],four_simplex[kk]]] = 1
                                        global TakenPairs[[four_simplex[jj],four_simplex[kk]]] = 1


                                    end
                                end
                            end

                        end
                    end


                end
            end
        end

        # Triples
        for i=1:length(simplex)-2
            for j=1:length(simplex)-1
                for k=1:length(simplex)
                    three_simplex = [simplex[i],simplex[j],simplex[k]]

                    if (haskey(Triples,three_simplex) && haskey(TakenTriples,[simplex[i],simplex[j],simplex[k]])==false)
                        if (haskey(name,3)) 
                            name[3] +=1
    
                        else 
                            name[3] = 1
                        end   

                        for ii=1:length(three_simplex)-1
                            for jj=ii+1:length(three_simplex)
                                global TakenPairs[[three_simplex[ii],three_simplex[jj]]] = 1
                            end
                        end

                    end


                end
            end
        end

        # Pairs
        for i=1:length(simplex)-1
            for j=i+1:length(simplex)
                if (haskey(Pairs,[simplex[i],simplex[j]]) && haskey(TakenPairs,[simplex[i],simplex[j]])==false) 
                    #println(haskey(TakenPairs,[simplex[i],simplex[j]]))
                    #println("Pair:",[simplex[i],simplex[j]])
                    #println("Dict:",TakenPairs)
                    if (haskey(name,2)) 
                        name[2] +=1

                    else 
                        name[2] = 1
                    end
                end
            end
        end

        pattern = pattern_from_name(name,length(simplex))
        if (haskey(results,pattern))
            results[pattern] += 1
        else
            results[pattern] = 1
        end
    end

    return results

end

function normalize_results(results)
    keylist = collect(keys(results))
    tot = 0
    for key in keylist
        tot += results[key]
    end

    for key in keylist
        results[key] /= tot
    end
    return results
end

function write_results(filename,results)
    keylist = collect(keys(results))

    nextline = string("\n")
    for key in keylist 
        if (nextline!=string("\n")) 
            nextline = string(nextline,",")
        end
        nextline=string(nextline,key,":",results[key])
    end
    open(filename, "a") do io
        write(io, nextline)
    end         

end

function archive_results(final_results,results,Nexp) 
    keylist = collect(keys(results))
    for key in keylist
        if (haskey(final_results,key)) 
            final_results[key]+= results[key]/Nexp
        
        else 
            final_results[key]= results[key]/Nexp+0
        end
    end

    return final_results

end