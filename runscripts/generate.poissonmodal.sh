 #!/bin/bash
PROP="rate"
MODEL="PoissonModalBar1fast_16k" #must match directory name of pset
OUTDIR="PoissonModalBar1fast_16k.20200603" #"/PoissonModalBar1_16k.noise0.1.20200601" # "PoissonModalBar1_16k.20200530" #$MODEL".$(date +%Y%m%d)a" # created by train, "geigertier1"
for p in 0.1 0.4 0.7 1.0 
do

# "scratch/cparams_gaussian.1secs.100sr.npy"
CPDIR='scratch/cparams_CONST'$p'.1D.1secs.100sr.npy' 
let SR=16000
let SECS=4
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=100/$SECS   #the original was 100 samples in 1 sec

mkdir output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

for STEP in 2000 4000 6000 8000
do
	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size 64 --batch_size 1 --seq_len $SL --length $LEN --param_dir ../data/$MODEL \
--generate audio --prop $PROP --cond_size 1 --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out output/$OUTDIR/audio/test.p_$p._$STEP \
--data_dir ../data/$MODEL \
--save 
	play output/$OUTDIR/audio/test.p_$p._$STEP.wav
done

done
# --rand_prime \
#--temp 1 \


