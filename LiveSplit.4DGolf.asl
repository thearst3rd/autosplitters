/*
 * Autosplitter for 4D Golf
 * 4D Golf by CodeParade
 * Autosplitter by thearst3rd and Derko
 * asl-help by Ero
 */

state("4D Golf") {}

startup {
	vars.Log = (Action<object>)(output => print("[4DGolfASL] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;

	Dictionary<string, string> courseNames = new Dictionary<string, string> {
		{ "Forest", "Evergreens" },
		{ "Sand", "Dunes" },
		{ "Snow", "Arctic" },
		{ "Abstract", "Mezzanine" },
		{ "Lava", "Inferno" },
		{ "Space", "Nebula" },
		{ "5D", "Beyond" },
	};

	Dictionary<string, string[]> levelNames = new Dictionary<string, string[]> {
		{ "Forest", new[] {"First Hole", "Where's The Hole?", "Bumpers", "Simple Slopes", "Hole in the Wall", "Curves", "Rolling Hills", "Thread The Needle", "Tilt at Windmills",
				"Cylinders", "Trefoil", "Staircase", "Conics", "Bridge the Gap", "Pizza Time", "Labyrinth", "Baffles", "Marathon"} },
		{ "Sand", new[] {"Banked Turns", "Golden Spikes", "Ruins", "Climbing", "Ramping Up", "Shortcut", "Sand Pits", "Cubed", "Lost Pyramid",
				"Winding Road", "Up the Trail", "On The Edge", "Tetra-Block", "Viper", "Hiking Over It", "Oasis", "Skipping Stones", "The Altar"} },
		{ "Snow", new[] {"Big Air", "Ice Skating", "Alpine Loop", "Leaps and Bounds", "Tilted", "Quarter Pipe", "Pachinko", "Half-Pipe", "Igloo",
				"Drop in the Bucket", "Icicle", "Horseshoe", "Slip & Slide", "The Tube", "Off The Wall", "Wall Ride", "Slalom", "Ski Ramps"} },
		{ "Abstract", new[] {"Elevator Pitch", "Kinetic Art", "Moving Target", "Pop Art", "Carousel", "Expressionism", "Speed Painting", "Double Rotation", "Magnum Opus",
				"Pointillism", "Juxtaposition", "Camera Obscura", "Avant-Garde", "Pinball Wizard", "Graffiti", "Motion Pictures", "Mixed Media", "Cubism"} },
		{ "Lava", new[] {"Fissure", "Banked Danger", "Slow And Steady", "Gears", "Safety First", "Rocky Road", "Bedrock", "Cascade", "Volcano",
				"Off the Rails", "Pipeline", "Knockout", "Burning CDs", "Incinerator", "Descend", "Fire Pit", "Junkyard", "Vortex"} },
		{ "Space", new[] {"Gecko", "Escape Velocity", "Moon Bounce", "Mobius", "UFOs", "Anti-Gravity", "Planetary Rings", "Perspective", "Wormhole",
				"Shooting Star", "Blue Moon", "Spaced Out", "3-Sphere", "Pulsar", "Cosmic String", "Hypercube", "Quantum Tunnel", "Total Eclipse"} },
		{ "5D", new[] {"Beyond?", "5D Turns", "Tesseract Cage", "Blocked Chakra", "Turn, Turn, Turn", "Spirit Bridge", "Manifest", "Mandala", "5D Chess",
				"Loopholes", "Cosmic Leap", "Lucid", "Liminal", "Seeking Balance", "Delirium", "Tsunami", "Synchronicity", "Of Madness"} },
	};

	settings.Add("split_hole", true, "Split on finishing a hole");
	foreach (string course in new[] {"Forest", "Sand", "Snow", "Abstract", "Lava", "Space", "5D"}) { // Specify again to guarantee correct order
		string courseKey = "course_" + course;
		settings.Add(courseKey, true, courseNames[course], "split_hole");
		for (int i = 0; i < 9; i++)
			settings.Add(courseKey + "_" + i, true, levelNames[course][i], courseKey);
		courseKey += "_challenge";
		settings.Add(courseKey, true, courseNames[course] + " Challenge", "split_hole");
		for (int i = 0; i < 9; i++)
			settings.Add(courseKey + "_" + i, true, levelNames[course][i + 9], courseKey);
	}

	vars.DetermineSetting = (Func<string, int, string>)delegate(string course, int holeIx) {
		if (course.EndsWith("2")) {
			return "course_" + course.Substring(0, course.Length - 1) + "_challenge_" + holeIx;
		}
		if (course.EndsWith("3")) {
			if (holeIx >= 9)
				return "course_" + course.Substring(0, course.Length - 1) + "_challenge_" + (holeIx - 9);
			else
				return "course_" + course.Substring(0, course.Length - 1) + "_" + holeIx;
		}
		return "course_" + course + "_" + holeIx;
	};
}

init {
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper => {
		var str = helper.GetClass("mscorlib", "String");

		var gs = helper.GetClass("Assembly-CSharp", "GameState");
		var b4 = helper.GetClass("Assembly-CSharp", "Ball4D");
		var b5 = helper.GetClass("Assembly-CSharp", "Ball5D");
		var mm = helper.GetClass("Assembly-CSharp", "MainMenu");
		var cs = helper.GetClass("Assembly-CSharp", "Course");
		var hp = helper.GetClass("Assembly-CSharp", "HoleParams");

		if (b4["sinking"] != b5["sinking"]) {
			// ruh roh... might bork on 5D levels!
			vars.Log("Warning, Ball4D sinking (" + b4["sinking"] + ") is not the same as Ball5D sinking (" + b5["sinking"] + ")!!! 5D levels might be broken");
		}

		vars.Unity.Make<int>(gs.Static, gs["holeIx"]).Name = "holeIx";
		vars.Unity.MakeString(128, gs.Static, gs["selectedCourse"], str["_firstChar"]).Name = "selectedCourse";

		vars.Unity.Make<int>(gs.Static, gs["balls"]).Name = "balls"; // Array of balls. This gets created the moment you press play
		vars.Unity.Make<bool>(gs.Static, gs["balls"], 0x20, b4["sinking"]).Name = "ballSinking"; // thearst3rd: where does 0x20 come from?

		vars.Unity.Make<bool>(mm.Static, mm["skipToGameMenu"]).Name = "skipToGameMenu"; // Is true when loading the main menu from a course
		vars.Unity.Make<bool>(cs.Static, 0x10).Name = "isLevelLoaded"; // Is true when the level is loaded (thearst3rd - where does 0x10 come from?)

		vars.Unity.MakeString(128, gs.Static, gs["selectedSingleHole"], hp["course"], str["_firstChar"]).Name = "selectedSingleHoleCourse";
		// For whatever reason, it can't find the named fields for the rest of these? Manually putting in the fields offsets
		vars.Unity.MakeString(128, gs.Static, gs["selectedSingleHole"], /*hp["path"]*/ 0x18, str["_firstChar"]).Name = "selectedSingleHolePath";
		vars.Unity.Make<bool>(gs.Static, gs["selectedSingleHole"], /*hp["isCustom"]*/ 0x28).Name = "selectedSingleHoleIsCustom";

		// So it stops complaining
		vars.Unity.Update();
		old.holeIx = vars.Unity["holeIx"].Current;
		old.selectedCourse = vars.Unity["selectedCourse"].Current;
		old.balls = vars.Unity["balls"].Current;
		old.ballSinking = vars.Unity["ballSinking"].Current;
		old.skipToGameMenu = vars.Unity["skipToGameMenu"].Current;
		old.isLevelLoaded = vars.Unity["isLevelLoaded"].Current;
		old.selectedSingleHoleCourse = vars.Unity["selectedSingleHoleCourse"].Current;
		old.selectedSingleHolePath = vars.Unity["selectedSingleHolePath"].Current;
		old.selectedSingleHoleIsCustom = vars.Unity["selectedSingleHoleIsCustom"].Current;
		old.Scene = vars.Unity.Scenes.Active.Name;

		return true;
	});

	vars.Unity.Load(game);
}

update {
	if (!vars.Unity.Loaded)
		return false;

	vars.Unity.Update();

	current.holeIx = vars.Unity["holeIx"].Current;
	current.selectedCourse = vars.Unity["selectedCourse"].Current;
	current.balls = vars.Unity["balls"].Current;
	current.ballSinking = vars.Unity["ballSinking"].Current;
	current.skipToGameMenu = vars.Unity["skipToGameMenu"].Current;
	current.isLevelLoaded = vars.Unity["isLevelLoaded"].Current;
	current.selectedSingleHoleCourse = vars.Unity["selectedSingleHoleCourse"].Current;
	current.selectedSingleHolePath = vars.Unity["selectedSingleHolePath"].Current;
	current.selectedSingleHoleIsCustom = vars.Unity["selectedSingleHoleIsCustom"].Current;

	string newScene = vars.Unity.Scenes.Active.Name;
	if (newScene != "")
		current.Scene = newScene;

	if (current.holeIx != old.holeIx)
		vars.Log("holeIx changed!! " + old.holeIx + " -> " + current.holeIx);

	if (current.selectedCourse != old.selectedCourse)
		vars.Log("selectedCourse changed!! \"" + old.selectedCourse + "\" -> \"" + current.selectedCourse + "\"");

	if (current.selectedSingleHoleCourse != old.selectedSingleHoleCourse)
		vars.Log("selectedSingleHoleCourse changed!! \"" + old.selectedSingleHoleCourse + "\" -> \"" + current.selectedSingleHoleCourse + "\"");

	if (current.selectedSingleHolePath != old.selectedSingleHolePath)
		vars.Log("selectedSingleHolePath changed!! \"" + old.selectedSingleHolePath + "\" -> \"" + current.selectedSingleHolePath + "\"");

	if (current.selectedSingleHoleIsCustom != old.selectedSingleHoleIsCustom)
		vars.Log("selectedSingleHoleIsCustom changed!! " + old.selectedSingleHoleIsCustom + " -> " + current.selectedSingleHoleIsCustom + "");

	if (current.Scene != old.Scene)
		vars.Log("Scene changed!! \"" + old.Scene + "\" -> \"" + current.Scene + "\"");
}

start {
	if (old.Scene == "MainMenu" && (current.Scene == "Level4D" || current.Scene == "Level5D")) {
		vars.Log("Transition from " + old.Scene + " to " + current.Scene + ", START!");
		return true;
	}
	return false;
}

split {
	if (current.ballSinking && !old.ballSinking) {
		vars.Log("Level finish detected on " + current.selectedCourse + " hole " + current.holeIx);
		string settingToCheck = vars.DetermineSetting(current.selectedCourse, current.holeIx);
		vars.Log("Checking setting: " + settingToCheck);
		if (settings[settingToCheck]) {
			vars.Log("SPLIT!");
			return true;
		}
	}
	return false;
}

isLoading {
	return (current.balls != 0 && !current.isLevelLoaded && !current.ballSinking) || current.skipToGameMenu;
}

exit {
	vars.Unity.Reset();
}

shutdown {
	vars.Unity.Reset();
}
