# Ollama Model Cache

## Goal
Use beta-1 as the **shared model storage** for Ollama, so all Tailnet machines reuse the same model files.

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

## Option: Run Ollama server on beta-1
You can host a central Ollama server so clients just send requests.

### On beta-1
```bash
# Example service install (manual)
ollama serve
```

Then on clients:
```bash
export OLLAMA_HOST=http://100.124.211.75:11434
```

This avoids local GPU usage on clients and consolidates model usage.

---

## Notes
- NFS permissions are configured to map clients to uid/gid 1000 (ci user)
- If you want per-user permissions, we can switch to NFSv4 with proper uid mapping
