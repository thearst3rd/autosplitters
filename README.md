# Autosplitters

## OpenMBU

Autosplitter for [OpenMBU Beta 1.11 or newer](https://openmbu.com/download/all). Since OpenMBU Beta 1.11, we generate an autosplitter text file which can be tailed and will be populated with data that will drive the LiveSplit autosplitter script.

### Features

* Auto start is supported. The the timer will automatically start when you select a level.
* Automatic splits are supported on level completion and easter egg collection.
	* These splits are completely configurable. You can choose on which levels or easter eggs you want the autosplitter to perform a split.
* Load removal is supported and will take out any load times from the "Game Time" in LiveSplit.
	* **NOTE**: As of now, runs are still timed using _real time_ until more people use the autosplitter to determine if the load remover is sufficient. So, if this feature is to be used, make sure you're aware of what time is being displayed by the timer so you can submit in RTA. This may change in the future.

## Marble Blast Gold

Autosplitter for [Marble Blast Gold 1.4.1 non-ignition](https://marbleblast.com/index.php/downloads/mbg). Also works with the [framerate unlocker](https://marbleblast.com/index.php/forum/mb-mods-misc/7696-marble-blast-frame-rate-unlocker). It's still a bit WIP and might have a few bugs, so please report any issues you may have with it.

Thanks to CaptainRektbeard for tremendous help in getting the $Game::State variable stable in the autosplitter!

### Features

* Auto start is supported. The timer will automatically start when you select a level.
* Auto split is supported on completing levels.
	* You can configure which levels you'd like it to split, if you don't want all 100.
