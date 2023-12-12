process GGTREE {
    container = 'https://depot.galaxyproject.org/singularity/bioconductor-ggtree%3A3.8.0--r43hdfd78af_0'
        
    input:
    path(in_tree)
    path(script)
    
    output:
    path("*.pdf")
    
    script:
    """
    Rscript $script $in_tree
    """
}
