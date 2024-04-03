# get_GHGRP_data.jl
# 2/18/23 Amy Jordan

# replaces function of McMillan's get_GHGRP_data.py to produce csv files of the exact same format, in order to reuse the rest
# of his code. In the future this could become an all-Julia version of the entire code.

using CSV
using Downloads
using DataFrames
using DelimitedFiles

reporting_year=2021
table_dict = CSV.read("../calculation_data/table_dict.csv", DataFrame) # This file contains a crosswalk between EPA tables, subparts, and filenames
ghgrp=Dict()

for i=1:size(table_dict)[1]
    println(i)
    if table_dict[i,:Tables] != "subpartV_emis"         # Most cases
        if table_dict[i,:Tables] != "subpartV_fac"
            url=string("https://enviro.epa.gov/enviro/efservice/",table_dict[i,:Tablename],"/REPORTING_YEAR/",reporting_year,"/CSV")
        else
            url=string("https://enviro.epa.gov/enviro/efservice/",table_dict[i,:Tablename],"/YEAR/",reporting_year,"/CSV")
        end
    else # subpartV_emis requires >10K row specification, Had to write to EPA to get this file for 2021, reporting year is YEAR
        url=string("https://enviro.epa.gov/enviro/efservice/",table_dict[i,:Tablename],"/YEAR/",reporting_year,"/rows/0:40000/CSV")
    end
    epa_response = Downloads.download(url)
    gg=CSV.read(epa_response, DataFrame)
    nullcol=zeros(Int64,size(gg)[1]) #Colin's code requires the first column of the dataframe be pointless
    gg=hcat(nullcol,gg)
    gg=coalesce.(gg,"") # otherwise the dataframe has "missing" in all the blank entries

    ghgrp[i]=gg
    outfile=string("../calculation_data/ghgrp_data_amy2/",table_dict[i,:Filename],reporting_year,".csv")

#    This makes it match the format of Colin's files but I think it shouldn't repeat these entries
#    if i==11 # replace i=9,10,11 with full files (they are identical)
#        gg=vcat(ghgrp[9],ghgrp[10],ghgrp[11],cols=:union)
#        gg=coalesce.(gg,"") # otherwise the dataframe has "missing" in all the blank entries
#        writedlm(outfile, Iterators.flatten(([names(gg)], eachrow(gg))), ',') # writes only i=11, we want to overwrite 9, 10 too
#        for j=9:10
#            outfile=string("../calculation_data/ghgrp_data_amy/",table_dict[j,:Filename],reporting_year,".csv")
#            writedlm(outfile, Iterators.flatten(([names(gg)], eachrow(gg))), ',') # writes only i=11, we want to overwrite 9, 10 too
#        end
#    else
        writedlm(outfile, Iterators.flatten(([names(gg)], eachrow(gg))), ',')
#    end
end
