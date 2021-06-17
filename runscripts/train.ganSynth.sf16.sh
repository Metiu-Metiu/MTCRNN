#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID envPt pitch"
MODEL="2021-01-28_pianobrass_sf16" #"2021-01-24_pianobrass" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"


#################   For continuing from checkpoint
#CHECKPOINTDIR="output/nsynth.64.76.dl.20200610/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 400 --batch_size 64 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 3 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 10000 --checkpoint 1000 \
--tfr 0.75 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



