process SNIPPY_CLEAN {
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/snippy:4.6.0--hdfd78af_2':
        'biocontainers/snippy:4.6.0--hdfd78af_1' }"
        
    input:
    path(core)
    
    output:
    path("clean.full.aln")
    
    script:
    """
    snippy-clean_full_aln $core > clean.full.aln
    """
}

process SNP_SITES {
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/snippy:4.6.0--hdfd78af_2':
        'biocontainers/snippy:4.6.0--hdfd78af_1' }"

    input:
    path(sites)
    
    output:
    path("clean.core.aln")
    
    script:
    """
    snp-sites -c $sites > clean.core.aln
    """
}
