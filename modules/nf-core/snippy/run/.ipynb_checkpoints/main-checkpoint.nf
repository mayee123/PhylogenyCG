process SNIPPY_RUN {
    tag "$meta.id"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/snippy:4.6.0--hdfd78af_2' :
        'biocontainers/snippy:4.6.0--hdfd78af_2' }"
    
    input:
    tuple val(meta), path(reads)
    path reference

    output:
    //tuple val(meta), path("${prefix}/${prefix}.vcf"), path("${prefix}/${prefix}.aligned.fa") 
    path("${prefix}")
    //path("${prefix}/${prefix}.aligned.fa")                        , emit: aligned_fa
    //path("${prefix}/${prefix}.vcf")                               , emit: vcf


    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"

    """
    
    snippy \\
        $args \\
        --cpus $task.cpus \\
        --outdir $prefix \\
        --reference $reference \\
        --prefix $prefix \\
        --ctgs $reads \\
        --force

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        snippy: \$(echo \$(snippy --version 2>&1) | sed 's/snippy //')
    END_VERSIONS
    """
}
