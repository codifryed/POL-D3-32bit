#!/usr/bin/env playonlinux-bash
# Date : (2017-06-28)
# Wine version used : 2.11-staging
# Distribution used to test : Ubuntu 17.04
# NVidia GeForce GTX 960/PCIe/SSE2
# AMD FX(tm)-6300 Six-Core Processor × 6
# NVidia GTX 750Ti
   
# CHANGELOG
# [SomeGuy42] (17-FEB-2017)
#  Install fails, need to update...
#  Wine 2.11-staging => Wine 2.21-staging
# [metalmephisto] (7-JUL-2017)
#  Message update about disabling Browser Acceleration
# [SomeGuy42] (28-JUN-2017)
#  Wine 2.5-staging => 2.11-staging
#  Blizzard app v1.8.3.8965
#  Diablo 3 Patch 2.6.0.46006
#  win10 => winxp  
#    fixes blizzard app display bug but complains of future support
#    futre alternative is ie8 but doesnt solve initial login window issue
#    my testing shows winxp gives better performance (+~10fps)
# [SomeGuy42] (09-APR-2017)
#  Wine 2.0-rc3-staging => 2.5-staging
#   2.5 has many preinstalled components and should make the install simpler/more stable
#  Blizzard app v1.8.0.8600  (formerly Battle.net)
#  Diablo 3 Patch 2.5.0.44247
# [RavonTUS] (06-JAN-2017)
#  added Dependencies to improve the install
#  Wine 1.7.15 => 2.0-rc3-staging
#  Battle.Net Patch 1.5.2.8180
#  Diablo 3 Patch 2.4.3 (64-bit Client)
#  NVidia GeForce GTX 960/PCIe/SSE2
#  AMD FX(tm)-6300 Six-Core Processor × 6
# [SomeGuy42] (2016-11-22)
#   Wine 1.7.15 => 1.9.23
#   Battle.net Patch 1.5.2 Build 8142
#   Diablo 3  v2.4.2.41394
#   Notes: install tweaked for D3 performance
# [petch] (2014-03-24)
#   Wine 1.5.5-DiabloIII_v3 => 1.7.15 (DarkNekros)
# [SuperPlumus] (2013-06-08 17-14)
#   gettext + clean
   
[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"
   
TITLE="Diablo III"
WORKING_WINE_VERSION="3.2"
EDITOR="Blizzard Entertainment Inc."
EDITOR_URL="http://www.blizzard.com"
PREFIX="DiabloIII_64"
AUTHOR="SomeGuy42, RavonTUS, and the POL Community"
   
POL_GetSetupImages "http://files.playonlinux.com/resources/setups/$PREFIX/top.jpg" "http://files.playonlinux.com/resources/setups/$PREFIX/left.jpg" "$TITLE"
POL_SetupWindow_Init
POL_SetupWindow_SetID 1195
POL_Debug_Init
   
POL_Debug_Message "Starting Install -----------------------------"
POL_SetupWindow_presentation "$TITLE" "$EDITOR" "$EDITOR_URL" "$AUTHOR" "$PREFIX"
   
POL_System_SetArch "x64"
POL_System_TmpCreate "$PREFIX"
   
POL_SetupWindow_message "$(eval_gettext 'NOTICE: This will install the Blizzard application first and configure the settings for Diablo 3.')"
   
POL_Debug_Message "Downloading Install File -------------"
cd "$POL_System_TmpDir"
# Battle.net now has a universal installer with language selection at start
#POL_Download "https://www.battle.net/download/getInstallerForGame?os=win&version=LIVE&gameProgram=BATTLENET_APP/Battle.net-Setup.exe"
POL_Download "https://www.battle.net/download/getInstallerForGame?os=win&version=LIVE&gameProgram=DIABLO_3/Diablo-III-Setup.exe"
#SetupIs="$POL_System_TmpDir/Battle.net-Setup.exe"
SetupIs="$POL_System_TmpDir/Diablo-III-Setup.exe"
   
# Removed the DVD option as it has a really old installer and game files and isn't worth using IMHO
   
POL_Debug_Message "Creating Wine Install ------------------------"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WORKING_WINE_VERSION"
   
POL_Debug_Message "Setting Wine Variables -----------------------"
Set_OS "win7"
# Updated Overrides, many of wine's dlls are up to spec now and diablo has even removed some of their own. 
POL_Wine_OverrideDLL "native,builtin" "vcruntime140"
POL_Wine_OverrideDLL "native,builtin" "msvcp140"
POL_Wine_OverrideDLL "native,builtin" "ucrtbase" 

  
# Updated dependancies, Most no longer needed due to wine 2.0 (07-APR-2017)
#POL_Call POL_Install_Physx
 
   
POL_Debug_Message "Running Install File -------------------------"
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$SetupIs"
   
POL_SetupWindow_VMS "1024"
POL_System_TmpDelete
   
POL_Debug_Message "Creating Shortcut ----------------------------"
POL_Shortcut "Battle.net Launcher.exe"  "$TITLE" "" "" "Game"
# Remove crashing SystemSurvey (17-FEB-2018)
rm "$HOME/.PlayOnLinux/wineprefix/DiabloIII_32/drive_c/Program\ Files/Battle.net/*/SystemSurvey.exe"
   
POL_Debug_Message "Install Completed ----------------------------"
   
POL_SetupWindow_message "$(eval_gettext 'Blizzard application Installation Complete')\n\n$(eval_gettext 'IMPORTANT: Login to the Blizzard app by using the email and password entries near the bottom of the login window, not the nice looking ones near the top. You may also want to check the box for Keep Me Always Loged In. Then login to Blizzard and install the Diablo III game files.')\n\n$(eval_gettext 'IMPORTANT: You may have to go to settings and disable browser acceleration, this often fixes display issues.')"
 
POL_SetupWindow_Close
exit 0
