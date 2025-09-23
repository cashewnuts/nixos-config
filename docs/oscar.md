# Development User: Oscar

## ssh setup

```bash { "name": "ssh-keygen" }
export EMAIL="cashewnuts903+oscar@gmail.com"

ssh-keygen -t ed25519 -C $EMAIL
```

```bash { "name": "ssh-add" }
export KEY_FILE="$HOME/.ssh/id_ed25519"

ssh-add $KEY_FILE
```
