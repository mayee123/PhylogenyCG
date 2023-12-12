process GUBBINS {
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gubbins:3.0.0--py39h5bf99c6_0' :
        'biocontainers/gubbins:3.0.0--py39h5bf99c6_0' }"

    input:
    path alignment

    output:
    path "*.fasta"                          , emit: fasta

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    run_gubbins.py \\
        --threads $task.cpus \\
        -f 40 \\
        $alignment
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gubbins: \$(run_gubbins.py --version 2>&1)
    END_VERSIONS
    """
}
