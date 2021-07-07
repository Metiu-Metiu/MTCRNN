#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="rate"
MODEL="RegularPopsRandomPitch_16k" # "PoissonGeiger68fast_16k" #"PoissonModalBar1fast_16k" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/............/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"

echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 300 --batch_size 64 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 1 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 6000 --checkpoint 1000 \
--tfr 0.9 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \

