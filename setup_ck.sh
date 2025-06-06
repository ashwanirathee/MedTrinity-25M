#!/bin/bash

set -e

set -x

ENV_NAME="llava-med-pp"

# Check if env exists
if conda env list | grep -q "$ENV_NAME"; then
    echo "✅ Environment '$ENV_NAME' already exists. Activating..."
else
    echo "🚀 Creating environment '$ENV_NAME'..."
    conda create -n "$ENV_NAME" python=3.10 -y
fi

conda activate $ENV_NAME

pip install --upgrade pip
pip install -e .

python -m pip install huggingface_hub
python download_weights.py
python llava/eval/model_vqa.py   --model-path ./checkpoints/llava-llama-med-8b-stage2-finetune/   --question-file results/question_vqa.jsonl   --answers-file results/fake_answers_vqa.jsonl --image-folder ./images --num-chunks 8 --conv-mode llama3
python llava/eval/model_qa.py   --model-name facebook/opt-350m   --question-file results/questions_qa.jsonl   --answers-file results/fake_answers_qa.jsonl

set +x