 #!/bin/bash
PROP="dim0 dim1"

cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"

#MODEL="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate"
#OUTDIR="2021-02-06_normed_brass.flute_endpoints.20vars.steadystate_steadystate_.20210206"

# the name of a directory in /mydata where the original sound and paramrs were stored
MODEL="2021.04.26_nsynthsubset_edgepinned"

############# short and small
       #OUTDIR=$MODEL.20210330 # short run
       #LAYERSIZE=128
#OUTDIR=$MODEL.20210426 # long run
OUTDIR=${MODEL}H256.FTR.99.SL256.20210428  #tf .99, 120000 iteration
#OUTDIR=${MODEL}H256.FTR.9.SL256.20210427   #tf .9, 100000 iteration



#LAYERSIZE=64
LAYERSIZE=256

DATADIR="/scratch/lonce"
DATADIR="/mydata"

#for c in  "c1" "c2" "c3" "c4" #
#do

#echo "inst = $inst"
for FILE in scratch/rnnparams/* 
do 

CPDIR=$FILE 

echo "CPDIR is  $CPDIR"

let SR=16000
let SECS=1
let LEN=$SECS*$SR
let SL=$LEN+1
# the reference
let ESR=1/$SECS   #the original was 1000 samples in 1 sec

mkdir -p output/$OUTDIR/RNNData

echo "LEN = $LEN"
echo "SL = $SL"
echo "ESR= $ESR"

echo "OUTDIR = $OUTDIR"


for STEP in 120000
do

fname="$(basename -- $CPDIR .npy)"

AUDIO_OUT="output/$OUTDIR/RNNData/${fname}" #${c}."
AUDIO_OUT+=".wav"

	echo "call python generate with step $STEP"
	python3 generate.py --hidden_size $LAYERSIZE --n_layers 4 --batch_size 1 --seq_len $SL --length $LEN --param_dir $DATADIR/$MODEL \
--data_dir $DATADIR/$MODEL --generate audio --prop $PROP --cond_size $cond_size --gen_size 1 --model_dir output/$OUTDIR/model \
--step $STEP --paramvect external --sample_rate 16000 --external_array $CPDIR \
--external_sr $ESR --out $AUDIO_OUT \
--rand_prime \
--save
	#play $AUDIO_OUT.wav
	echo "wrote audio file $AUDIO_OUT"




echo "AUDIO_OUT = $AUDIO_OUT"
done
done