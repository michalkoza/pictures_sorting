on isOptionKeyPressed()
	return (do shell script "/usr/bin/python -c 'import Cocoa; print Cocoa.NSEvent.modifierFlags() & Cocoa.NSAlternateKeyMask > 1'") is "True"
end isOptionKeyPressed

global bornDay
global kidName
global testMode
local picFolder

on nextMonth(dd)
	copy dd to d
	set originalDay to d's day
	set d's day to 32
	set d's day to 1
	return d
end nextMonth

on prevMonth(dd)
	copy dd to d
	set d's day to 1
	set d to d - 1 * days
	set d's day to 1
	return d
end prevMonth

on theSplit(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end theSplit

on twoDigit(i)
	tell (100 + i) as string to text 2 thru 3
end twoDigit

on makeFolder(newFolder, baseFolder)
	display dialog "start makeFolder" & return & newFolder & return & baseFolder
	tell application "Finder"
		if exists (folder (newFolder as string) of (baseFolder as alias)) then
			#display dialog "ex"
			log (POSIX path of baseFolder & "/" & newFolder & " already exists")
		else
			#display dialog "not"
			make new folder at baseFolder as alias with properties {name:newFolder}
			log ("Making the folder" & POSIX path of baseFolder & "/" & newFolder)
		end if
	end tell
	display dialog "done makeFolder"
end makeFolder

on getDestFolder(myFile)
	log bornDay
	set dateDelim to "_"
	set {d, _} to my theSplit(myFile, " ")
	set {picYear, picMonth, picDay} to my theSplit(d as string, "-")
	set picDateString to picDay & "/" & picMonth & "/" & picYear
	set picDate to date picDateString
	
	copy picDate to startDate
	copy picDate to endDate
	if picDay as integer < bornDay then
		set startDate to prevMonth(picDate)
		set startDate's day to bornDay
		
		set endDate's day to bornDay
		set endDate to endDate - 1 * days
	else
		set startDate's day to bornDay
		
		set endDate to nextMonth(picDate)
		set endDate's day to bornDay
		set endDate to endDate - 1 * days
	end if
	set startYear to startDate's year
	set startMonth to twoDigit(startDate's month)
	set startDay to twoDigit(startDate's day)
	set endYear to endDate's year
	set endMonth to twoDigit(endDate's month)
	set endDay to twoDigit(endDate's day)
	set res to {startYear, startYear & dateDelim & startMonth & dateDelim & startDay & "-" & endYear & dateDelim & endMonth & dateDelim & endDay & dateDelim & kidName as string}
	#display dialog item 2 of res
	#display notification res
	return res
	#log (exists my picFolder & ":" & startYear & ":" & startYear & "_" & myMonth & "_" & my bornDay & "-" & myYear & "_" & myMonth + 1 & "_" & (my bornDay) - 1 as alias)
end getDestFolder

on runn(_bornDay, _kidName, _picFolder)
	set bornDay to _bornDay
	set kidName to _kidName
	set picFolder to _picFolder
	set testMode to true
	
	display notification "Checking modifier keys"
	repeat while isOptionKeyPressed()
	end repeat
	display notification "Release modifier keys"
	
	tell application "System Events"
		if not (exists folder picFolder) then
			display dialog "pic folder not exists" & picFolder
			error number -128
		end if
	end tell
	
	tell application "Finder"
		set theItems to selection
		#display dialog number of theItems
		repeat with itemRef in theItems
			#display dialog name of itemRef as string
			set {yearFolder, destFolderName} to my getDestFolder(name of itemRef as string)
			#log (not (exists folder destFolder of (picFolder as alias)))
			#log (POSIX path of picFolder)
			#display dialog yearFolder #& "/" & destFolderName
			#display dialog destFolderName
			
			my makeFolder(yearFolder, picFolder)
			set yearFolderPath to picFolder & ":" & yearFolder
			
			my makeFolder(destFolderName, yearFolderPath)
			set destFolderPathAlias to yearFolderPath & ":" & destFolderName as alias
			
			tell application "System Events" to keystroke (ASCII character 31)
			move itemRef to destFolderPathAlias
			repeat while (exists itemRef)
				delete itemRef
			end repeat
		end repeat
	end tell
end runn