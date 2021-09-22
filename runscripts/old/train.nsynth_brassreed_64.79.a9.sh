#!/bin/bash 
# these scripts should be run from newMTCRNN and in the newsnn conda environment

PROP="normPitch instID"  #pitch, instID  - must correspond to names in the param files
cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"
DATAPATH="/mydata" # Docker sets "/scratch/lonce" to mydata  
#DATAFOLDER="nsynth_TrumpetClarinet_pitch56_76"
DATAFOLDER="nsynth.64.76.dl_amp.9" #name of folder in DATAPATH where sounds and parameters are

NLAYERS=3
LAYERSIZE=256
SEQ_LEN=512
TFR=0.9
BATCHSIZE=128
OUTDIR=$(date +%Y.%m.%d)_${DATAFOLDER}"_NL${NLAYERS}.H${LAYERSIZE}.TFR.${TFR}.SL${SEQ_LEN}.BATCHSIZE${BATCHSIZE}"


#Copy this script to the output dir for posterity
mkdir -p output/$OUTDIR
cp "$0" output/$OUTDIR

NUMSTEPS=100000
CHKPOINT=10000

#################   For continuing from checkpoint
#CHECKPOINTDIR="output/$OUTDIR/model" #make sure different than OUTDIR otherwise will overwrite?
#CHECKPOINTSTEP="130000"

python3 train.py --hidden_size $LAYERSIZE --batch_size $BATCHSIZE --param_dir $DATAPATH/$DATAFOLDER \
--prop $PROP --cond_size $cond_size --n_layers $NLAYERS --seq_len $SEQ_LEN --gen_size 1 --output_dir $OUTDIR \
--data_dir $DATAPATH/$DATAFOLDER --num_steps $NUMSTEPS \
--tfr $TFR 

# --checkpoint $CHKPOINT 
# --model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP  #################   For continuing from checkpoint



