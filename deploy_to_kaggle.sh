#!/bin/bash

# ==============================================================================
# KAGGLE AUTOMATED DEPLOYMENT SCRIPT (CI/CD OPTIMIZED)
# This script pushes the latest data and notebooks to Kaggle.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
COMMIT_MESSAGE="Automated GitHub Actions sync: $(date +'%Y-%m-%d %H:%M')"

echo "====================================================="
echo "🚀 Starting Kaggle Deployment Pipeline..."
echo "====================================================="

# ------------------------------------------------------------------------------
# 1. DEPLOY DATASET
# ------------------------------------------------------------------------------
echo -e "\n📦 Step 1: Syncing Dataset (/data)..."
cd data

if [ ! -f "dataset-metadata.json" ]; then
    echo "❌ ERROR: dataset-metadata.json not found in /data."
    echo "Please run 'kaggle datasets init' locally, commit the file, and push again."
    exit 1
fi

# Attempt to create the dataset. If it fails (meaning it already exists), fall back to version update.
# We suppress stdout on create to keep logs clean, but allow version errors to show.
if kaggle datasets create -p . -q > /dev/null 2>&1; then
    echo "✅ New dataset successfully created on Kaggle."
else
    echo "Dataset already exists. Pushing new version..."
    kaggle datasets version -p . -m "$COMMIT_MESSAGE"
    echo "✅ Dataset version successfully updated."
fi
cd ..

# ------------------------------------------------------------------------------
# 2. DEPLOY NOTEBOOKS (KERNELS)
# ------------------------------------------------------------------------------
echo -e "\n📓 Step 2: Pushing Notebooks..."

# Function to push a notebook safely
push_notebook() {
    local dir=$1
    if [ -d "$dir" ]; then
        echo "----------------------------------------"
        echo "Processing directory: $dir"
        cd "$dir"

        if [ ! -f "kernel-metadata.json" ]; then
            echo "⚠️ WARNING: kernel-metadata.json not found in $dir. Skipping."
            cd ..
            return
        fi

        # Push the notebook to Kaggle
        echo "Pushing kernel to Kaggle..."
        kaggle kernels push -p .
        echo "✅ Kernel pushed for $dir"
        cd ..
    else
        echo "⚠️ Directory $dir not found in repository. Skipping."
    fi
}

# Push Phase 1
push_notebook "phase1_process_mining"

# Push Phase 2
push_notebook "phase2_churn_predictor"

# Push Phase 3
push_notebook "phase3_rag_agent"

echo -e "\n🎉 Deployment Pipeline Completed Successfully!"
