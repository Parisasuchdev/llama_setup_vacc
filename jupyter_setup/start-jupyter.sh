#!/bin/bash

joboutname=$1
out_dir=tmp
mkdir -p "$out_dir"
jup_outfile="$out_dir/$joboutname.out"
> "$jup_outfile"  # Clear the output file

# Submit job and wait for output
sbatch --output="$jup_outfile" jupyter-server.sbatch

echo "Jupyter notebook server starting on compute node, waiting..."
# Wait for notebook server to start
while ! grep -q "http://localhost" "$jup_outfile"; do
    sleep 1
done

# Extract port number
port=$(grep -oP "http://localhost:\K[0-9]+" "$jup_outfile" | head -1)

# Extract token
token=$(grep -oP 'token=\K[^ ]+' "$jup_outfile" | head -1)

# Extract user (assuming SLURM user matches system user)
user=$(whoami)

# Extract host correctly
host=$(grep -oP "Hostname:\s*\K\S+" "$jup_outfile" | head -1)

# Validate extracted values
if [[ -z "$port" || -z "$token" || -z "$host" ]]; then
    echo "Error: Unable to extract Jupyter server details."
    cat "$jup_outfile"
    exit 1
fi

echo "Jupyter notebook server started on compute node $user@$host"

# Wait a bit to ensure server stability
sleep 2

# Test if SSH can resolve the hostname
if ! ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
    echo "Error: Unable to resolve hostname '$host'. Check network or try using an IP address."
    exit 1
fi

# Connect to the notebook server via SSH port forwarding
ssh -fNT -L "$port:localhost:$port" "$user@$host"

echo "Port forwarding started: $user@$host:$port -> localhost:$port"
echo ""
echo "Connect to the Jupyter server at:"
echo "  http://localhost:$port/tree?token=$token"
echo ""
