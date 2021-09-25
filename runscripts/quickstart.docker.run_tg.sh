#!/bin/bash
# This script is for generating audio from the RNN using on a directory of  "Control Parameter" files
# This script will be copied and saved in both training and audio generation directories

if [ $# -eq 0 ]
  then
    echo "usage: run_tg [-g -t] for generate and/or train"
    exit -1
fi

GENERATING=0   # set to true with -g flag
TRAINING=0     # set to true with -t flag

while getopts “::gt” opt; do
  case $opt in
    g) 
		GENERATING=1 
		;;
	t) 
		TRAINING=1  
		;;
  esac
done
echo "GENERATING = $GENERATING, TRAINING=$TRAINING"

##################################################################################################
######   COMMON PARAMS  (training and generating)  ########
##################################################################################################
PROP="hitratio wmratio rate_exp"  #pitch, instID  - must correspond to names in the param files in the DATAFOLDER
cond_size=`echo $PROP | wc -w`
echo "cond_size is $cond_size"
DATAPATH="/mydata"     # parent of DATAFOLDER
DATAFOLDER="tokwotal_dataset" #name of folder in DATAPATH where sounds and parameters are

NLAYERS=4
LAYERSIZE=256
SEQ_LEN=512
TFR=0.9
BATCHSIZE=128

NUMSTEPS=40000
CHKPOINT=10000

# MODELDIR:  The ORIGINAL training MODELDIR date
	# -  set manually if running from checkpoint or generating without training 
DATESTAMP=`date +%Y.%m.%d`   # 2021.09.21 
MODELDIR=${DATESTAMP}_${DATAFOLDER}"_NL${NLAYERS}.H${LAYERSIZE}.TFR.${TFR}.SL${SEQ_LEN}.BATCHSIZE${BATCHSIZE}"


##################################################################################################
######   TRAIN  ########
##################################################################################################
if [ $TRAINING  -eq 1  ]
then
	#Copy this script to the output dir for posterity
	mkdir -p output/$MODELDIR
	cp "$0" output/$MODELDIR

	#################   For continuing from checkpoint
	#CHECKPOINTDIR="output/$MODELDIR/model" #make sure different than MODELDIR otherwise will overwrite?
	#CHECKPOINTSTEP="130000"

	python3 train.py --hidden_size $LAYERSIZE --batch_size $BATCHSIZE --param_dir $DATAPATH/$DATAFOLDER \
	--prop $PROP --cond_size $cond_size --n_layers $NLAYERS --seq_len $SEQ_LEN --gen_size 1 --output_dir $MODELDIR \
	--data_dir $DATAPATH/$DATAFOLDER --num_steps $NUMSTEPS \
	--tfr $TFR 

	# --checkpoint $CHKPOINT 
	# --model_dir $CHECKPOINTDIR --step $CHECKPOINTSTEP  #################   For continuing from checkpoint

fi


##################################################################################################
######    GENERATE    ########
##################################################################################################

if [ $GENERATING -eq 1 ]
then

	#--------------------------------------------------------------------------------------------------------
	# Now the generator-specific parameters

	DESCRIPTION="QuickStart"

	let SR=16000             #output sample rate
	let SECS=4    	    		 #duration of output in seconds
	let LEN=$SECS*$SR        #duration of output in samples
	let OUTSEQ_LEN=$LEN+1    #duration of output in samples (including the seed)

	#GENSTEPS must be in the collection of checkpointed models (that include the number in their filenames).
	GENSTEPS="10000 20000 30000 40000" 

	# the reference
	let ESR=1000/$SECS       #the sample rate of the parameter array (original was 1000 samples in 1 sec)

	echo "LEN = $LEN"
	echo "OUTSEQ_LEN = $OUTSEQ_LEN"
	echo "ESR= $ESR"
	echo "MODELDIR = $MODELDIR"


	#--------------------------------------------------------------------------------------------------------
	echo  "will look for model here: $MODELDIR"
	mkdir -p output/$MODELDIR/${DESCRIPTION}_$(date +%Y.%m.%d)/audio
	GEN_OUT=output/$MODELDIR/${DESCRIPTION}_$(date +%Y.%m.%d)
	cp "$0" $GEN_OUT  # copy this script output directory for posterity


	# directory of parameter files for this run (npy files, see notebooks in genParams)
	for FILE in genParams/run/${DESCRIPTION}/* 
	do 
		# An npy file with a (cond_size * sample points) array of parameter values to use for synthesis
		CPDIR=$FILE
		echo "CPDIR is  $CPDIR"

		for STEP in $GENSTEPS 
		do
			fname="$(basename -- $CPDIR .npy)"

			AUDIO_OUT="$GEN_OUT/audio/${fname}" 
			AUDIO_OUT+=$STEP

			echo "AUDIO_OUT = $AUDIO_OUT"

				echo "call python generate with step $STEP"
				python3 generate.py --hidden_size $LAYERSIZE --n_layers $NLAYERS --batch_size 1 --seq_len $OUTSEQ_LEN --length $LEN --param_dir $DATAPATH/$DATAFOLDER \
			--data_dir $DATAPATH/$DATAFOLDER --generate audio --prop $PROP --cond_size $cond_size --gen_size 1 --model_dir output/$MODELDIR/model \
			--step $STEP --paramvect external --sample_rate $SR --external_array $CPDIR \
			--external_sr $ESR --out $AUDIO_OUT \
			--save

			# --rand_prime \ 
				#play $AUDIO_OUT.wav
				echo "wrote audio file ${AUDIO_OUT}.wav"

		done
	done


fi