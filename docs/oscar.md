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

## aws

```bash { "name": "aws-sso-harvet2-dev" }
aws sso login --profile harvet2-dev
```

## nodenv

```bash { "name": "install-nodenv" }
git clone https://github.com/nodenv/nodenv.git ~/.nodenv
if [ grep -c 'nodenv init' ~/.zsh_custom -ge 1 ]
then
  echo 'eval "$(~/.nodenv/bin/nodenv init - --no-rehash zsh)"' >> ~/.zsh_custom
fi
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
```
