# **zap — a beginner‑friendly zip tool**

`zap` is a simple alternative to the popular command‑line tools for working with `.zip` files with ridiculous commands to do simple tasks & little if any explanation of how to use said tools in a way that someone who isn't a command line snob could understand.   

Just obvious commands that do exactly what it sounds like they do.

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
