#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

HIDDENSIZE="300"
NLAYERS="6"
BATCHSIZE="32"

PROP="vibrate"
MODEL="vibR" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$NLAYERS.$HIDDENSIZE.$(date +%Y%m%d)"

#################   For continuing from checkpoint
#CHECKPOINTDIR="" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size $HIDDENSIZE --batch_size $BATCHSIZE --param_dir ../data/$MODEL \
--prop $PROP --cond_size 1 --gen_size 1 --output_dir $OUTDIR \
--data_dir ../data/$MODEL --num_steps 8000 --checkpoint 1000 \
--n_layers $NLAYERS \
--tfr 0.9 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \


