:: Assumes running from EquineBuild\build
mkdir out\EquineBuild
copy ..\extension.xml out\EquineBuild\
copy ..\readme.txt out\EquineBuild\
mkdir out\EquineBuild\graphics\icons
copy ..\graphics\icons\equine_build_icon.png out\EquineBuild\graphics\icons\
mkdir out\EquineBuild\scripts
copy ..\scripts\equine_build.lua out\EquineBuild\scripts\
cd out
CALL ..\zip-items EquineBuild
rmdir /S /Q EquineBuild\
copy EquineBuild.zip EquineBuild.ext
cd ..
explorer .\out
