set mychoice to (choose from list {"Option 1", "Option 2", "Option 3"} with prompt "Please select which sound you like best" default items "None" OK button name {"Play"} cancel button name {"Cancel"})
-- choose from list cancel button returns false, not -128, as do other choose syntax do.
if mychoice is false then error number -128 -- user canceled