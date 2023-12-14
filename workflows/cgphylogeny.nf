include { FASTTREE                    } from '../modules/nf-core/fasttree/main'
include { GUBBINS                     } from '../modules/nf-core/gubbins/main'
include { SNIPPY_CORE                 } from '../modules/nf-core/snippy/core/main'
include { SNIPPY_RUN                  } from '../modules/nf-core/snippy/run/main'
include { SNIPPY_CLEAN                } from '../subworkflows/local/snippy'
include { SNP_SITES                   } from '../subworkflows/local/snippy'
include { GGTREE                    } from '../modules/local/ggtree'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/





workflow CGPHYLOGENY { 
    input_ch=Channel
    .fromPath(params.genome)
    .map{ meta=[id:it.getBaseName()]
    [meta, it] }

    ref_ch=file(params.reference)
    
    Run_results=SNIPPY_RUN(input_ch, ref_ch)

    Run_collect=Run_results.collect()
    Core_results=SNIPPY_CORE(Run_collect, ref_ch)
    Clean_res=SNIPPY_CLEAN(Core_results)
    Gub_results=GUBBINS(Clean_res)
    Sites_results=SNP_SITES(Gub_results)
    Tree_results=FASTTREE(Sites_results)
    script=Channel.fromPath("modules/local/script.r")
    GGTREE(Tree_results, script)
}

