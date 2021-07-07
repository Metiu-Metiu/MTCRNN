 #!/bin/bash
PROP="rate"
MODEL="PoissonModalBar1_16k" #must match directory name of pset
OUTDIR="PoissonModalBar1_16k.6layer.20200530"  # "PoissonModalBar1_16k.20200530" #$MODEL".$(date +%Y%m%d)a" # created by train, "geigertier1"
CPDIR="scratch/cparams_CONST1.1D.1secs.100sr.npy" #"scratch/cparams_gaussian.1secs.100sr.npy"

let SR=16000
let SECS=8
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=100/$SECS   #the original was 100 samples in 1 sec

mkdir output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

for STEP in 8000
do
	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size 32 \
--n_layers 6 \
--batch_size 1 --seq_len $SL --length $LEN --param_dir ../data/$MODEL \
--generate audio --prop $PROP --cond_size 1 --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out output/$OUTDIR/audio/test1.6layer.CONST1.RANDP_$STEP \
--data_dir ../data/$MODEL \
--rand_prime \
--save
done

# --rand_prime \