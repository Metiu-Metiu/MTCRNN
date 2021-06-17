#!/bin/bash
# TRYING (WRONGLY) TO GENERATE (TRAIN) A PARAMETER INSTEAD OF AUDIO

PROP="revs"
MODEL="engine1_16k" #must match directory name of pset
OUTDIR=$MODEL".param.$(date +%Y%m%d)"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"

#--prop $PROP \
python3 train.py --hidden_size 64 --batch_size 128 --param_dir ../data/$MODEL \
--generate $PROP \
--cond_size 0 \
--gen_size 1 \
--sample_rate 16000 \
--output_dir $OUTDIR \
--data_dir ../data/$MODEL \
--num_steps 5000 --checkpoint 1000 \
--tfr 0.9 


