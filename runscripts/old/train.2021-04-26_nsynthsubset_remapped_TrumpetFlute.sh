#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

# train.2021-04-13_ChitraGanSynth_2x2TrumpetFlute.sh
PROP="dim0 dim1"  #pitch, instID
MODEL="2021.04.26_nsynthsubset_edgepinned" # directory of sounds/params in /mydata
OUTDIR=${MODEL}"H256.FTR.99.SL256.$(date +%Y%m%d)"


#################   For continuing from checkpoint
CHECKPOINTDIR="output/2021.04.26_nsynthsubset_edgepinnedH256.FTR.99.SL256.20210426/model" #make sure different than OUTDIR otherwise will overwrite
CHECKPOINTSTEP="60000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 256 --batch_size 128 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 2 --n_layers 4 --seq_len 256 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 60000 --checkpoint 10000 \
--tfr 0.99 \
--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



