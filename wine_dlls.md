# ubuntu通过wine安装Tim

winetricks -V
20180217


wine --version
wine-2.16


### 32位软件安装方式
env WINEARCH=win32 WINEPREFIX=~/.wine32 winetricks ie6
### 64位软件安装方式
env WINEARCH=win64 WINEPREFIX=~/.wine winetricks ie6

### 相关命令
winetricks dlls list | grep 已缓存 | awk '{printf "%s ", $1}'

### 安装dlls
winetricks amstream atmlib d3dcompiler_43 d3drm d3dx10 d3dx10_43 d3dx11_42 d3dx11_43 d3dx9 d3dx9_24 d3dx9_25 d3dx9_26 d3dx9_27 d3dx9_28 d3dx9_29 d3dx9_30 d3dx9_31 d3dx9_32 d3dx9_33 d3dx9_34 d3dx9_35 d3dx9_36 d3dx9_37 d3dx9_38 d3dx9_39 d3dx9_40 d3dx9_41 d3dx9_42 d3dx9_43 d3dxof devenum dinput dinput8 directmusic directplay directx9 dmsynth dotnet20 dotnet40 dotnet45 dotnet46 dpvoice dsdmo dsound dxdiag dxdiagn esent gdiplus hid ie6 ie7 l3codecx mdx mf mfc40 msasn1 msftedit msls31 mspatcha msxml4 pdh qdvd qedit quartz riched20 riched30 secur32 usp10 vcrun2005 vcrun2008 vcrun2015 webio winhttp wininet xact xinput xmllite

> 以上dlls安装完后基本可以完美运行tim
