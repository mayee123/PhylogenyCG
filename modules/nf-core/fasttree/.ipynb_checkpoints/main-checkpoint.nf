process FASTTREE {
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fasttree:2.1.10--h516909a_4' :
        'biocontainers/fasttree:2.1.10--h516909a_4' }"

    input:
    path alignment

    output:
    path "clean.core.tree",         emit: phylogeny

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    fasttree \\
        -gtr \\
        -nt $alignment \\
        > clean.core.tree

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fasttree: \$(fasttree -help 2>&1 | head -1  | sed 's/^FastTree \\([0-9\\.]*\\) .*\$/\\1/')
    END_VERSIONS
    """
}
