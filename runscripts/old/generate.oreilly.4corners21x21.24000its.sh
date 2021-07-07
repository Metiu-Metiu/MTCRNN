 #!/bin/bash
PROP="dim0 dim1"

cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"

#MODEL="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate"
#OUTDIR="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate_steadystate_.20210206"

MODEL="oreilly.pinned.edges"

############# short and small
       #OUTDIR=$MODEL.20210330 # short run
       #LAYERSIZE=128
OUTDIR=$MODEL.20210519 # long run
LAYERSIZE=300

#DATADIR="/scratch/lonce"
DATADIR="/mydata"

#for c in  "c1" "c2" "c3" "c4" #
#do

#echo "inst = $inst"

# param array file (these are all 3D: (instID, envPts, pitch ))
#CPDIR='scratch/GANsynthArpeggio_basic_1000samps.npy'
#CPDIR='scratch/GANsynthArpeggio_i0_1000samps.npy'
#CPDIR="scratch/GANsynthArpeggio_i${inst}_1000samps.npy"
#CPDIR='scratch/GANsynthArpeggio_i1_env.3_1000samps.npy'

# param array file (these are all 2D: (instID,pitch ))
#CPDIR="scratch/GANsynthArpeggio.instID.pitch_i${inst}_1000samps.npy"
#CPDIR="scratch/GANsynthArpeggio.instID.pitch_instSWEEP_1000samps.npy"

CPDIR="scratch/discretefourcorners_1000samps.npy"
#CPDIR='scratch/linVsin_1000samps.npy'
#CPDIR="scratch/glidefourcorners_1000samps.npy"

#CPDIR="scratch/fourcorners_${c}_1000samps.npy"

echo "CPDIR is  $CPDIR"

let SR=16000
let SECS=40
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=1000/$SECS   #the original was 1000 samples in 1 sec

mkdir -p output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

echo "OUTDIR = $OUTDIR"


for STEP in 24000
do

AUDIO_OUT="output/${OUTDIR}/audio/fourcorners40." #${c}."
AUDIO_OUT+=$STEP

echo "AUDIO_OUT = $AUDIO_OUT"

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


#done