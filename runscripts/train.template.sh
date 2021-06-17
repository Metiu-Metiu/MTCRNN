#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="dim0 dim1"  #corresponds to parameter names in paramManager file
MODEL="oreilly_31x31" #"PoissonModalBar1_16k" #must match directory name of pset
OUTDIR=$MODEL".$(date +%Y%m%d)"

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/nsynth.64.76.dl.20200610/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="8000"


echo "PROP is $PROP , MODEL is $MODEL, and OUTDIR is $OUTDIR"


python3 train.py --hidden_size 300 --batch_size 128 --param_dir /mydata/$MODEL \
--prop $PROP --cond_size 2 --gen_size 1 --output_dir $OUTDIR \
--data_dir /mydata/$MODEL --num_steps 25000 --checkpoint 2000 \
--tfr 0.9 

#--model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \



