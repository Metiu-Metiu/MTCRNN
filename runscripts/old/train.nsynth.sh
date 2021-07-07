#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID amplitude normPitch"
MODEL="nsynth.64.76.dl" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/nsynth.64.76.dl.20200610/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 128 --batch_size 128 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 3 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 10000 --checkpoint 1000 \
--tfr 0.9 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



