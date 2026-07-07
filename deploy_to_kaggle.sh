#!/bin/bash

# ==============================================================================
# KAGGLE AUTOMATED CODE DEPLOYMENT SCRIPT (CI/CD OPTIMIZED)
# This script pushes the root directory notebook to Kaggle.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status.
set -e

echo "====================================================="
echo "🚀 Starting Kaggle Code Deployment Pipeline..."
echo "====================================================="

# ------------------------------------------------------------------------------
# 1. DEPLOY NOTEBOOK (KERNEL)
# ------------------------------------------------------------------------------
echo -e "\n📓 Step 1: Checking for Kaggle Kernel Metadata..."

if [ ! -f "kernel-metadata.json" ]; then
    echo "❌ ERROR: kernel-metadata.json not found in the root directory."
    echo "Please run 'kaggle kernels init', configure the JSON, commit, and push."
    exit 1
fi

echo "Pushing notebook to Kaggle..."
kaggle kernels push -p .

echo "✅ Kernel successfully pushed to Kaggle."
echo -e "\n🎉 Deployment Pipeline Completed Successfully!"
