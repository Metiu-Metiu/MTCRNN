#!/bin/bash
# these scripts should be run from newMTCRNN and in the newsnn conda environment
HIDDENSIZE="64"
NLAYERS="6"

PROP="vibrate depth"
MODEL="vibratoPRD52" #must match directory name of pset
OUTDIR=$MODEL"_6.64_.$(date +%Y%m%d)_$HIDDENSIZE"
STEPS="15000"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"

python3 train.py --hidden_size $HIDDENSIZE --batch_size 128 --param_dir ../data/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir ../data/$MODEL --num_steps $STEPS --checkpoint 1000 \
--n_layers $NLAYERS \
--tfr 0.9 

