// OpenMBU Autosplitter
// For OpenMBU beta 1.11 or newer
// by thearst3rd


state("MBUltra") {}
state("MBUltra64") {}
state("MBUltra_DEBUG") {}
state("MBUltra64_DEBUG") {}
state("MBUltra_OPTIMIZEDDEBUG") {}
state("MBUltra64_OPTIMIZEDDEBUG") {}


startup
{
	List<String> levels = new List<string>()
	{
		null, "Learning to Roll", "Moving Up", "Gem Collection", "Frictional Concerns", "Triple Gravity", "Bridge Crossing", "Bunny Slope", "Hazardous Climb", "First Flight", "Marble Melee Primer", "Pitfalls", "Gravity Helix", "Platform Party", "Early Frost", "Winding Road", "Skate Park", "Ramp Matrix", "Half-Pipe", "Jump Jump Jump!", "Upward Spiral",
		"Mountaintop Retreat", "Urban Jungle", "Gauntlet", "Around the World", "Skyscraper", "Timely Ascent", "Duality", "Sledding", "The Road Less Traveled", "Aim High", "Points of the Compass", "Obstacle Course", "Fork in the Road", "Great Divide", "Black Diamond", "Skate to the Top", "Spelunking", "Whirl", "Hop Skip and a Jump", "Tree House",
		"Divergence", "Slick Slide", "Ordeal", "Daedalus", "Survival of the Fittest", "Ramps Reloaded", "Cube Root", "Scaffold", "Acrobat", "Endurance", "Battlements", "Three-Fold Maze", "Half-Pipe Elite", "Will o' Wisp", "Under Construction", "Extreme Skiing", "Three-Fold Race", "King of the Mountain", "Natural Selection", "Schadenfreude",
	};

	settings.Add("splitBeginner", true, "Split on finishing Beginner levels");
	settings.CurrentDefaultParent = "splitBeginner";

	for (int i = 1; i <= 20; i++)
		settings.Add("split" + i, true, i + ": " + levels[i]);

	settings.CurrentDefaultParent = null;
	settings.Add("splitIntermediate", true, "Split on finishing Intermediate levels");
	settings.CurrentDefaultParent = "splitIntermediate";

	for (int i = 21; i <= 40; i++)
		settings.Add("split" + i, true, i + ": " + levels[i]);

	settings.CurrentDefaultParent = null;
	settings.Add("splitAdvanced", true, "Split on finishing Advanced levels");
	settings.CurrentDefaultParent = "splitAdvanced";

	for (int i = 41; i <= 60; i++)
		settings.Add("split" + i, true, i + ": " + levels[i]);

	settings.CurrentDefaultParent = null;
	settings.Add("splitUnknown", false, "Split on finishing unknown level");

	settings.Add("splitEggs", false, "Split on collecting easter eggs");
	settings.CurrentDefaultParent = "splitEggs";

	// These order of these reflects the in-game order of the levels, but the egg indices do not follow that order
	settings.Add("splitEgg1", true, "Learning to Roll");
	settings.Add("splitEgg2", true, "Gem Collection");
	settings.Add("splitEgg3", true, "First Flight");
	settings.Add("splitEgg4", true, "Ramp Matrix");
	settings.Add("splitEgg5", true, "Upward Spiral");
	settings.Add("splitEgg6", true, "Mountaintop Retreat");
	settings.Add("splitEgg7", true, "Urban Jungle");
	settings.Add("splitEgg8", true, "Obstacle Course");
	settings.Add("splitEgg9", true, "Fork in the Road");
	settings.Add("splitEgg11", true, "Black Diamond");
	settings.Add("splitEgg12", true, "Whirl");
	settings.Add("splitEgg10", true, "Hop Skip and a Jump");
	settings.Add("splitEgg15", true, "Ordeal");
	settings.Add("splitEgg14", true, "Daedalus");
	settings.Add("splitEgg17", true, "Scaffold");
	settings.Add("splitEgg13", true, "Battlements");
	settings.Add("splitEgg19", true, "Three-Fold Maze");
	settings.Add("splitEgg18", true, "Will o' Wisp");
	settings.Add("splitEgg16", true, "King of the Mountain");
	settings.Add("splitEgg20", true, "Natural Selection");

	// Configure which levels the timer will start on.
	settings.CurrentDefaultParent = null;
	settings.Add("startTimer", true, "Start timer automatically on level start");
	settings.CurrentDefaultParent = "startTimer";

	for (int i = 1; i <= 60; i++)
	{
		bool defaultValue = i % 20 == 1;
		char letter = (i > 40 ? 'A' : (i > 20 ? 'I' : 'B'));
		settings.Add("start" + i, defaultValue, String.Format("{0}{1}: {2}", letter, i, levels[i]));
	}

	settings.Add("startUnknown", false, "Unknown level");
}


