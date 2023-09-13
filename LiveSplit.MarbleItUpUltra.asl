// Marble It Up! Ultra Autosplitter
// Based on the original Marble It Up! autosplitter by TalentedPlatinum and Ero
// Modified to work with Marble It Up! Ultra by thearst3rd

state("Marble It Up") {}

startup
{
	vars.Log = (Action<object>)(output => print("[MIUU ASL] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");

	Dictionary<string, string[]> chapters = new Dictionary<string, string[]>
	{
		{ "Chapter 1: Get Moving", new[]
			{
				"Learning to Roll",
				"Learning to Turn",
				"Bunny Slope",
				"Learning to Jump",
				"Full Speed Ahead",
				"Treasure Trove",
				"Stay Frosty",
				"Round the Bend",
				"Leaf on the Wind",
			}
		},
		{ "Chapter 2: The Subtle Joy of Rolling", new[]
			{
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
			}
		},
		{ "Chapter 3: Focus on Flow", new[]
			{
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
			}
		},
		{ "Chapter 4: Kick It Up a Notch", new[]
			{
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
			}
		},
		{ "Chapter 5: Show Me What You Got", new[]
			{
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
			}
		},
		{ "Chapter 6: Play for Keeps", new[]
			{
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
			}
		},
		{ "Bonus 1: Keep on Rolling", new[]
			{
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
			}
		},
		{ "Bonus 2: The Way of the Marble", new[]
			{
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
			}
		},
		{ "Bonus 3: Keep Your Cool", new[]
			{
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
			}
		},
		{ "Bonus 4: Challenge Accepted", new[]
			{
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
			}
		},
	};

	settings.Add("split_level", true, "Split on level finishes");
	foreach (KeyValuePair<string, string[]> chapter in chapters)
	{
		string chapterLevelCategory = "chapterlevel_" + chapter.Key;
		settings.Add(chapterLevelCategory, true, chapter.Key, "split_level");
		foreach (string level in chapter.Value)
			settings.Add("level_" + level, true, level, chapterLevelCategory);
	}
	settings.Add("unknown_level", true, "Other/custom level", "split_level");

	settings.Add("start_timer", true, "Start timer on level start");
	foreach (KeyValuePair<string, string[]> chapter in chapters)
	{
		string chapterStartCategory = "chapterstart_" + chapter.Key;
		settings.Add(chapterStartCategory, true, chapter.Key, "start_timer");
		for (int i = 0; i < chapter.Value.Length; i++)
		{
			string level = chapter.Value[i];
			settings.Add("start_" + level, i == 0, level, chapterStartCategory);
		}
	}
	settings.Add("unknown_start", true, "Other/custom level", "start_timer");

	/*
	// TODO: figure out splitting on treasures
	settings.Add("split_treasure", false, "Split on Treasure Box collection");
	foreach (KeyValuePair<string, string[]> chapter in chapters)
	{
		string chapterTreasureCategory = "chaptertreasure_" + chapter.Key;
		settings.Add(chapterTreasureCategory, true, chapter.Key, "split_level");
		foreach (string level in chapter.Value)
			settings.Add("treasure_" + level, true, level, chapterTreasureCategory);
	}
	settings.Add("unknown_treasure", true, "Other/custom level", "start_timer");
	*/
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var str = helper.GetClass("mscorlib", "String");

		var ls = helper.GetClass("Assembly-CSharp", "LevelSelect");
		var lm = helper.GetClass("Assembly-CSharp", "LevelManager");
		var miuLvl = helper.GetClass("Assembly-CSharp", "MIU.MarbleLevel");

		var mm = helper.GetClass("Assembly-CSharp", "MarbleManager");
		var mc = helper.GetClass("Assembly-CSharp", "MarbleController");

		vars.Unity.MakeString(128, lm.Static, lm["CurrentLevel"], miuLvl["name"], str["m_firstChar"]).Name = "level";
		vars.Unity.Make<bool>(ls.Static, ls["loading"]).Name = "loading";
		vars.Unity.Make<int>(mm.Static, mm["instance"], mm["Player"], mc["Mode"]).Name = "mode";

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

	current.Level = vars.Unity["level"].Current;
	current.Loading = vars.Unity["loading"].Current;
	current.Mode = vars.Unity["mode"].Current;

	if (current.Level != old.Level)
	{
		vars.Log("Changing to level: " + current.Level);
		// Warn cuz I'm probably a dumbass
		if (!settings.ContainsKey("level_" + current.Level))
			vars.Log("Note, this is an unknown level");
	}
}

start
{
	if (current.Loading && !old.Loading)
	{
		vars.Log("Began loading");
		bool shouldStart;
		if (settings.ContainsKey("start_" + current.Level))
			shouldStart = settings["start_" + current.Level];
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
	if (old.Mode == 1 && current.Mode == 4)
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
			if (settings.ContainsKey("level_" + current.Level))
				shouldSplit = settings["level_" + current.Level];
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
