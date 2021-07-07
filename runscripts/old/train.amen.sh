#!/bin/bash
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="semitones"
MODEL="amen_16k" #must match directory name of pset
OUTDIR="2020.05.21_amen" #$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
CHECKPOINTDIR="output/2020.05.21_amen/model" #make sure different than OUTDIR otherwise will overwrite
CHECKPOINTSTEP="5000"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"

python3 train.py --hidden_size 64 --batch_size 128 --param_dir ../data/$MODEL \
--prop $PROP --cond_size 1 --gen_size 1 --output_dir $OUTDIR \
--data_dir ../data/$MODEL --num_steps 8000 --checkpoint 500 \
--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \
--tfr 0.9 

