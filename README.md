# Llama Setup on VACC HPC with VS Code

This guide explains how to connect to the UVM VACC cluster via SSH, set up a Conda environment, and start a Jupyter Notebook **without using VACC OnDemand** — so you can work directly in VS Code with available Llama and Hugging Face models **especially when you data needs to be on-premises**.

---

## 1. Models Available

Models are stored in:
```
/gpfs1/llm/
```
This directory contains:
- **Meta models** (e.g., llama series)
- **Additional Hugging Face (HF) models**

The provided example notebooks focus on Hugging Face models.  
To use Meta models, you may need to adjust:
- File paths
- Tokenizer configurations

---

## 2. Connect VS Code to VACC

1. Install the **VS Code Remote - SSH extension**.
2. Follow this [VS Code SSH setup video](https://www.youtube.com/watch?v=HZxuuWlJ7_s&t=210s).
3. Connect to VACC:
   ```bash
   ssh [username]@login.vacc.uvm.edu
   ```

---

## 3. Clone This Repository
```bash
git clone https://github.com/Parisasuchdev/llama_setup_vacc.git
cd llama_setup_vacc
```

---

## 4. Check Conda Availability
```bash
conda --version
```
If Conda is unavailable, load the module:
```bash
module load python3.11-anaconda/2024.02-1
```

---

## 5. Create Conda Environment

### Option A – Manual Setup
```bash
conda create -n llama_setup -y
conda activate llama_setup

# Install Jupyter
conda install jupyter -y

# Install key packages
pip install transformers torch accelerate
```

### Option B – From environment.yml
```bash
conda env create -f environment.yml
conda activate llama_setup
```

### Option C - No Conda, just use [uv](https://github.com/astral-sh/uv) (JSO)

You can install [uv](https://github.com/astral-sh/uv) package manager using
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then, you can use `sync` to install the dependencies
```bash
uv sync 
```

It should also create a virtual environment available in vscode. To run some notebooks, you will also need to download the following spacy's transformer model

```bash
uv run python -m spacy download en_core_web_trf
```
Overall, `uv` is much faster and smarter than conda. Reconciling dependencies take forever on conda, especially when dealing with LLMs stack.

---

## 6. Directory Structure

```bash
llama_setup_vacc/
├── basic_linux_commad.txt        # Helpful HPC/Linux commands
├── environment.yml               # Conda environment file
├── jupyter_setup/
│   ├── jupyter-server.sbatch     # SLURM script to start Jupyter on GPU node
│   ├── start-jupyter.sh          # Helper to submit job and set up port forwarding
│   └── tmp/                      # Stores SLURM output logs for Jupyter jobs
├── pyproject.toml.               # uv pyproject.toml
├── src
│   ├── 01_run_llama.ipynb        # HF model stance classification demo
│   ├── 02_template.ipynb         # Dataset pipeline version of above
│   ├── 03_validating_NER.ipynb   # Doing NER using LLMs, validating with Spacy
│   ├── 04_knowledge_graph.ipynb  # Llama_cpp model for knowledge graph extraction
│   └── templates                 # prompt templates
│       └── 03_validating_NER
│           ├── prompt_0.txt
│           └── prompt_1.txt
└── uv.lock                       # uv lock file
```

### Notebook Details
- **`01_run_llama.ipynb`**
  - Hard-coded example of stance classification using transformers pipeline
  - Good first run to verify environment setup
  - Play with prompts and parameters
- **`01b_run_llama_outlines.ipynb`**
  - Enhanced version using Outlines for structured generation
  - Demonstrates Enums, Pydantic models, and Template system
  - Shows JSON-structured responses with confidence scoring
- **`02_template.ipynb`**
  - Extends basic classification to batch processing pipeline
  - Applies stance classification to entire datasets
  - Outputs structured CSV with expanded classification results
- **`03_validating_NER.ipynb`**
  - Named Entity Recognition validation using LLMs vs SpaCy
  - Uses Outlines for structured Person entity extraction
  - Demonstrates validation workflows and prompt engineering
  - Includes multiple prompt templates in `templates/03_validating_NER/`
- **`04_knowledge_graph.ipynb`**
  - Knowledge graph extraction using llama-cpp-python
  - Structured entity and relationship extraction

---

## 7. Launch Jupyter Notebook via SLURM

Run:
```bash
sh jupyter_setup/start-jupyter.sh nvgpu
```
Where:
- `nvgpu` is your job name (output log stored at `jupyter_setup/tmp/nvgpu.out`).

### What Happens
1. Job is submitted to the GPU partition
2. Script waits for the Jupyter server to start
3. When ready, the terminal prints a **localhost URL with token**
4. Open the URL in your browser

### Kernel Connection in VS Code
- In the notebook interface:  
  **Select Kernel → Existing Jupyter Server → Enter the remote URL printed by the script**

### SLURM Notifications
Edit `jupyter-server.sbatch`:
```bash
#SBATCH --mail-user=your.email@uvm.edu
```
You’ll receive **job begin, end, and fail** notifications

### Resource Customization
Adjust in `jupyter-server.sbatch`:
- `--time` → Runtime (e.g., `2:00:00` for 2 hrs)
- `--mem` → Memory (e.g., `20G`)
- `--gres` → GPUs (e.g., `gpu:1`)

---

## 8. Run in Offline Mode (Optional)

If no internet access to Hugging Face Hub is required:
```bash
export HF_HUB_OFFLINE=1
export TRANSFORMERS_OFFLINE=1
```

---

## 9. Extra Resources
- [Fine-tuning LLaMA models](https://huggingface.co/blog/ImranzamanML/fine-tuning-1b-llama-32-a-comprehensive-article)

