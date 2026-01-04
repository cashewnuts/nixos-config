# Basic User: Alice

## この環境の目的

普段使いするための環境で、ブラウザは個人に関係するサービスにアクセスするために使用する。
日記を書いたり、簡単な調べものをしたりする使い方も想定する。

## Commands

### ssh setup

```bash { "name": "ssh-keygen" }
export EMAIL="cashewnuts903+alice@gmail.com"

ssh-keygen -t ed25519 -C $EMAIL
```

```bash { "name": "ssh-add" }
export KEY_FILE="$HOME/.ssh/id_ed25519"

ssh-add $KEY_FILE
```
