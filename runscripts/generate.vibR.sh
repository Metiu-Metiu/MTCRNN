 #!/bin/bash
PROP="vibrate depth"
MODEL="vibratoPRD52" #must match directory name of pset
#OUTDIR=vibR.4.128.20201112 #$MODEL".20200526_128" # $MODEL".$(date +%Y%m%d)_temp"
OUTDIR=vibR.6.300.20201114
HIDDENSIZE="300"
NLAYERS="6"


MParam="1.0"


#OUTDIR=2020.05.21_amen
#CPDIR='scratch/cparams_2DgaussD'$MParam'.1secs.100sr.npy'
#CPDIR='scratch/cparams_2DconstD'$MParam'.1secs.100sr.npy'

CPDIR='scratch/cparams_CONST'$MParam'.1D.1secs.100sr.npy'
#CPDIR='scratch/cparams_step13.1secs.100sr.npy'

let SR=16000
let SECS=3
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=100/$SECS   #the original was 100 samples in 1 sec

mkdir output/$OUTDIR/audio

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"


for STEP in 8000 # 5000
do
	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size $HIDDENSIZE  --batch_size 1 --seq_len $SL --length $LEN --param_dir ../data/$MODEL \
--generate audio --prop $PROP --cond_size 1 --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out "output/$OUTDIR/audio/test.const."$MParam"_"$STEP \
--data_dir ../data/$MODEL \
--n_layers $NLAYERS \
--rand_prime \
--save
done