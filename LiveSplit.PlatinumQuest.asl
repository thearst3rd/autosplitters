// RTA Autosplitter for PlatinumQuest
// by thearst3rd

state("marbleblast") {}

startup
{
	vars.Log = (Action<object>)((output) => print("[PlatinumQuest ASL] " + output));
	// TODO add settings
}

init
{
	vars.Log("Sigscan for RTAAutosplitter");
	var rtaModule = modules.Where(m => m.ModuleName == "RTAAutosplitter.dll").First();
	var scanner = new SignatureScanner(game, rtaModule.BaseAddress, rtaModule.ModuleMemorySize);

	IntPtr ptr = scanner.Scan(new SigScanTarget(Encoding.ASCII.GetBytes("pqrtaas_abcdefg")));
	vars.Log("RTAAutosplitter pointer found at: " + ptr);

	vars.isEnabled = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x10));
	vars.isDone = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x11));
	vars.shouldStartRun = new MemoryWatcher<bool>(new DeepPointer(ptr + 0x12));
	// 19-23 are reserved

	vars.time = new MemoryWatcher<long>(new DeepPointer(ptr + 0x18));

	vars.currentMission = new StringWatcher(new DeepPointer(ptr + 0x20, 0), 255);

	vars.watchers = new MemoryWatcherList() {
		vars.isEnabled,
		vars.isDone,
		vars.shouldStartRun,
		vars.time,
		vars.currentMission
	};
}

update
{
	vars.watchers.UpdateAll(game);

	String debugStr = String.Format("isEnabled: {0} | isDone: {1} | shouldStartRun: {2} | time: {3} | currentMission: \"{4}\"", vars.isEnabled.Current, vars.isDone.Current, vars.shouldStartRun.Current, vars.time.Current, vars.currentMission.Current);

	vars.Log(debugStr);
}
