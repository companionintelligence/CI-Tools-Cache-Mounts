# Operations & Troubleshooting

## NFS Server
### Exports
```bash
sudo exportfs -v
```

### Restart NFS
```bash
sudo systemctl restart nfs-server
```

### Verify mounts on client
```bash
mount | grep cache
```

---

## Tailscale connectivity
```bash
tailscale status
```

Make sure your configured `CACHE_SERVER` is reachable on your VPN/LAN.

---

## OpenClaw on the cache server
OpenClaw is installed and running with tailnet bind.

Check status:
```bash
openclaw gateway status
```

If you need to connect remotely:
```bash
export OPENCLAW_GATEWAY_URL=ws://CACHE_SERVER:18789
export OPENCLAW_GATEWAY_TOKEN=... # stored at /home/ci/openclaw_gateway_token.txt
openclaw status
```

---

## Common issues
### “mount.nfs: permission denied”
- Ensure your client has a Tailscale IP in `100.64.0.0/10`
- Check exports on the cache server (`sudo exportfs -v`)

### Mounts disappear after reboot
- Run install scripts in this repo to auto-mount on boot

### Ollama models not visible
- Confirm `OLLAMA_MODELS` is set to the mounted path
- Confirm the share is mounted and writable

### npm or Hugging Face caches are not being reused
- Confirm the relevant cache share is included in `CACHE_NAMES`
- Confirm your tool points to the mounted path (`npm config set cache ...`, `HF_HOME=...`)

---

## Security notes
- NFS is restricted to Tailscale’s CGNAT range only
- If you want per-device controls, we can restrict exports to specific IPs
