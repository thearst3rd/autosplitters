// Marble It Up! Ultra Autosplitter
// Based on the original Marble It Up! autosplitter by TalentedPlatinum and Ero
// Modified to work with Marble It Up! Ultra by thearst3rd

state("Marble It Up") {}

startup
{
	vars.Log = (Action<object>)(output => print("[MIUU ASL] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(Path.Combine("Components", "UnityASL.bin"))).CreateInstance("UnityASL.Unity");

	string[] chapterNames = {
		"Chapter 1: Get Moving",
		"Chapter 2: The Subtle Joy of Rolling",
		"Chapter 3: Focus on Flow",
		"Chapter 4: Kick It Up a Notch",
		"Chapter 5: Show Me What You Got",
		"Chapter 6: Play for Keeps",
		"Bonus 1: Keep on Rolling",
		"Bonus 2: The Way of the Marble",
		"Bonus 3: Keep Your Cool",
		"Bonus 4: Challenge Accepted",
	};

	string[][] levelNames = new[]
	{
		new[] {
			"Learning to Roll",
			"Learning to Turn",
			"Bunny Slope",
			"Learning to Jump",
			"Full Speed Ahead",
			"Treasure Trove",
			"Stay Frosty",
			"Round the Bend",
			"Leaf on the Wind",
		},
		new[] {
			"Duality",
			"Learning to Bounce",
			"Great Wall",
			"Carom",
			"Rush Hour",
			"Over the Garden Wall",
			"Into the Arctic",
			"Wave Pool",
			"Big Easy",
			"Transit",
			"Gravity Knot",
			"Stepping Stones",
		},
		new[] {
			"Speedball",
			"Mount Marblius",
			"Transmission",
			"Archipelago",
			"Sugar Rush",
			"Slalom",
			"Outskirts",
			"Off Kilter",
			"Icy Ascent",
			"Bad Company",
			"Totally Tubular",
			"Overclocked",
		},
		new[] {
			"Tether",
			"Aqueduct",
			"Ricochet",
			"Braid",
			"Sun Spire",
			"Thunderdrome",
			"Hyperloop",
			"Gearing Up",
			"Acrophobia",
			"Rime",
			"Cog Valley",
			"Citadel",
		},
		new[] {
			"Newton's Cradle",
			"Ex Machina",
			"Gearheart",
			"Kleinsche",
			"Dire Straits",
			"Diamond in the Sky",
			"Glacier",
			"Shift",
			"Conduit",
			"Flip the Table",
			"Energy",
			"Mobius Madness",
		},
		new[] {
			"Amethyst",
			"Rondure",
			"Isaac's Apple",
			"Penrose Pass",
			"Siege",
			"Flywheel",
			"Symbiosis",
			"Tesseract",
			"Leaps and Bounds",
			"Vertigo",
			"Tossed About",
			"Apogee",
		},
		new[] {
			"Rosen Bridge",
			"Onward and Upward",
			"Permutation",
			"Elevator Action",
			"Time Capsule",
			"Triple Divide",
			"Four Stairs",
			"The Need for Speed",
			"River Vantage",
			"Gravity Cube",
			"Epoch",
			"Platinum Playground",
		},
		new[] {
			"Ribbon",
			"Castle Chaos",
			"Thread the Needle",
			"Gordian",
			"Bumper Invasion",
			"Bash-tion",
			"Runout",
			"Archiarchy",
			"Crystalline Matrix",
			"Stayin' Alive",
			"Medieval Machinations",
			"The Pit of Despair",
		},
		new[] {
			"Contraption",
			"Uphill Both Ways",
			"Retrograde Rally",
			"Warp Core",
			"Cross Traffic",
			"Prime",
			"Halfpipe Heaven",
			"Wanderlust",
			"Boomerang",
			"Kendama",
			"Cirrus",
			"Zenith",
		},
		new[] {
			"All Downhill From Here",
			"Danger Zone",
			"Olympus",
			"Head in the Clouds",
			"Centripetal Force",
			"Slick Shtick",
			"Network",
			"Radius",
			"Escalation",
			"Torque",
			"Tangle",
			"Stratosphere",
		},
	};

	settings.Add("split_level", true, "Split on level finishes");
	for (int i = 0; i < chapterNames.Length; i++)
	{
		string chapterLevelCategory = "chapterlevel_" + i;
		settings.Add(chapterLevelCategory, true, chapterNames[i], "split_level");
		for (int j = 0; j < levelNames[i].Length; j++)
			settings.Add("level_" + i + "_" + j, true, levelNames[i][j], chapterLevelCategory);
	}
	settings.Add("unknown_level", true, "Other/custom level", "split_level");

	settings.Add("start_timer", true, "Start timer on level start");
	for (int i = 0; i < chapterNames.Length; i++)
	{
		string chapterStartCategory = "chapterstart_" + i;
		settings.Add(chapterStartCategory, true, chapterNames[i], "start_timer");
		for (int j = 0; j < levelNames[i].Length; j++)
			settings.Add("start_" + i + "_" + j, j == 0, levelNames[i][j], chapterStartCategory);
	}
	settings.Add("unknown_start", true, "Other/custom level", "start_timer");

	/*
	// TODO: figure out splitting on treasures
	settings.Add("split_treasure", false, "Split on Treasure Box collection");
	for (int i = 0; i < chapterNames.Length; i++)
	{
		string chapterTreasureCategory = "chaptertreasure_" + i;
		settings.Add(chapterTreasureCategory, true, chapterNames[i], "split_level");
		for (int j = 0; j < levelNames[i].Length; j++)
			settings.Add("treasure_" + i + "_" + j, true, levelNames[i][j], chapterTreasureCategory);
	}
	settings.Add("unknown_treasure", true, "Other/custom level", "start_timer");
	*/
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		/*
		var str = helper.GetClass("mscorlib", "String");

		var ls = helper.GetClass("Assembly-CSharp", "LevelSelect");
		var lm = helper.GetClass("Assembly-CSharp", "LevelManager");
		var miuLvl = helper.GetClass("Assembly-CSharp", "MIU.MarbleLevel");

		var mm = helper.GetClass("Assembly-CSharp", "MarbleManager");
		var mc = helper.GetClass("Assembly-CSharp", "MarbleController");
		*/

		var SpeedrunData = helper.GetClass("Assembly-CSharp", "SpeedrunData");
		//vars.Log("Type of SpeedrunData: " + typeof(SpeedrunData));

		/*
		vars.Unity.MakeString(128, lm.Static, lm["CurrentLevel"], miuLvl["name"], str["m_firstChar"]).Name = "level";
		vars.Unity.Make<bool>(ls.Static, ls["loading"]).Name = "loading";
		vars.Unity.Make<int>(mm.Static, mm["instance"], mm["Player"], mc["Mode"]).Name = "mode";
		*/

		vars.Unity.Make<long>(SpeedrunData.Static, SpeedrunData["magicnumber"]).Name = "magicnumber";
		//vars.Unity.Make<int>(SpeedrunData.Static, SpeedrunData["levelState"]).Name = "levelState";
		//vars.Unity.Make<int>(SpeedrunData.Static, SpeedrunData["chapterID"]).Name = "chapterID";
		//vars.Unity.Make<int>(SpeedrunData.Static, SpeedrunData["levelID"]).Name = "levelID";

		return true;
	});

	vars.Unity.Load(game);

	vars.lastTimeFinished = 0;
}

