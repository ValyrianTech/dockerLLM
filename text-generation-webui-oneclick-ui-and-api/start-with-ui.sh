#!/bin/bash
echo "Starting: Ooobabooga's text-generation-webui. Container provided by TheBloke."

SCRIPTDIR=/root/scripts
VOLUME=/workspace

# If a volume is already defined, $VOLUME will already exist
# If a volume is not being used, we'll still use /worksapce to ensure everything is in a known place.
mkdir -p $VOLUME/logs

# Start build of llama-cpp-python in background
if [[ ! -f /.built.llama-cpp-python ]]; then
	"$SCRIPTDIR"/build-llama-cpp-python.sh >>$VOLUME/logs/build-llama-cpp-python.log 2>&1 &
fi

if [[ $PUBLIC_KEY ]]; then
	mkdir -p ~/.ssh
	chmod 700 ~/.ssh
	cd ~/.ssh
	echo "$PUBLIC_KEY" >>authorized_keys
	chmod 700 -R ~/.ssh
	service ssh start
fi

# Move text-generation-webui's folder to $VOLUME so models and all config will persist
"$SCRIPTDIR"/textgen-on-workspace.sh

# If passed a MODEL variable from Runpod template, start it downloading
# This will block the UI until completed
# MODEL can be a HF repo name, eg 'TheBloke/guanaco-7B-GPTQ'
# or it can be a direct link to a single GGML file, eg 'https://huggingface.co/TheBloke/tulu-7B-GGML/resolve/main/tulu-7b.ggmlv3.q2_K.bin'
if [[ $MODEL ]]; then
	"$SCRIPTDIR"/fetch-model.py "$MODEL" $VOLUME/text-generation-webui/models >>$VOLUME/logs/fetch-model.log 2>&1
fi

# Checkout a specific commit of text-generation-webui that is known to work
cd /workspace/text-generation-webui && git checkout 7cf1402

# If UI_UPDATE is passed from the Runpod template
if [[ ${UI_UPDATE} ]]; then
  # Check if UI_UPDATE is 'true' for a general update
  if [[ ${UI_UPDATE} == "true" ]]; then
    echo "Updating text-generation-webui to the latest commit" && \
    cd /workspace/text-generation-webui && \
    git pull origin main && \
    pip install -r requirements.txt --no-deps && \
    pip install transformers -U && \
    pip install gradio -U && \
    pip install exllamav2 -U --no-deps && \
    pip install flash_attn -U --no-deps
  # If UI_UPDATE is a commit hash, checkout that specific hash
  elif [[ ${UI_UPDATE} =~ ^[a-f0-9]{7,40}$ ]]; then # regex to match a SHA-1 hash between 7 and 40 characters
    echo "Checking out specific commit: $UI_UPDATE" && \
    cd /workspace/text-generation-webui && \
    git checkout ${UI_UPDATE} && \
    pip install -r requirements.txt --no-deps && \
    pip install transformers -U && \
    pip install gradio -U && \
    pip install exllamav2 -U --no-deps && \
    pip install flash_attn -U --no-deps
  else
    echo "ERROR: Invalid UI_UPDATE value. It must be 'true' or a valid git commit hash."
  fi
fi

# Move the script that launches text-gen to $VOLUME, so users can make persistent changes to CLI arguments
if [[ ! -f $VOLUME/run-text-generation-webui.sh ]]; then
	mv "$SCRIPTDIR"/run-text-generation-webui.sh $VOLUME/run-text-generation-webui.sh
fi

ARGS=()
while true; do
	# If the user wants to stop the UI from auto launching, they can run:
	# touch $VOLUME/do.not.launch.UI
	if [[ ! -f $VOLUME/do.not.launch.UI ]]; then
		# Launch the UI in a loop forever, allowing UI restart
		if [[ -f /tmp/text-gen-model ]]; then
			# If this file exists, we successfully downloaded a model file or folder
			# Therefore we auto load this model
			ARGS=(--model "$(</tmp/text-gen-model)")
		fi
		if [[ ${UI_ARGS} ]]; then
			# Passed arguments in the template
			ARGS=("${ARGS[@]}" ${UI_ARGS})
		fi

		# Run text-generation-webui and log it.
		# tee is used for logs so they also display on 'screen', ie will show in the Runpod log viewer
		($VOLUME/run-text-generation-webui.sh "${ARGS[@]}" 2>&1) | tee -a $VOLUME/logs/text-generation-webui.log

	fi
	sleep 2
done

# shouldn't actually reach this point
sleep infinity
