library(ggtree)
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)


tree <- read.tree(args)
ggtree(tree, branch.length = 'none') + geom_treescale() + xlim(0.0, 1.2) + geom_tiplab() + xlim(0,10)

