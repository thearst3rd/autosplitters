// RTA Autosplitter for PlatinumQuest
// by thearst3rd

state("marbleblast") {}

startup {
	vars.Log = (Action<object>)((output) => print("[PlatinumQuest ASL] " + output));

	// TODO add more settings
	settings.Add("split_new_category", false, "Split on start of new category");
	settings.Add("split_new_game", false, "Split on start of new game");
}

init {
	vars.Log("Sigscan for RTAAutosplitter");
	var rtaModule = modules.Where(m => m.ModuleName == "RTAAutosplitter.dll").First();
	var scanner = new SignatureScanner(game, rtaModule.BaseAddress, rtaModule.ModuleMemorySize);

	IntPtr ptr = scanner.Scan(new SigScanTarget(Encoding.ASCII.GetBytes("pqrtaas_abcdefg")));
	vars.Log("RTAAutosplitter pointer found at: " + ptr);

	vars.isEnabled = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x10));
	vars.isDone = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x11));
	vars.shouldStartRun = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x12));
	// 0x13-17 are reserved

	vars.time = new MemoryWatcher<long>(new DeepPointer(ptr + 0x18));
	vars.lastSplitTime = new MemoryWatcher<long>(new DeepPointer(ptr + 0x20));
	vars.missionTypeBeganTime = new MemoryWatcher<long>(new DeepPointer(ptr + 0x28));
	vars.currentGameBeganTime = new MemoryWatcher<long>(new DeepPointer(ptr + 0x30));

	vars.currentMission = new StringWatcher(new DeepPointer(ptr + 0x20, 0), 255);

	vars.watchers = new MemoryWatcherList() {
		vars.isEnabled,
		vars.isDone,
		vars.shouldStartRun,
		vars.time,
		vars.lastSplitTime,
		vars.missionTypeBeganTime,
		vars.currentGameBeganTime,
		vars.currentMission
	};
}

update {
	vars.watchers.UpdateAll(game);
}

isLoading {
	return true;
}

gameTime {
	long time = vars.time.Current;
	if (vars.lastSplitTime.Current > 0 && vars.lastSplitTime.Changed) {
		time = vars.lastSplitTime.Current;
	} else if (vars.currentGameBeganTime.Changed) {
		time = vars.currentGameBeganTime.Current;
	} else if (vars.missionTypeBeganTime.Changed) {
		time = vars.missionTypeBeganTime.Current;
	}
	return TimeSpan.FromMilliseconds(time);
}

reset {
	return !vars.isEnabled.Current && !vars.isDone.Current;
}

split {
	if (vars.isDone.Changed && vars.isDone.Current)
		return true;
	if (vars.lastSplitTime.Changed && vars.lastSplitTime.Current > 0) {
		// TODO check against the current mission
		return true;
	}
	if (settings["split_new_category"] && vars.missionTypeBeganTime.Changed && vars.missionTypeBeganTime.Current > 0)
		return true;
	else if (settings["split_new_game"] && vars.currentGameBeganTime.Changed && vars.currentGameBeganTime.Current > 0)
		return true;
}

start {
	return vars.isEnabled.Current;
}
