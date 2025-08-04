# Llama Setup on VACC HPC with VS Code

This guide explains how to connect to the VACC cluster via SSH, set up a Conda environment, start jupyter notebook without using vacc on demand and prepare to run vacc existing Llama models in VS Code

## Models Available
The current notebook example demonstrates how to work with **Hugging Face (HF) models**.  
More models are available in the following directory: `/gpfs1/llm/` on VACC
This directory contains:
- **Meta models** (e.g., Meta’s llama series)
- **Additional Hugging Face (HF) models**

The included notebooks (`01_run_llama.ipynb` and `02_template.ipynb`) currently demonstrate only HF models and to use the Meta models, you may need to adjust paths and/or tokenizer configurations

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
To launch a Jupyter Notebook on VACC using SLURM:
```bash
sh jupyter_setup/start-jupyter.sh nvgpu
```
- nvgpu, in this commad, is the job name its log file will be saved at `jupyter_setup/tmp/nvgpu.out'. Can be changed to any name
- Once the job starts, you will see a Jupyter Notebook URL in the terminal and also in `jupyter_setup/tmp/nvgpu.out'
- Once you get the URL/resources in the terminal, click it (or copy–paste it into your browser) and make sure it opens without errors
- In Jupyter Notebook, select kernel > existing jupyter server > enter a remote URL you received

**Notes:**  
- Replace `your.email@uvm.edu` with your UVM email to receive job notifications  
- Adjust `--time`, `--mem`, and `--gres` according to your resource needs
- The `jupyter_setup/tmp/` directory stores SLURM output logs for each job

## Notebooks Overview

- **01_run_llama.ipynb** 
   - contains hard coded example of stance classification
   - Recommended as the first notebook to run in order to confirm that all required libraries and the environment are set up correctly and to play with prompt and params  

- **02_template.ipynb**  
  - Extends `01_run_llama.ipynb` by turning stance classification into a reusable pipeline for an entire dataset  
  - Outputs structured JSON with fields instead of just classifying one example

## Run in Offline Mode (Optional)
If your project requires strictly on-premises execution (no internet calls to Hugging Face Hub), set:
```bash
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
```

## Extra Resources
[Fine-tuning](https://huggingface.co/blog/ImranzamanML/fine-tuning-1b-llama-32-a-comprehensive-article)








