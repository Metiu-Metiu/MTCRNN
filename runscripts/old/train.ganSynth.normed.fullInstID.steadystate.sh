#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID pitch"
MODEL="2021-02-06_normed_brass.flute_fullInstID.20vars.steadystate" #"2021-01-24_pianobrass" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=${MODEL}".20210206" # $(date +%Y%m%d)#


#################   For continuing from checkpoint
CHECKPOINTDIR="output/2021-02-06_normed_brass.flute_fullInstID.20vars.steadystate.20210206/model" #make sure different than OUTDIR otherwise will overwrite
CHECKPOINTSTEP="9000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 400 --batch_size 64 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 20000 --checkpoint 1000 \
--tfr 0.9 \
--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



