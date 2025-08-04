# Llama Setup on VACC HPC with VS Code

This guide explains how to connect to the VACC cluster via SSH, set up a Conda environment, and prepare to run vacc existing Llama models in VS Code

---

## Step 1: Connect VS Code with SSH

1. Follow this tutorial: [VS Code SSH Setup](https://www.youtube.com/watch?v=HZxuuWlJ7_s&t=210s)
2. Connect to VACC using:
   ```bash
   ssh [username]@login.vacc.uvm.edu
   ```

## Step 2: Clone this repo
```bash
git clone https://github.com/Parisasuchdev/llama_setup_vacc.git
```

## Step 3: Check if Conda is Accessible
Run:
```bash 
conda --version
```
If conda is not available, load the appropriate module:

```bash
module load python3.11-anaconda/2024.02-1
```

## Step 4: Create a Conda Environment for Llama
### Option A: Manual Setup
```bash
conda create -n llama_setup -y
conda activate llama_setup

# Install Jupyter for running notebooks
conda install jupyter -y

# Install key packages
pip install transformers torch accelerate
```
### Option B: Using an Environment YAML
```bash 
conda env create -f environment.yml
conda activate llama_setup
```

## Step 5: Start Jupyter Notebook
```bash
sh jupyter_setup/start-jupyter.sh nvgpu
```

## Run in Offline Mode (Optional)
If your project requires strictly on-premises execution (no internet calls to Hugging Face Hub), set:
```bash
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
```

## Extra Resources
[Fine-tuning](https://huggingface.co/blog/ImranzamanML/fine-tuning-1b-llama-32-a-comprehensive-article)








