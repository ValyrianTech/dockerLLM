NOTE: this template is outdated and no longer maintained. Please refer to the new repo at https://github.com/ValyrianTech/text-generation-webui_docker

There is a brand new template available for **text-generation-webui v2.0** with many new features and improvements. 

Please use the new template instead of this one.
You can deploy the new template called 'text-generation-webui v2.0 with API one-click' with this link: https://runpod.io/console/deploy?template=bzhe0deyqj&ref=2vdt3dn9


# Text-generation-webui Docker templates

[Full documentation is available here](https://github.com/ValyrianTech/dockerLLM/blob/main/README_Runpod_LocalLLMsUIandAPI.md)

### Update: 28 April 2024
* Fixed the `UI_UPDATE` environment variable to actually work, however this experimental feature is not recommended for production use.
* When `UI_UPDATE` is set to `true`, the template will now update text-generation-webui to the latest version.
* You can also set `UI_UPDATE` to a specific commit hash to update to a specific version.
* Do keep in mind this will add an extra 2-3 minutes to the startup time of the template.

### Update: 30 March 2024
* Changed docker image name to 'valyriantech/text-generation-webui-oneclick-ui-and-api' to avoid confusion
* Changed default behaviour of the startup script to no longer automatically update text-generation-webui and exllama on starting the template because I'm tired of having this template break every few weeks.
* If you still want to have the latest version, you can add and environment variable `UI_UPDATE` with value `true` when deploying the template on Runpod.
* Changed transformers back to version 4.37.2 because AutoGPTQ is broken with the latest version.
* Docker image no longer uses the latest state of the repository, but a specific commit that is known to work. This should prevent the template from breaking in the future.

### Update: 29 March 2024
* Updated gradio to latest version (4.23.0)
* Updated transformers to latest version (4.39.2)

### Update: 24 March 2024
* For future reference, the changes needed to get the template working again were:
* Updating safetensors to latest version
* Downgrading flash_attn to 2.5.5
* Downgrading transformers to 4.37.2
* Updating exllamav2 to 0.0.16 (but without updating dependencies)

### Update: 23 March 2024
* I forked the oneclick template repository (https://github.com/TheBlokeAI/dockerLLM) as TheBloke seems to have stopped updating it and it broke.
* I have updated the template to use my forked repository, which should now work again.
* Since the original repository is no longer maintained, I will be updating this forked repository with new features and fixes as needed.
* New repo: https://github.com/ValyrianTech/dockerLLM

### Update: 16 December 2023 - Rebuild to add Mixtral support
* Should now support Mixtral, with updated AutoGPTQ 0.6 and llama-cpp-python 0.2.23
* Updated PyTorch to 2.1.1

### Update: 11 October 2023 - Update API command line option
* Container will now launch text-generation-webui with arg `--extensions openai`
* Logs from text-generation-webui will now appear in the Runpod log viewer, as well as `/workspace/logs/text-generation-webui.log`

### Update: 8th October 2023 - CUDA 12.1.1, fixed ExLlamav2 issues
* The instances now use CUDA 12.1.1, which fixes issues with EXL2
* Note that for now the main container is still called cuda11.8.0-ubuntu22.04-oneclick
* This is because I need to get in touch with Runpod to update the name of the container used in their instances
* This is just a naming issue; the container does now use CUDA 12.1.1 and EXL2 is confirmed to work again.

### Update: 23rd July 2023 - Llama 2 support, including Llama 2 70B in ExLlama
* Llama 2 models, including Llama 2 70B, are now fully supported
* Updated to latest text-generation-webui `requirements.txt`
* Removed the exllama pip package installed by text-generation-webui
  * Therefore the ExLlama kernel will build automatically on first use
  * This ensures that ExLlama is always up-to-date with any new ExLlama commits (which are pulled automatically on each boot)
* Added simple build script for building the Docker containers

### Update: 28th June 2023 - SuperHOT fixed
* Updated to latest ExLlama code, fixing issue with SuperHOT GPTQs
* ExLlama now automaticaly updates on boot, like text-generation-webui already did
  * This should result in the template automatically supporting new ExLlama features in future
    
### Update: 19th June 2023
* Major update to the template
* text-generation-webui is now integrated with:
  * AutoGPTQ with support for all Runpod GPU types
  * ExLlama, turbo-charged Llama GPTQ engine - performs 2x faster than AutoGPTQ (Llama 4bit GPTQs only)
  * CUDA-accelerated GGML support, with support for all Runpod systems and GPUs.
* All text-generation-webui extensions are included and supported (Chat, SuperBooga, Whisper, etc).
* text-generation-webui is always up-to-date with the latest code and features.
* Automatic model download and loading via environment variable `MODEL`.
* Pass text-generation-webui parameters via environment variable `UI_ARGS`.

