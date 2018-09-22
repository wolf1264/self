* * *

## Commands

| Command | Description |
|--------|------------|
| [#!/]help | just send help in your group and get the commands |

**You can use "#", "!", or "/" to begin all commands

* * *

# Installation

```sh
# Let's install the self-bot.
cd $HOME
git clone https://github.com/wolf1264/self.git
cd self
chmod +x self.sh
./self.sh install
./self.sh # Enter a phone number & confirmation code.
```
### One command
To install everything in one command, use:
```sh
cd $HOME && git clone https://github.com/wolf1264/self.git && cd self && chmod +x self.sh && ./self.sh install && ./self.sh
```

* * *

### Sudo And Bot

Open ./bot/bot.lua and add your ID to the "sudo_users" section in the following format:
```
    sudo_users = {460848425, YourID}
```
add your ID at line 131 in bot.lua
Then restart Bot.

* * *