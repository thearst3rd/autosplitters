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

	vars.ExtractLevelName = (Func<string, string>)((levelFilename) => levelFilename.Split('/')[4].Split('.')[0]);
	vars.ExtractLevelType = (Func<string, string>)((levelFilename) => levelFilename.Split('/')[3]);

	Dictionary<string, List<string>> levelNames = new Dictionary<string, List<string>>();
	levelNames.Add("beginner", new List<string>() {
		"movement", "gems", "jumping", "powerjump",
		"platform", "superspeed", "elevator", "airmove", 
		"copter", "timetrial", "bounce", "gravity",
		"shock", "backagain", "friction", "bumpers",
		"ductfan", "mine", "trapdoor", "tornado",
		"pitfall", "platformparty", "windingroad", "finale"
	});
	levelNames.Add("intermediate", new List<string>() {
		"jumpjumpjump", "racequalifying", "skatepark", "rampmatrix",
		"hoops", "goforgreen", "forkinroad", "tritwist",
		"marbletris", "spaceslide", "skeeball", "playground",
		"hopskipjump", "highroadlowroad", "halfpipe", "gauntlet",
		"motomarblecross", "shockdrop", "forkinroad2", "greatdivide",
		"thewave", "tornado", "racetrack", "upward"
	});
	levelNames.Add("advanced", new List<string>() {
		"thrillride", "tree", "fan_lift", "leapoffaith",
		"highway", "steppingstones", "obstacle", "compasspoints",
		"3foldmaze", "tubetreasure", "slipslide", "skyscraper",
		"halfpipe2", "a-maze-ing", "blockparty", "trapdoor",
		"moebius", "greatdivide2", "3foldmaze2", "tothemoon",
		"aroundtheworld", "willowisp", "twisting", "survival",
		"plumbing", "siege", "ski", "reloaded",
		"towermaze", "freefall", "acrobat", "whorl",
		"mudslide", "pipedreams", "scaffold", "airwalk",
		"shimmy", "leastresist", "daedalus", "ordeal",
		"battlements", "pinball", "eyeofthestorm", "dive",
		"tightrope", "selection", "tango", "icarus",
		"construction", "pathways", "darwin", "kingofthemountain"
	});

	Func<string, string> TitleCase = (Func<string, string>)((input) =>
		input.Substring(0, 1).ToUpper() + input.Substring(1).ToLower());

	foreach(string missionType in levelNames.Keys)
	{
		settings.Add(missionType, true, TitleCase(missionType) + " Levels");
		for(int i=0;i<levelNames[missionType].Count;i++)
		{
			string levelName = levelNames[missionType][i];
			settings.Add(missionType + "_" + levelName, true, (i+1) + " - " + TitleCase(levelName), missionType);
		}
	}
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

	if(current.levelFilename.StartsWith("/data/missions/") && current.levelFilename != old.levelFilename){
		vars.Log("Entering level: " + vars.ExtractLevelType(current.levelFilename) + " - " + vars.ExtractLevelName(current.levelFilename));
	}
}


start
{
	if (current.levelFilename.StartsWith("/data/missions/") && !old.levelFilename.StartsWith("/data/missions/"))
		return true;
}


split
{
	if (current.gameState == "End" && old.gameState != "End"){
		string settingName = vars.ExtractLevelType(current.levelFilename) + "_" + vars.ExtractLevelName(current.levelFilename);
		vars.Log(settingName);
		return settings[settingName];
	}
}
