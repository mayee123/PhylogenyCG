process SNIPPY_CORE {
    //tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/snippy:4.6.0--hdfd78af_2':
        'biocontainers/snippy:4.6.0--hdfd78af_1' }"

    input:
    path input
    //tuple val(meta), path(vcf), path(aligned_fa)
    path reference

    output:
    path("${prefix}.full.aln"), emit: full_aln
    //path("core.full.aln")
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def is_compressed = reference.getName().endsWith(".gz") ? true : false
    def reference_name = reference.getName().replace(".gz", "")
    prefix = "core"
    """
    
    
 
    snippy-core \\
        $args \\
        --ref $reference \\
        --prefix $prefix \\
        $input
        
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        snippy-core: \$(echo \$(snippy-core --version 2>&1) | sed 's/snippy-core //')
    END_VERSIONS
    """
}
