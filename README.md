# OpenMBU Autosplitter

Autosplitter for OpenMBU beta 1.11 or newer. Since OpenMBU beta 1.11, we generate an autosplitter text file which can be tailed and will be populated with data that will drive the LiveSplit autosplitter script.

### Supported

* Auto start is supported. If `start` is enabled, then the timer will automatically start when you select a level.
* Automatic splits are supported on level completion and easter egg collection.
	* These splits are completely configurable. You can choose on which levels or easter eggs you want the autosplitter to perform a split.
* Load removal is supported and will take out any load times from the "Game Time" in LiveSplit.
	* **NOTE**: As of now, runs are still timed using _real time_ until more people use the autosplitter to determine if the load remover is sufficient. So, if this feature is to be used, make sure you're aware of what time is being displayed by the timer so you can submit in RTA. This may change in the future.
