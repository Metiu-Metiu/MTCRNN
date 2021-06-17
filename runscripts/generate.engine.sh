 #!/bin/bash
PROP="revs"
MODEL="engine1_16k" #must match directory name of pset
OUTDIR="engine1_16k.20200527" #$MODEL".$(date +%Y%m%d)a" # created by train, "geigertier1"
CPDIR="scratch/cparams_gaussian.1secs.100sr.npy"

let SR=16000
let SECS=10
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=100/$SECS   #the original was 100 samples in 1 sec

mkdir output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

for STEP in 11000
do
	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size 64 --batch_size 1 --seq_len $SL --length $LEN --param_dir ../data/$MODEL \
--generate audio --prop $PROP --cond_size 1 --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out output/$OUTDIR/audio/test1_$STEP \
--data_dir ../data/$MODEL \
--rand_prime \
--save
done
