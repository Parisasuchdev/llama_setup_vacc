#!/bin/bash
#SBATCH --partition=nvgpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=60G
#SBATCH --gres=gpu:1
#SBATCH --time=2:00:00
#SBATCH --job-name=retrieval
# Receive emails when job begins and ends or fails

source ~/.bash_profile

env_name=$1
conda activate llama_setup
module load gcc/13.3.0

echo "Hostname: $SLURM_NODELIST"

time jupyter notebook --no-browser --port=8900
