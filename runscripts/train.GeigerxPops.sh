#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID rate"
MODEL="GeigerxPops" # "PoissonGeiger68fast_16k" #"PoissonModalBar1fast_16k" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/............/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 64 --batch_size 128 --param_dir ../data/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir ../data/$MODEL --num_steps 12000 --checkpoint 1000 \
--tfr 0.9 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \

