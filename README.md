# **zap — a beginner‑friendly zip tool**

`zap` is a simple alternative to the popular command‑line .zip file tools for working with `.zip` files. Im not sure why trhis is the case but for some reason alot of command line tools use commands that make no sense or have no logical connection to the task you are trying to do. Lets say you are wanting to unzip a tar file tar -czf archive.tar.gzv'? & that would be perfectly fine if it provided simple documentation as to what means what yet these code snobs hardly put anything in documentation and if they do then its likley unreadable to the average man. This is what makes said code snobs feel superior so expect it to continue for some time. I am a firm beliver in basic, obvious commands that do exactly what they sound like they do.

"Just obvious commands that do exactly what it sounds like they do." - Zap

---

## **Features**

- `zap zip` — zip the current directory
- `zap zip <directory>` — zip a specific directory
- `zap unzip` — unzip all `.zip` files in the current directory
- `zap unzip <file.zip>` — unzip a specific file
- `zap list` — list all `.zip` files in the current directory
- `zap delete` — delete all `.zip` files in the current directory
- `zap delete <file.zip>` — delete a specific zip file
- `zap info` — show info about the current directory
- `zap info <file.zip>` — show detailed info about a zip file (sizes, timestamps, contents)

All output is cleanly formatted with color and boxed headers.

---

## **Installation**

You don’t need pip, virtualenvs, or any Python packaging nonsense.

1. Just open the command line application of your choice & paste the following command then press enter.
```
curl -fsSL https://raw.githubusercontent.com/via80HD/zap/main/install-zap.sh | bash
```

This will do all of the work for you, minimizing any risk that comes with having you run through all the steps manually. You will know that the install has completed when you see a message at the bottom of your command line app that says

### ZAP IS INSTALLED!


## **Why Zap Exists** ##
Because the zip command pissed me off by not even providing basic instruction on how to do one of the main functions of their tool, which is unzipping more then one zip file in a directory. So my AI pal & I came up with this. Not for command line snobs. 
