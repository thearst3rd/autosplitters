/*
 * Autosplitter for 4D Golf
 * 4D Golf by CodeParade
 * Autosplitter by thearst3rd and Derko
 * asl-help by Ero
 */

state("4D Golf") {}

startup
{
	vars.Log = (Action<object>)(output => print("[4DGolfASL] " + output));
	vars.Unity = Assembly.Load(File.ReadAllBytes(@"Components\UnityASL.bin")).CreateInstance("UnityASL.Unity");
	vars.Unity.LoadSceneManager = true;
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		var str = helper.GetClass("mscorlib", "String");

		var gs = helper.GetClass("Assembly-CSharp", "GameState");
		var b4 = helper.GetClass("Assembly-CSharp", "Ball4D");
		var b5 = helper.GetClass("Assembly-CSharp", "Ball5D");
		var mm = helper.GetClass("Assembly-CSharp", "MainMenu");
		var cs = helper.GetClass("Assembly-CSharp", "Course");

		if (b4["sinking"] != b5["sinking"])
		{
			// ruh roh... might bork on 5D levels!
			vars.Log("Warning, Ball4D sinking (" + b4["sinking"] + ") is not the same as Ball5D sinking (" + b5["sinking"] + ")!!! 5D levels might be broken");
		}

		vars.Unity.Make<int>(gs.Static, gs["holeIx"]).Name = "holeIx";
		vars.Unity.MakeString(128, gs.Static, gs["selectedCourse"], str["_firstChar"]).Name = "selectedCourse";

		vars.Unity.Make<int>(gs.Static, gs["balls"]).Name = "balls"; // Array of balls. This gets created the moment you press play
		vars.Unity.Make<bool>(gs.Static, gs["balls"], 0x20, b4["sinking"]).Name = "ballSinking"; // thearst3rd: where does 0x20 come from?

		vars.Unity.Make<bool>(mm.Static, mm["skipToGameMenu"]).Name = "skipToGameMenu"; // Is true when loading the main menu from a course
		vars.Unity.Make<bool>(cs.Static, 0x10).Name = "isLevelLoaded"; // Is true when the level is loaded (thearst3rd - where does 0x10 come from?)

		// So it stops complaining
		vars.Unity.Update();
		old.holeIx = vars.Unity["holeIx"].Current;
		old.selectedCourse = vars.Unity["selectedCourse"].Current;
		old.balls = vars.Unity["balls"].Current;
		old.ballSinking = vars.Unity["ballSinking"].Current;
		old.skipToGameMenu = vars.Unity["skipToGameMenu"].Current;
		old.isLevelLoaded = vars.Unity["isLevelLoaded"].Current;
		old.Scene = vars.Unity.Scenes.Active.Name;

		return true;
	});

	vars.Unity.Load(game);
}

update
{
	if (!vars.Unity.Loaded)
		return false;

	vars.Unity.Update();

	current.holeIx = vars.Unity["holeIx"].Current;
	current.selectedCourse = vars.Unity["selectedCourse"].Current;
	current.balls = vars.Unity["balls"].Current;
	current.ballSinking = vars.Unity["ballSinking"].Current;
	current.skipToGameMenu = vars.Unity["skipToGameMenu"].Current;
	current.isLevelLoaded = vars.Unity["isLevelLoaded"].Current;

	string newScene = vars.Unity.Scenes.Active.Name;
	if (newScene != "")
		current.Scene = newScene;

	if (current.holeIx != old.holeIx)
		vars.Log("holeIx changed!! " + old.holeIx + " -> " + current.holeIx);

	if (current.selectedCourse != old.selectedCourse)
	{
		vars.Log("selectedCourse changed!! " + old.selectedCourse + " -> " + current.selectedCourse);
		vars.Log(vars.Unity["selectedCourse"].GetType());
	}

	if (current.Scene != old.Scene)
		vars.Log("Scene changed!! \"" + old.Scene + "\" -> \"" + current.Scene + "\"");
}

start
{
	if (old.Scene != "MainMenu")
		return false;
	return current.Scene == "Level4D" || current.Scene == "Level5D";
}

split
{
	return current.ballSinking && !old.ballSinking;
}

isLoading
{
	return (current.balls != 0 && !current.isLevelLoaded && !current.ballSinking) || current.skipToGameMenu;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}
