 #!/bin/bash
PROP="instID amplitude normPitch"
MODEL='nsynth.64.76.dl' # "RegularPopsRandomPitch_16k" # "ffx_geiger1_16k" #must match directory name of pset
OUTDIR='nsynth.64.76.dl.20200611' # "nsynth.64.76.dl.20200610" #"ffx_wind1_16k.20200609" #"RegularPopsRandomPitch_16k.20200605" #"RegularPops68_16k.20200605" #"PoissonGeiger68_16k.20200603" # $MODEL".$(date +%Y%m%d)_temp" # $MODEL".$(date +%Y%m%d)" # created by train, "geigertier1"

for inst in 0.0 1.0
do

# "scratch/cparams_gaussian.1secs.100sr.npy"
#CPDIR='scratch/cparams_CONST'$inst'_CONST0.8_Gaussian.3D.1secs.100sr.npy'
CPDIR='scratch/nsynthArpeggio_CONST'$inst'_CONST0.8_Arpeggio_1000samps.npy'

let SR=16000
let SECS=8
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=1000/$SECS   #the original was 100 samples in 1 sec

mkdir output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

echo "OUTDIR = $OUTDIR"

AUDIO_OUT="output/${OUTDIR}/audio/arpeggio.i${inst}_"

for STEP in 16000
do
AUDIO_OUT+=$STEP

echo "AUDIO_OUT = $AUDIO_OUT"

	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size 64 --batch_size 1 --seq_len $SL --length $LEN --param_dir ../data/$MODEL \
--data_dir ../data/$MODEL --generate audio --prop $PROP --cond_size 3 --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out $AUDIO_OUT \
--rand_prime \
--save
	play $AUDIO_OUT.wav

done


done