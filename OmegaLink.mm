#include "ME.MMH"

#define PROJECT_NAME		OmegaLink

<$DirectoryTree Key="INSTALLDIR" Dir="[ProgramFilesFolder]\<$PROJECT_NAME>" CHANGE="\" PrimaryFolder="Y">
<$Files "OmegaLink.ps1" DestDir="INSTALLDIR">
<$Component "REGIMPORT_CLASSES_ROOT" Create="Y" Directory_="<$AnyDir>"><$/Component>

<$Dialog "Prefix Dialog" INSERT="WelcomeDlg" Dialog="PrefixDialog">
    <$DialogEntry Property="PREFIX" Label="&Prefix:"     ToolTip="Enter path prefix for links" Blank="N" Width=200>
<$/Dialog>

#(
    <$Registry
               HKEY="CLASSES_ROOT"
                KEY="omegalink"
               NAME=""
              VALUE="URL:Omega Link Protocol"
             KEYPATH="Y"
           Component="REGIMPORT_CLASSES_ROOT"
    >
#)

#(
    <$Registry
               HKEY="CLASSES_ROOT"
                KEY="omegalink"
               NAME="URL Protocol"
              VALUE=""
             KEYPATH="Y"
           Component="REGIMPORT_CLASSES_ROOT"
    >
#)

#(
    <$Registry
               HKEY="CLASSES_ROOT"
                KEY="omegalink"
               NAME="prefix"
              VALUE="[PREFIX]"
             KEYPATH="Y"
	     MSIFORMATTED="VALUE"
           Component="REGIMPORT_CLASSES_ROOT"
    >
#)

#(
    <$Registry
                HKEY="CLASSES_ROOT"
                 KEY="omegalink\shell"
             KEYPATH="Y"
           Component="REGIMPORT_CLASSES_ROOT"
    >
#)

#(
    <$Registry
                HKEY="CLASSES_ROOT"
                 KEY="omegalink\shell\open"
             KEYPATH="Y"
           Component="REGIMPORT_CLASSES_ROOT"
    >
#)

#(
    <$Registry
               HKEY="CLASSES_ROOT"
                KEY="omegalink\shell\open\command"
               NAME=""
              VALUE='"[SystemFolder]WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -WindowStyle Hidden -File "[INSTALLDIR]\omegalink.ps1" "%1"'
             KEYPATH="Y"
           Component="REGIMPORT_CLASSES_ROOT"
        MsiFormatted="VALUE"
    >
#)