update
{
	if (!vars.Unity.Loaded)
		return false;

	vars.Unity.Update();

	// Sanity check
	//if (vars.Unity["magicnumber"].Current != 0x1337133713371337)
	//	vars.Log("Warning, magic number not correct: " + vars.Unity["magicnumber"].Current);

	current.LevelState = vars.Unity["levelState"].Current;
	current.ChapterId = vars.Unity["chapterID"].Current;
	current.LevelId = vars.Unity["levelID"].Current;


	// Alert on changes
	if (current.LevelState != old.LevelState)
		vars.Log("Changing levelState: " + current.LevelState);

	if (current.ChapterId != old.ChapterId)
		vars.Log("Changing to new chapter: " + current.ChapterId);

	if (current.LevelId != old.LevelId)
		vars.Log("Changing to level: " + current.LevelId);
}

start
{
	if (current.LevelState == 0 && old.LevelState != 0)
	{
		vars.Log("Began loading");
		bool shouldStart;
		string settingKey = "start_" + current.ChapterId + "_" + current.LevelId;
		if (settings.ContainsKey(settingKey))
			shouldStart = settings[settingKey];
		else
			shouldStart = settings["unknown_start"];
		if (shouldStart)
		{
			vars.Log("Starting run");
			return true;
		}
	}
	return false;
}

split
{
	if (current.LevelState == 1 && current.LevelState != 1)
	{
		vars.Log("Level finished");
		long time = Stopwatch.GetTimestamp();
		if (time <= vars.lastTimeFinished + Stopwatch.Frequency) // Make sure 1s has passed
		{
			vars.Log("But not enough time passed!");
		}
		else
		{
			bool shouldSplit;
			string settingKey = "level_" + current.ChapterId + "_" + current.LevelId;
			if (settings.ContainsKey(settingKey))
				shouldSplit = settings[settingKey];
			else
				shouldSplit = settings["unknown_level"];
			if (shouldSplit)
			{
				vars.Log("Spltting");
				vars.lastTimeFinished = time;
				return true;
			}
		}
	}
	return false;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}
