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

	IntPtr ptr = scanner.Scan(new SigScanTarget(Encoding.ASCII.GetBytes("pq_rta_as_abcdef")));
	vars.Log("RTAAutosplitter pointer found at: " + ptr);

	vars.isEnabled = new MemoryWatcher<bool>(new DeepPointer(ptr + 20));
	vars.isDone = new MemoryWatcher<bool>(new DeepPointer(ptr + 21));
	vars.shouldStartRun = new MemoryWatcher<bool>(new DeepPointer(ptr + 22));

	vars.time = new MemoryWatcher<long>(new DeepPointer(ptr + 24)); // TODO endianness seems wrong here according to print statement

	vars.watchers = new MemoryWatcherList() {
		vars.isEnabled,
		vars.isDone,
		vars.shouldStartRun,
		vars.time
	};
}

update
{
	vars.watchers.UpdateAll(game);

	String debugStr = String.Format("isEnabled: {0} | isDone: {1} | shouldStartRun: {2} | time: {3}", vars.isEnabled.Current, vars.isDone.Current, vars.shouldStartRun.Current, vars.time.Current);

	vars.Log(debugStr);
}
