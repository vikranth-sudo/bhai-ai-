Option Explicit

Dim fso, shell, appRoot, pythonw, installer
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
appRoot = fso.GetParentFolderName(WScript.ScriptFullName)
pythonw = appRoot & "\.venv\Scripts\pythonw.exe"

If Not fso.FileExists(pythonw) Then
    MsgBox "Bhai needs a one-time setup before its first launch. Setup will install the app and create a desktop shortcut.", vbInformation, "Bhai setup"
    shell.Run Chr(34) & appRoot & "\Install Bhai.bat" & Chr(34), 1, False
Else
    shell.Run Chr(34) & pythonw & Chr(34) & " " & Chr(34) & appRoot & "\main.py" & Chr(34), 0, False
End If
