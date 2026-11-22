# Bhai for Windows

This folder turns the supplied Mark-LVII Python desktop assistant into **Bhai** and adds a one-time setup plus Windows shortcuts.

## Install and launch

1. Keep this folder in a location you can write to, such as Documents. If you received a ZIP, extract it first.
2. Double-click **Install Bhai.bat** once. It creates a private Python environment, installs the app's required packages and browser support, then adds **Bhai** to your desktop and opens the app.
3. Enter your model API key in the app when prompted. After setup, launch Bhai from the desktop shortcut; no command entry is needed.

If Python 3.11, 3.12, or 3.13 is not installed, install one from [python.org](https://www.python.org/downloads/windows/) and run the setup file again. Initial setup needs an internet connection and downloads the app dependencies and browser engines.

The optional built-in wake-word model still listens for **“Hey Jarvis”**. Its bundled recognition model is trained on that phrase; the assistant's displayed and spoken name is Bhai.

## Package notes

This is a Windows launcher and source package, not a single self-contained EXE. It keeps the original project license and source documentation; the app's code was rebranded and its Windows first-run flow was added. The separate `rea-main.zip` toolkit is not required to run Bhai.