init
{
	vars.doStart = false;
	vars.doSplit = false;
	vars.isLoading = false;
	vars.gameJustStarted = true;
	timer.IsGameTimePaused = true; // On init, it sets this to false. We want it to stay true in case of a game crash

	print("Opening OpenMBU autosplitter file");
	String path = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
	path = Path.Combine(path, "GarageGames", "Marble Blast Ultra", "autosplitter.txt");
	print("OpenMBU Autosplitter path: " + path);
	// Wait for file to exist (timeout after some time)
	for (int i = 1; i < 120; i++)
	{
		if (!File.Exists(path))
			Thread.Sleep(1000);
	}
	FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);

	vars.streamReader = new StreamReader(fs);

	// Clear out old data
	print("Discarding: " + vars.streamReader.ReadToEnd());
}


update
{
	String line;
	while ((line = vars.streamReader.ReadLine()) != null)
	{
		print("OpenMBU autosplitter got line: " + line);
		if (line.StartsWith("start"))
		{
			vars.gameJustStarted = false;
			timer.IsGameTimePaused = false;
			if (!settings.StartEnabled || (timer.CurrentPhase != TimerPhase.NotRunning))
				continue;
			String[] words = line.Split(' ');
			int levelNum;
			if (words.Length > 1 && int.TryParse(words[1], out levelNum) && levelNum >= 1 && levelNum <= 60)
				vars.doStart = settings["start" + levelNum];
			else
				vars.doSplit = settings["startUnknown"];
		}
		else if (line.StartsWith("loading started"))
		{
			vars.isLoading = true;
		}
		else if (line.StartsWith("loading finished"))
		{
			vars.isLoading = false;
		}
		else
		{
			if (!settings.SplitEnabled
					|| timer.CurrentPhase == TimerPhase.NotRunning
					|| timer.CurrentPhase == TimerPhase.Ended)
				continue;
			if (line.StartsWith("finish"))
			{
				String[] words = line.Split(' ');
				int levelNum;
				if (words.Length > 1 && int.TryParse(words[1], out levelNum) && levelNum >= 1 && levelNum <= 60)
					vars.doSplit = settings["split" + levelNum];
				else
					vars.doSplit = settings["splitUnknown"];
			}
			else if (line.StartsWith("egg"))
			{
				String[] words = line.Split(' ');
				int eggNum;
				if (words.Length > 1 && int.TryParse(words[1], out eggNum) && eggNum >= 1 && eggNum <= 20)
					vars.doSplit = settings["splitEgg" + eggNum];
			}
		}
	}
}


start
{
	if (vars.doStart)
	{
		vars.doStart = false;
		return true;
	}
	return false;
}


split
{
	if (vars.doSplit)
	{
		vars.doSplit = false;
		return true;
	}
	return false;
}


isLoading
{
	return vars.isLoading || vars.gameJustStarted;
}


exit
{
    timer.IsGameTimePaused = true; // Pause the timer if the game closes
}
