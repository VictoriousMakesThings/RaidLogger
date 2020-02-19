# RaidLogger
RaidLogger is a simple Classic WoW addon that dumps the raid members into CSV format for easy exportation into spreadsheets and other tools. It includes additional functions such as raid composition and world buff snapshots.

## Installation
Create a RaidLogger folder in your `World of Warcraft\_classic_\Interface\AddOns` directory. Add `main.lua` and `RaidLogger.toc` to the folder that you create. After that, restart WoW.

The default way to use it in-game is to use the following, which I suggest setting up a macro for: `/run raid_export(false,true,false,"\n",",")`

After running the above code, a window will pop up which will let you Ctrl-C the entire text dump, so that you can paste it elsewhere. This automates the process of extracting raid member information, reducing the chances of input errors.

You can do more with the raid_export function. The function signature is as follows:
```
raid_export(verbose, extra, classes, delimeter1, delimeter2)`
  -- verbose: drops a message into a raid
  -- extra: prepends CSV with metadata consisting of zone and date
  -- classes: appends each line with delimeter2, followed by class
  -- delimeter1: end of line delimeter, usually just "\n"
  -- delimeter2: secondary separator for same-line separation, usually just ","
```
