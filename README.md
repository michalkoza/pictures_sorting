# Setup
This repository contains a bunch of applescripts. It should be cloned to ~/Library/Services in order to be able to use them as system services e.g. easily bind keyboard shortcuts to them.

## pictures_sorting
Tool to sort images on a Mac

### Intended usage scenario:
You have a folder with unsorted pictures/videos/files named according to pattern `yyyy-mm-dd HH.MM.SS.extension` - this is the case for Dropbox's `Camera Uploads` folder. You preview the pictures in Finder and for each image hit a proper keyboard shortcut in order to move it to proper folder in defined location (e.g. external hard drive).

### Repository content
The main worker script is `photo_cleaner.scpt`
Other scripts are just runners calling it with appropriate arguments.

### Setup example
In **Preferences** ->**Keyboard** -> **Shortcuts** -> **Services** you can set up shortcuts to trigger **workflows** which are treaded as system services.

### Sorting algorithm
Pictures are grouped in folders spanning across one month each.
Worker script expects 3 arguments:

* threshold month day number
* destination folder name sufix
* root destination folder path

####Example
When run with arguments `(11, Family, /Volumes/mydrive/MEDIA/Pictures)`
the following files would be put to the following folders: 

* `2017-04-21 12:12:12.jpg` -> `/Volumes/mydrive/MEDIA/Pictures/Family/2017_04_11-2017_05_10_Family/`
* `2016-12-21 12:12:12.jpg` -> `/Volumes/mydrive/MEDIA/Pictures/Family/2016_12_11-2017_01_10_Family/`
* `2017-04-11 12:12:12.jpg` -> `/Volumes/mydrive/MEDIA/Pictures/Family/2017_04_11-2017_05_10_Family/`
* `2017-04-10 12:12:12.jpg` -> `/Volumes/mydrive/MEDIA/Pictures/Family/2017_03_11-2017_04_10_Family/`
