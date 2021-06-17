#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID pitch"
MODEL="ChitraGanNsynth" # directory of sounds/params in /mydata
OUTDIR=${MODEL}".$(date +%Y%m%d)"


#################   For continuing from checkpoint
#CHECKPOINTDIR="output/2021-01-28_pianobrass_sf16.tfr.4_.20210130/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="3000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 300 --batch_size 128 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 25000 --checkpoint 2000 \
--tfr 0.9 \
#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



