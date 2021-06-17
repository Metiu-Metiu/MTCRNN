#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

# train.2021-04-13_ChitraGanSynth_2x2TrumpetFlute.sh
PROP="instID pitch"
MODEL="2021-04-13_ChitraGanSynth_2x2TrumpetFlute" # directory of sounds/params in /mydata
OUTDIR=${MODEL}".$(date +%Y%m%d)"


#################   For continuing from checkpoint
#CHECKPOINTDIR="output/2021-01-28_pianobrass_sf16.tfr.4_.20210130/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="3000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 64 --batch_size 64 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 10000 --checkpoint 1000 \
--tfr 0.9 \
#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



