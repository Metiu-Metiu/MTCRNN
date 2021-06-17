 #!/bin/bash

# The names of the parameters as they appear in paramManager metdata files
#  and in the order that they are stored in the control parameter file. 
PROP="dim0 dim1"


cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"

MODEL="oreilly.pinned.edges"   #altho the actual model name has the number of steps for the checkpoing appended

OUTDIR=$MODEL.20210519 # long run

DATADIR="/mydata"   #the directory where the model is stored.

# File storing an array of parameters for controlling the conditioning parameters of the model over time.
CPDIR="scratch/discretefourcorners_1000samps.npy"
echo "CPDIR is  $CPDIR"

# must be the same as you trained with
LAYERSIZE=300  

#These determine the length of sound you want to generate
let SR=16000
let SECS=40
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=1000/$SECS   #the original control parameter file was 1000 samples in 1 sec

mkdir -p output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"
echo "OUTDIR = $OUTDIR"


for STEP in 24000   #identifies the checkpoint of the saved model to use for generation
do

AUDIO_OUT="output/${OUTDIR}/audio/fourcorners40." 
AUDIO_OUT+=$STEP

echo "AUDIO_OUT = $AUDIO_OUT"

#IMORTANT: the parameters mus agree with those used to train the model!

	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size $LAYERSIZE --n_layers 4 --batch_size 1 --seq_len $SL --length $LEN --param_dir $DATADIR/$MODEL \
--data_dir $DATADIR/$MODEL --generate audio --prop $PROP --cond_size $cond_size --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out $AUDIO_OUT \
--rand_prime \
--save
	#play $AUDIO_OUT.wav
	echo "wrote audio file $AUDIO_OUT"

done

