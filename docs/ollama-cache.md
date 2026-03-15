# Ollama Model Cache

## Goal
Use your shared cache server as the **shared model storage** for Ollama, so all machines on the VPN/LAN reuse the same model files.

## Model storage path
Ollama uses the `OLLAMA_MODELS` env var to control where models are stored.

### On clients (macOS/Linux)
Set this to the **mounted NFS** path:

```bash
export OLLAMA_MODELS=/Volumes/cache-ollama   # macOS
# or
export OLLAMA_MODELS=/mnt/cache/ollama       # Linux
```

Now `ollama pull llama3` will store the model in the shared cache.

---

## Option: Run Ollama server on the cache server
You can host a central Ollama server so clients just send requests.

### On the cache server
```bash
# Example service install (manual)
ollama serve
```

Then on clients:
```bash
export OLLAMA_HOST=http://CACHE_SERVER:11434
```

This avoids local GPU usage on clients and consolidates model usage.

---

## Other shared model caches
Hugging Face can use the same mounted approach:

```bash
export HF_HOME=/mnt/cache/huggingface      # Linux
# or
export HF_HOME=/Volumes/cache-huggingface  # macOS
```

This keeps downloaded models and datasets shared across machines.

---

## Notes
- NFS permissions are configured to map clients to uid/gid 1000 (ci user)
- If you want per-user permissions, we can switch to NFSv4 with proper uid mapping
