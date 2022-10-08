#!/bin/bash
#SBATCH -J Log_GettingStartedPops
#SBATCH -p short
#SBATCH -N 1
#SBATCH --gres=gpu:1
#SBATCH --chdir=/homedtic/lwyse/working/MTCRNN.Fork
#SBATCH --mem=8g
#SBATCH --time=30:00
#SBATCH -o logs/%N.%J.out # STDOUT
#SBATCH -e logs/%N.%j.err # STDERR

module load CUDA
# interactive command: singularity exec lwyse_mtcrnn.sif bash
singularity exec lwyse_mtcrnn.sif  runscripts/quickstart.docker.pops.run_tg.sh  -t -d scratch -n 30 -c 10
#echo "writing stdout to " ${%N.%J.out}  " , stderr to " ${%N.%j.err}
echo "done"
