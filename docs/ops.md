# Operations & Troubleshooting

## NFS Server (beta-1)
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

Make sure beta-1 is reachable on `100.124.211.75`.

---

## OpenClaw on beta-1
OpenClaw is installed and running with tailnet bind.

Check status:
```bash
openclaw gateway status
```

If you need to connect remotely:
```bash
export OPENCLAW_GATEWAY_URL=ws://100.124.211.75:18789
export OPENCLAW_GATEWAY_TOKEN=... # stored at /home/ci/openclaw_gateway_token.txt
openclaw status
```

---

## Common issues
### “mount.nfs: permission denied”
- Ensure your client has a Tailscale IP in `100.64.0.0/10`
- Check exports on beta-1 (`sudo exportfs -v`)

### Mounts disappear after reboot
- Run install scripts in this repo to auto-mount on boot

### Ollama models not visible
- Confirm `OLLAMA_MODELS` is set to the mounted path
- Confirm the share is mounted and writable

---

## Security notes
- NFS is restricted to Tailscale’s CGNAT range only
- If you want per-device controls, we can restrict exports to specific IPs
