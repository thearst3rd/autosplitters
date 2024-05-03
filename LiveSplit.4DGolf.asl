/*
 * Autosplitter for 4D Golf
 * 4D Golf by CodeParade
 * Autosplitter by thearst3rd
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
		//var str = helper.GetClass("mscorlib", "String");

		var gs = helper.GetClass("Assembly-CSharp", "GameState");
		var b4 = helper.GetClass("Assembly-CSharp", "Ball4D");
		var b5 = helper.GetClass("Assembly-CSharp", "Ball5D");
		var ps = helper.GetClass("Assembly-CSharp", "PlayerState");
		//var mb = helper.GetClass("Assembly-CSharp", "MonoBehavior");

		vars.Unity.Make<int>(gs.Static, gs["courseTypeIx"]).Name = "courseTypeIx";
		vars.Unity.Make<int>(gs.Static, gs["playModeIx"]).Name = "playModeIx";
		vars.Unity.Make<int>(gs.Static, gs["holeIx"]).Name = "holeIx";
		//vars.Unity.MakeString(gs.Static, gs["selectedCourse"]).Name = "selectedCourse";
		//vars.Unity.MakeArray<object>(gs.Static, gs["players"]).Name = "playerStates";
		vars.Log("selectedCourse: " + gs["selectedCourse"]);

		// Borked :(
		//vars.Unity.Make<bool>(gs.Static, gs["activeBall4D"], b4["sinking"]).Name = "ball4DSinking";

		// So it stops complaining
		vars.Unity.Update();
		old.courseTypeIx = vars.Unity["courseTypeIx"].Current;
		old.playModeIx = vars.Unity["playModeIx"].Current;
		old.holeIx = vars.Unity["holeIx"].Current;
		//old.selectedCourse = vars.Unity["selectedCourse"].Current;
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

	current.courseTypeIx = vars.Unity["courseTypeIx"].Current;
	current.playModeIx = vars.Unity["playModeIx"].Current;
	current.holeIx = vars.Unity["holeIx"].Current;
	//current.selectedCourse = vars.Unity["selectedCourse"].Current;

	string newScene = vars.Unity.Scenes.Active.Name;
	if (newScene != "")
		current.Scene = newScene;

	if (current.playModeIx != old.playModeIx)
		vars.Log("playModeIx changed!! " + old.playModeIx + " -> " + current.playModeIx);

	if (current.courseTypeIx != old.courseTypeIx)
		vars.Log("courseTypeIx changed!! " + old.courseTypeIx + " -> " + current.courseTypeIx);

	if (current.holeIx != old.holeIx)
		vars.Log("holeIx changed!! " + old.holeIx + " -> " + current.holeIx);

	//if (current.selectedCourse != old.selectedCourse)
	//	vars.Log("selectedCourse changed!! " + old.selectedCourse + " -> " + current.selectedCourse);

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
	// TODO
	return false;
}

isLoading
{
	//return vars.Unity.IsLoading; // Not found for some reason?
	return vars.Unity.Scenes.Count != 1;
}

exit
{
	vars.Unity.Reset();
}

shutdown
{
	vars.Unity.Reset();
}
