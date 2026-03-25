---
name: peer-ssh
version: 1.0.0
description: SSH access to peer LobsterFarm instances. Use when you need to run commands on a peer node, check its status, read its logs, restart its services, or troubleshoot it remotely.
---

# Peer SSH Skill

You have SSH access to all LobsterFarm instances using the key at `~/.ssh/claw.pem`.

## Known Peers

| Name | IP | Role |
|------|-----|------|
| claw-anna | 172.31.46.209 | Crab's instance (OpenClaw agent) |
| claude-code (self) | 172.31.39.106 | This instance |

Health endpoints: `http://<ip>:8080/health`

## SSH Usage

```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@<ip> "<command>"
```

## Common Operations

### Check peer health
```bash
curl -sf http://172.31.46.209:8080/health
```

### Run a command on claw-anna
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "systemctl --user status openclaw-gateway.service --no-pager"
```

### Check a service status
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "systemctl --user status <service> --no-pager"
```

### Restart a service
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "systemctl --user restart <service>"
```

### Tail logs
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "journalctl --user -u <service> -n 50 --no-pager"
```

### Edit a config file on peer
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "cat ~/.openclaw/openclaw.json"
# then use python3 -c or a temp script to modify it, pipe via ssh
```

### Copy a file to peer
```bash
scp -i ~/.ssh/claw.pem <local-path> ec2-user@172.31.46.209:<remote-path>
```

### Copy a file from peer
```bash
scp -i ~/.ssh/claw.pem ec2-user@172.31.46.209:<remote-path> <local-path>
```

### Sync skills to peer immediately
```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "~/.openclaw/../ops/scripts/sync-skills.sh"
```

## Modifying peer openclaw.json

Use a remote Python one-liner piped via SSH:

```bash
SCRIPT=$(cat << 'EOF'
import json
path = '/home/ec2-user/.openclaw/openclaw.json'
d = json.load(open(path))
# make changes to d here
json.dump(d, open(path, 'w'), indent=2)
print('done')
EOF
)
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "python3 << 'PYEOF'
$SCRIPT
PYEOF"
```

## Adding a channel to Crab's allowlist

```bash
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "python3 -c \"
import json
path = '/home/ec2-user/.openclaw/openclaw.json'
d = json.load(open(path))
guild = d['channels']['discord']['guilds']['1482083029835972832']
guild['channels']['<CHANNEL_ID>'] = {'allow': True}
json.dump(d, open(path, 'w'), indent=2)
print('added')
\""
# Then restart gateway to pick up the change:
ssh -i ~/.ssh/claw.pem -o StrictHostKeyChecking=no ec2-user@172.31.46.209 "systemctl --user restart openclaw-gateway.service"
```

## Notes

- Prefer SSH over SSM now that the key is available — SSH is faster and has no IAM dependency
- Always restart `openclaw-gateway.service` after editing `openclaw.json` on claw-anna
- The key at `~/.ssh/claw.pem` is the `claw` EC2 key pair — handle carefully, don't log it
