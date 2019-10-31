set picFolder to "Volumes:mk_green:_MyData:MEDIA:My Pictures"
set myFile to "2016-01-11 18.12.42.jpg"
set myScript to load script "Macintosh HD:Users:mkoza:Documents:scripts:pictures_sorting:photo_cleaner.scpt" as alias
set {ye, scriptResult} to myScript's getDestFolder(myFile, 1, "", picFolder)
display dialog scriptResult