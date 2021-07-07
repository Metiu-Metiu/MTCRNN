 #!/bin/bash
PROP="instID pitch"

cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"

#MODEL="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate"
#OUTDIR="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate_steadystate_.20210206"

MODEL="2021-02-06_normed_brass.flute_fullInstID.20vars.steadystate"
OUTDIR="2021-02-06_normed_brass.flute_fullInstID.20vars.steadystate.20210206"


DATADIR="/scratch/lonce"

for inst in  0 1 SWEEP #
do

echo "inst = $inst"
# param array file (these are all 3D: (instID, envPts, pitch ))
#CPDIR='scratch/GANsynthArpeggio_basic_1000samps.npy'
#CPDIR='scratch/GANsynthArpeggio_i0_1000samps.npy'
#CPDIR="scratch/GANsynthArpeggio_i${inst}_1000samps.npy"
#CPDIR='scratch/GANsynthArpeggio_i1_env.3_1000samps.npy'

# param array file (these are all 2D: (instID,pitch ))
CPDIR="scratch/GANsynthArpeggio.instID.pitch_i${inst}_1000samps.npy"
#CPDIR="scratch/GANsynthArpeggio.instID.pitch_instSWEEP_1000samps.npy"


let SR=16000
let SECS=8
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=1000/$SECS   #the original was 1000 samples in 1 sec

mkdir -p output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

echo "OUTDIR = $OUTDIR"


for STEP in 29000 #10000
do

AUDIO_OUT="output/${OUTDIR}/audio/arpeggio_${inst}." #.i${inst}_"

AUDIO_OUT+=$STEP

echo "AUDIO_OUT = $AUDIO_OUT"

	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size 400 --batch_size 1 --seq_len $SL --length $LEN --param_dir $DATADIR/$MODEL \
--data_dir $DATADIR/$MODEL --generate audio --prop $PROP --cond_size $cond_size --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out $AUDIO_OUT \
--rand_prime \
--save
	play $AUDIO_OUT.wav

done


done