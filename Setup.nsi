; Installer for Open Teradata Viewer 0.3b
;
; This script is written in NSIS language.
;
; author: D. Campione

;--------------------------------

!define PRODUCT_NAME "Open Teradata Viewer"
!define PRODUCT_VERSION "0.3b"
!define PRODUCT_PUBLISHER "Open Source Community"
!define PRODUCT_WEB_SITE "http://openteradata.sourceforge.net"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\open_teradata_viewer_0.3b.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "install.ico"
!define MUI_UNICON "uninst.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "license.txt"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Open Teradata Viewer"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\open_teradata_viewer_0.3b.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "open_teradata_viewer_0.3b_setup.exe"
InstallDir "$PROGRAMFILES\Open Teradata Viewer"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "Required files" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "open_teradata_viewer_0.3b.exe"
  File "readme.txt"
  File "terajdbc4.jar"
  File "english_dic.zip"
  File "groovy-all-3.0.0-alpha-1.jar"
  File "rhino-1.7.10.jar"

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Open Teradata Viewer.lnk" "$INSTDIR\open_teradata_viewer_0.3b.exe"
  CreateShortCut "$DESKTOP\Open Teradata Viewer.lnk" "$INSTDIR\open_teradata_viewer_0.3b.exe"
  CreateShortCut "$QUICKLAUNCH\Open Teradata Viewer.lnk" "$INSTDIR\open_teradata_viewer_0.3b.exe" "" "$INSTDIR\open_teradata_viewer_0.3b.exe" 0
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "Optional files" SEC02
  File "kunststoff.jar"
  File "liquidlnf.jar"

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "Macros" SEC03
  SetOutPath "$INSTDIR\macros\"
  SetOverwrite ifnewer
  File "macros\Groovy___open_file.groovy"
  File "macros\Groovy___order_lines.groovy"
  File "macros\Groovy___order_lines_remove_duplicates.groovy"
  File "macros\JavaScript___escape_html_characters.js"
  File "macros\JavaScript___open_file.js"
  File "macros\JavaScript___order_lines_remove_duplicates.js"

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -AdditionalIcons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\open_teradata_viewer_0.3b.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\open_teradata_viewer_0.3b.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function .onInit
  InitPluginsDir
  File "/oname=$PluginsDir\spltmp.bmp" "C:\Users\dcampione\Documents\Progetti personali\Applicazioni Standalone\Open Teradata Viewer\File utili\logo.bmp"

; optional
  File "/oname=$PluginsDir\spltmp.wav" "C:\Users\dcampione\Documents\Progetti personali\Applicazioni Standalone\Open Teradata Viewer\File utili\my_splashsound.wav"

  advsplash::show 1000 600 400 -1 $PluginsDir\spltmp

  Pop $0 ; $0 has '1' if the user closed the splash screen early,
         ; '0' if everything closed normally, and '-1' if some error occurred.
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) has been completely removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\english_dic.zip"
  Delete "$INSTDIR\liquidlnf.jar"
  Delete "$INSTDIR\kunststoff.jar"
  Delete "$INSTDIR\terajdbc4.jar"
  Delete "$INSTDIR\readme.txt"
  Delete "$INSTDIR\groovy-all-3.0.0-alpha-1.jar"
  Delete "$INSTDIR\rhino-1.7.10.jar"
  Delete "$INSTDIR\macros\*"
  Delete "$INSTDIR\open_teradata_viewer_0.3b.exe"

  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Website.lnk"
  Delete "$DESKTOP\Open Teradata Viewer.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Open Teradata Viewer.lnk"
  Delete "$QUICKLAUNCH\Open Teradata Viewer.lnk"

  RMDir "$SMPROGRAMS\$ICONS_GROUP"
  RMDir "$INSTDIR\macros"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd