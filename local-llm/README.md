# Local LLM/AI

## Start the LLM

Start local LLM (via `ollama` [docker image](https://hub.docker.com/r/ollama/ollama)):
```bash
# start ollama
docker run -d --gpus all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
# start the model
docker exec -it ollama ollama run <MODEL>
```
where `<MODEL>` is the model (for example `gemma4:e2b` or `llama3`).
Choose from a [list of available models](https://ollama.com/search).

## Start the Chat-like web interface

Start Chat WebUI:
```bash
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```
