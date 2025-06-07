@echo off
setlocal enabledelayedexpansion

:: Set environment name
set ENV_NAME=llava-med-pp

:: Check if conda is available
where conda >nul 2>&1
if errorlevel 1 (
    echo Conda is not available in PATH. Please ensure conda is installed and accessible.
    exit /b 1
)

:: Check if the conda environment exists
conda env list | findstr /C:"%ENV_NAME%" >nul
if %errorlevel%==0 (
    echo ✅ Environment '%ENV_NAME%' already exists. Activating...
) else (
    echo 🚀 Creating environment '%ENV_NAME%'...
    call conda create -n %ENV_NAME% python=3.10 -y
)

:: Activate the environment (Windows-specific)
call conda activate %ENV_NAME%

:: Upgrade pip and install the current directory in editable mode
python -m pip install --upgrade pip
python -m pip install -e .

:: Install huggingface_hub
python -m pip install huggingface_hub

:: Run the scripts
python download_weights.py
python llava\eval\model_vqa.py --model-path .\checkpoints\llava-llama-med-8b-stage2-finetune\ --question-file results\question_vqa.jsonl --answers-file results\fake_answers_vqa.jsonl --image-folder .\images --num-chunks 8 --conv-mode llama3
python llava\eval\model_qa.py --model-name facebook/opt-350m --question-file results\questions_qa.jsonl --answers-file results\fake_answers_qa.jsonl

endlocal
