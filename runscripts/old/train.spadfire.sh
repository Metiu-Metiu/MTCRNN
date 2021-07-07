#!/bin/bash
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="rate"
MODEL="spadfire1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
CHECKPOINTDIR="output/2020.05.21_spadfire1/model" #make sure different than OUTDIR otherwise will overwrite
CHECKPOINTSTEP="5000"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"

python3 train.py --hidden_size 400 --batch_size 64 --param_dir ../data/$MODEL \
--prop $PROP --cond_size 1 --gen_size 1 --output_dir $OUTDIR \
--data_dir ../data/$MODEL --num_steps 5000 --checkpoint 1000 \
--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \
--tfr 0.9 

