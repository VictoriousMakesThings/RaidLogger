# RaidLogger
RaidLogger is a simple World of Warcraft Classic addon that takes a snapshot of the raid members, their class and world buffs into a CSV format for exportation into spreadsheets and other tools.

## Installation
Create the RaidLogger folder in your `World of Warcraft\_classic_\Interface\AddOns` directory. Download `main.lua` and `RaidLogger.toc` to the folder that you create. After that, restart your WoW if it is currently open.

The default way to use it in-game is to run the following script, which you can set up a macro for: `/run raid_snapshot(true,"\n",",")`

After running the above code, a window will pop up which will let you Ctrl-C the entire text dump, so that you can paste it elsewhere. This automates the process of extracting raid member information, reducing the chances of input errors.

The function signature is as follows:
```
raid_snapshot(verbose, delimeter1, delimeter2)`
  -- verbose: give more information
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","
```
You can change the delimeters to do things such as tab separation if that is more suitable.
