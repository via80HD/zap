#!/usr/bin/env python3
import sys
import os
from pathlib import Path
from zipfile import ZipFile
from datetime import datetime

# ---------------- COLORS ----------------
RESET = "\033[0m"
BOLD = "\033[1m"
CYAN = "\033[96m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"

# ---------------- HELPERS ----------------
def human_size(num):
    for unit in ["B", "KB", "MB", "GB"]:
        if num < 1024:
            return f"{num:.1f} {unit}"
        num /= 1024
    return f"{num:.1f} TB"

def fmt_time(ts):
    return datetime.fromtimestamp(ts).strftime("%Y-%m-%d %H:%M:%S")

def header(title):
    line = "─" * (len(title) + 2)
    print(f"{CYAN}{line}\n {title}\n{line}{RESET}")

# ---------------- ZIP ----------------
def zip_files(directory):
    zip_filename = f"{directory.name}.zip"
    with ZipFile(zip_filename, 'w') as zip_file:
        for file in directory.iterdir():
            if file.is_file():
                zip_file.write(file, arcname=file.name)
    print(f"{GREEN}Created zip file: {zip_filename}{RESET}")

# ---------------- UNZIP ----------------
def unzip_files(zip_file):
    with ZipFile(zip_file, 'r') as zip_ref:
        zip_ref.extractall(zip_file.parent)
    print(f"{GREEN}Extracted: {zip_file.name}{RESET}")

# ---------------- LIST ----------------
def list_zip_files(directory):
    zips = list(directory.glob("*.zip"))
    header("ZIP FILES")
    if not zips:
        print("No zip files found.")
        return
    for z in zips:
        print(f" - {z.name}")

# ---------------- DELETE ----------------
def delete_zip_files(target):
    if target is None:
        directory = Path.cwd()
        zips = list(directory.glob("*.zip"))
        header("DELETE ZIP FILES")
        if not zips:
            print("No zip files to delete.")
            return
        for z in zips:
            z.unlink()
            print(f"{RED}Deleted: {z.name}{RESET}")
    else:
        file = Path(target)
        header("DELETE ZIP FILE")
        if file.is_file() and file.suffix == ".zip":
            file.unlink()
            print(f"{RED}Deleted: {file.name}{RESET}")
        else:
            print("Error: Not a valid zip file.")

# ---------------- INFO: ZIP ----------------
def info_zip_file(zip_path):
    zip_path = Path(zip_path)
    if not (zip_path.is_file() and zip_path.suffix == ".zip"):
        print("Error: Not a valid zip file.")
        return

    header("ZIP INFO")

    print(f"Archive: {zip_path.name}")
    print(f"Location: {zip_path.parent}")
    print(f"Size: {human_size(zip_path.stat().st_size)}")
    print(f"Modified: {fmt_time(zip_path.stat().st_mtime)}\n")

    with ZipFile(zip_path, 'r') as zip_ref:
        print("Contents:")
        for info in zip_ref.infolist():
            print(f"  {info.filename}")
            print(f"    Modified: {info.date_time}")
            print(f"    Original size: {human_size(info.file_size)}")
            print(f"    Compressed size: {human_size(info.compress_size)}\n")

# ---------------- INFO: DIRECTORY ----------------
def info_directory(directory):
    directory = Path(directory)
    header("DIRECTORY INFO")

    print(f"Directory: {directory}")
    print(f"Modified: {fmt_time(directory.stat().st_mtime)}")

    files = list(directory.iterdir())
    print(f"Total items: {len(files)}")

    zips = list(directory.glob("*.zip"))
    print(f"Zip files: {len(zips)}\n")

    if zips:
        print("Zip List:")
        for z in zips:
            print(f" - {z.name}")

# ---------------- MAIN ----------------
def main():
    if len(sys.argv) < 2:
        print("Usage: zap [zip|unzip|list|delete|info] [file_or_directory]")
        return

    command = sys.argv[1]

    if command == "zip":
        if len(sys.argv) == 3:
            directory_path = Path(sys.argv[2])
            if directory_path.is_dir():
                zip_files(directory_path)
            else:
                print("Error: Specified path is not a directory.")
        else:
            zip_files(Path.cwd())

    elif command == "unzip":
        if len(sys.argv) == 3:
            zip_file_path = Path(sys.argv[2])
            if zip_file_path.is_file() and zip_file_path.suffix == '.zip':
                unzip_files(zip_file_path)
            else:
                print("Error: Specified file is not a valid zip file.")
        else:
            current_directory = Path.cwd()
            for zip_file in current_directory.glob("*.zip"):
                unzip_files(zip_file)

    elif command == "list":
        if len(sys.argv) == 3:
            directory = Path(sys.argv[2])
            if directory.is_dir():
                list_zip_files(directory)
            else:
                print("Error: Not a directory.")
        else:
            list_zip_files(Path.cwd())

    elif command == "delete":
        if len(sys.argv) == 3:
            delete_zip_files(sys.argv[2])
        else:
            delete_zip_files(None)

    elif command == "info":
        if len(sys.argv) == 3:
            info_zip_file(sys.argv[2])
        else:
            info_directory(Path.cwd())

    else:
        print("Error: Unknown command. Use zip, unzip, list, delete, or info.")

if __name__ == "__main__":
    main()
