#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="instID amplitude normPitch"  #pitch, instID  - must correspond to names in the param files
cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"
DATAPATH="/mydata" # Docker sets "/scratch/lonce" to mydata  
#DATAFOLDER="nsynth_Trumpinet_pitch56.76" #name of folder in DATAPATH where sounds and parameters are
DATAFOLDER="nsynth.64.76.dl"

NLAYERS=4
LAYERSIZE=256
SEQ_LEN=512
TFR=0.9
OUTDIR=$(date +%Y.%m.%d)_${DATAFOLDER}"_NL${NLAYERS}.H${LAYERSIZE}.TFR.${TFR}.SL${SEQ_LEN}_test2"

#Copy this script to the output dir for posterity
mkdir -p output/$OUTDIR
cp "$0" output/$OUTDIR


NUMSTEPS=100000
CHKPOINT=10000

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/2021.04.26_nsynthsubset_edgepinnedH256.FTR.99.SL256.20210426/model" #make sure different than OUTDIR otherwise will overwrite
#CHECKPOINTSTEP="60000"

python3 train.py --hidden_size $LAYERSIZE --batch_size 128 --param_dir $DATAPATH/$DATAFOLDER \
--prop $PROP --cond_size $cond_size --n_layers $NLAYERS --seq_len $SEQ_LEN --gen_size 1 --output_dir $OUTDIR \
--data_dir $DATAPATH/$DATAFOLDER --num_steps $NUMSTEPS --checkpoint $CHKPOINT \
--tfr $TFR \
# --model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP \ #################   For continuing from checkpoint

