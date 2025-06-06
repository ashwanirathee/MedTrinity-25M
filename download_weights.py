from huggingface_hub import hf_hub_download

repo_id = "UCSC-VLAA/LLaVA-Med-pp"
subfolder = "SLAKE"  # Folder inside the repo
local_dir = "./checkpoints"  # Where to save files


filenames = [
    "config.json",
    "generation_config.json",
    "model-00001-of-00004.safetensors",
    "model-00002-of-00004.safetensors",
    "model-00003-of-00004.safetensors",
    "model-00004-of-00004.safetensors",
    "model.safetensors.index.json",
    "special_tokens_map.json",
    "tokenizer.json",
    "tokenizer_config.json",
    "trainer_state.json",
    "training_args.bin",
]


for file in filenames:
    local_path = hf_hub_download(
        repo_id=repo_id,
        filename=file,
        subfolder=subfolder,
        local_dir=local_dir,
        local_dir_use_symlinks=False  # Optional: set to False to avoid symlinks
    )
    print(f"✅ Downloaded {file} to: {local_path}")
