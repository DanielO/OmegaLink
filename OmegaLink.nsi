;NSIS script for Omega Link
!include nsDialogs.nsh
!include LogicLib.nsh

XPStyle on

Var Dialog
Var Label
Var Prefix
Var PrefixId

Page custom nsDialogsPage nsDialogsPageLeave
Page instfiles

; Tell Vista/7 we need rights
RequestExecutionLevel admin

; Title
Name "Omega Link"

; Enable CRC checking
CRCCheck On

; Output filename
OutFile "OmegaLink.exe"

; Default installation directory
InstallDir "$PROGRAMFILES\Omega Link"

Section "Install"
  ; Install Files
  SetOutPath $INSTDIR
  File OmegaLink.ps1
  ; Setup protocol keys
  WriteRegStr HKCR "omegalink" "" "URL:Omega Link Protocol"
  WriteRegStr HKCR "omegalink" "URL Protocol" ""
  WriteRegStr HKCR "omegalink" "prefix" $Prefix
  WriteRegStr HKCR "omegalink\shell\open\command" "" '"$WINDIR\System32\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "$INSTDIR\omegalink.ps1" "%1"'
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OmegaLink" "DisplayName" "Omega Link (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OmegaLink" "UninstallString" "$INSTDIR\Uninst.exe"
  WriteUninstaller "Uninst.exe"
SectionEnd

UninstallText "This will uninstall Omega Link from your system"

Section "Uninstall"
  Delete "$INSTDIR\*.*"
  RmDir  "$INSTDIR"
  DeleteRegKey HKCR "omegalink"
SectionEnd

Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $Dialog

	${If} $Dialog == error
		Abort
	${EndIf}

	${NSD_CreateLabel} 0 0 100% 12u "Enter default prefix"
	Pop $Label

	${NSD_CreateText} 0 13u 100% 13u $Prefix
	Pop $PrefixID

	nsDialogs::Show
FunctionEnd

Function nsDialogsPageLeave
	${NSD_GetText} $PrefixId $Prefix
FunctionEnd

Section
SectionEnd