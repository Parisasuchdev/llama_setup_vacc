#!/bin/bash
#SBATCH --partition=nvgpu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --gres=gpu:1
#SBATCH --time=2:00:00
#SBATCH --job-name=ollama
#SBATCH --mail-type=BEGIN,END,FAIL
# You may choose from BEGIN, END, FAIL to receive mail, or NONE to skip mail entirely.
#SBATCH --mail-user=yourNetID@uvm.edu

module purge
module load apptainer ollama

# Print a hostname for your starter script
echo "Hostname: $(hostname -s)"

# create a file to receive the url to use
runfile=$(mktemp ollama-serve-XXXXXX)

# start the ollama server and record the URL to use
ollama-serve $runfile &

# wait for server to start
sleep 5

# read the URL from the file
ollama_host=$(cat $runfile)
echo "ollama_host is $ollama_host"

# Try to pull model (skip if certificate issues)
export OLLAMA_INSECURE=true
if ollama-request pull llama3.2 2>/dev/null; then
    echo "Pulled model llama3.2"
else
    echo "Model pull failed (likely certificate/network issue), using existing models"
fi

echo "Ollama server running at $ollama_host"
echo "Server will run until job time limit (2 hours)"

# Keep the server running
wait
