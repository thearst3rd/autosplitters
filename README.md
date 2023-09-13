# Autosplitters

## OpenMBU

Autosplitter for [OpenMBU Beta 1.11 or newer](https://openmbu.com/download/all). Since OpenMBU Beta 1.11, we generate an autosplitter text file which can be tailed and will be populated with data that will drive the LiveSplit autosplitter script.

### Features

* Auto start is supported. The the timer will automatically start when you select the first level in a category.
	* The levels that will start the timer are configurable.
* Automatic splits are supported on level completion and easter egg collection.
	* These splits are completely configurable. You can choose on which levels or easter eggs you want the autosplitter to perform a split.
* Load removal is supported and will take out any load times from the "Game Time" in LiveSplit.
	* In the event of a game crash, time will also be paused until a level is resumed.

## Marble Blast Gold

Autosplitter for [Marble Blast Gold 1.4.1 non-ignition](https://marbleblast.com/index.php/downloads/mbg). Also works with the [framerate unlocker](https://marbleblast.com/index.php/forum/mb-mods-misc/7696-marble-blast-frame-rate-unlocker). It's still a bit WIP and might have a few bugs, so please report any issues you may have with it.

Thanks to CaptainRektbeard for tremendous help in getting the $Game::State variable stable in the autosplitter!

### Features

* Auto start is supported. The timer will automatically start when you select a level.
* Auto split is supported on completing levels.
	* You can configure which levels you'd like it to split, if you don't want all 100.

## PlatinumQuest

Autosplitter for a currently-in-development version of [PlatinumQuest](https://marbleblast.com/index.php/downloads/pq) which includes a built-in RTA speedrunning mode.

## Marble It Up! Ultra

Autosplitter for [Marble It Up! Ultra](https://marbleitup.com/). Based on the [autosplitter for Marble It Up! Classic](https://github.com/TalentedPlatinum/AutoSplitters/blob/main/MarbleItUp.asl) by TalentedPlatinum and Ero.

### Features

* Auto start is supported upon starting a level.
	* The levels which start the timer are configurable.
* Auto split is supported on level completion.
	* The levels which will cause a split are configurable.
