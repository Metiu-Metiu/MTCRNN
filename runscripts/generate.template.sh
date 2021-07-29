 #!/bin/bash
#--------------------------------------------------------------------------------------------------------
#  First, the params from the training

PROP="dim0 dim1"  #pitch, instID  - must correspond to names in the param files
cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"
DATAPATH="/mydata" # Docker sets "/scratch/lonce" to mydata  
DATAFOLDER="nsynth_Trumpinet_pitch56.76" #name of folder in DATAPATH where sounds and parameters are

NLAYERS=4
LAYERSIZE=256
SEQ_LEN=512  
TFR=0.9

#This is where generate will look for the /model folder as well as the root for audio output
# note hard-coded date to match the model folder name.
OUTDIR=2021.07.03_${DATAFOLDER}"_NL${NLAYERS}.H${LAYERSIZE}.TFR.${TFR}.SL${SEQ_LEN}"

#Copy this script to the output dir for posterity
mkdir -p output/$OUTDIR
cp "$0" output/$OUTDIR
#--------------------------------------------------------------------------------------------------------
# Now the generator-specific parameters

# An npy file with a cond_size array of parameter values to use for synthesis
CPDIR='scratch/rhapsody2_extended_1000samps.npy'
echo "CPDIR is  $CPDIR"

let SR=16000             #output sample rate
let SECS=10    	    #duration of output in seconds
let LEN=$SECS*$SR        #duration of output in samples
let OUTSEQ_LEN=$LEN+1       #duration of output in samples (including the seed)

# the reference
let ESR=1000/$SECS       #the sample rate of the parameter array (original was 1000 samples in 1 sec)

mkdir -p output/$OUTDIR/audio

echo "LEN = $LEN"
echo "OUTSEQ_LEN = $OUTSEQ_LEN"
echo "ESR= $ESR"

echo "OUTDIR = $OUTDIR"


for STEP in 130000
do


AUDIO_OUT="output/${OUTDIR}/audio/$(date +%Y.%m.%d)_rhapsody_extended_pitch.$STEP." #${c}."
AUDIO_OUT+=$STEP

echo "AUDIO_OUT = $AUDIO_OUT"

	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size $LAYERSIZE --n_layers $NLAYERS --batch_size 1 --seq_len $OUTSEQ_LEN --length $LEN --param_dir $DATAPATH/$DATAFOLDER \
--data_dir $DATAPATH/$DATAFOLDER --generate audio --prop $PROP --cond_size $cond_size --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate $SR --external_array $CPDIR \
--external_sr $ESR --out $AUDIO_OUT \
--rand_prime \
--save
	#play $AUDIO_OUT.wav
	echo "wrote audio file ${AUDIO_OUT}.wav"

done
