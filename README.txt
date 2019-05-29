# quiksizzler
A tool for Invisible, Inc. modding that automatically assembles the mod files to build the newest version.

Place this in the main mod directory (where you hold modinfo and scripts.zip)
This file builds a new version of your mod. It takes files from <mod folder>\scripts and puts them into scripts.zip; also updates modinfo.txt with a new version number. On top of that, prompts user to launch the KWAD builder, and if it does, automatically puts the resulting .kwads into the mod folder.
  
List of things the Quiksizzler cares about:
<0> Must be in the main mod directory
REFERENCE: mod directory path looks like "...InvisibleInc\mods\<yourmod>\"
<1> Must have modinfo.txt with a version line (like the default)
...if not, QS will make a placeholder file for it
<2> Must have a \scripts subfolder within the directory, to be zipped
...if not, QS won't be able to zip mod files
<3> Must have KWAD builder as a build.bat file in a folder named "KWAD builder" somewhere in either
1)InvisibleInc folder;
2)Desktop;
3)InvisibleIncModUploader folder (any subfolders within those folders are fine too)
...if not, QS will skip building KWADs.
...and if there are multiple KWAD builders found, the directories listed here are the priority order.
