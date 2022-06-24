// Marble Blast Gold Autosplitter
// Supports MBG 1.4.1 non-ignited
// by thearst3rd


state("marbleblast")
{
	string100 levelFilename : 0x297ABA;

	// Location of a value which is used to calculate a dynamic offset for $Game::State
	int stateOffset : 0x299868, 0x710, 0x4, 0x4, 0x1C, 0x18, 0x1080;
}

startup
{
	vars.Log = (Action<object>)((output) => print("[Marble Blast Gold ASL] " + output));
}

init
{
	old.gameState = ""; // This just prevents an error on the first update cycle 
}

update
{
	// -- Update gameState
	// Calculate the offset
	int offset = ((int)(current.stateOffset / 2) / 2) % 0xEB;

	// Plug in the offset and get a pointer to $Game::State
	IntPtr gameStatePtr;
	new DeepPointer(game.MainModule.BaseAddress+0x294A84, offset * 4, 0x0c, 0x00).DerefOffsets(game, out gameStatePtr);

	// Read the string
	current.gameState = game.ReadString(gameStatePtr, 16);

	if(current.gameState != old.gameState){
		vars.Log("State Updated: " + current.gameState);
	}
}


start
{
	if (current.levelFilename.StartsWith("/data/missions/") && !old.levelFilename.StartsWith("/data/missions/"))
		return true;
}


split
{
	if (current.gameState == "End" && old.gameState != "End")
		return true;
}
