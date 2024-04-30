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
}

init
{
	vars.Unity.TryOnLoad = (Func<dynamic, bool>)(helper =>
	{
		//var str = helper.GetClass("mscorlib", "String");

		var gs = helper.GetClass("Assembly-CSharp", "GameState");
		var b4 = helper.GetClass("Assembly-CSharp", "Ball4D");
		var b5 = helper.GetClass("Assembly-CSharp", "Ball5D");

		vars.Unity.Make<int>(gs.Static, gs["courseTypeIx"]).Name = "courseTypeIx";
		vars.Unity.Make<int>(gs.Static, gs["playModeIx"]).Name = "playModeIx";

		// Borked :(
		//vars.Unity.Make<bool>(gs.Static, gs["activeBall4D"], b4["sinking"]).Name = "ball4DSinking";

		// So it stops complaining
		vars.Unity.Update();
		old.courseTypeIx = vars.Unity["courseTypeIx"].Current;
		old.playModeIx = vars.Unity["playModeIx"].Current;

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

	if (current.playModeIx != old.playModeIx)
	{
		vars.Log("playModeIx changed!! " + old.playModeIx + " -> " + current.playModeIx);
	}

	if (current.courseTypeIx != old.courseTypeIx)
	{
		vars.Log("courseTypeIx changed!! " + old.courseTypeIx + " -> " + current.courseTypeIx);
	}
}

start
{
	// TODO
	return false;
}

split
{
	// TODO
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
