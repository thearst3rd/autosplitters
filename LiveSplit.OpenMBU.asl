// OpenMBU Autosplitter


state("MBUltra") {}
state("MBUltra64") {}
state("MBUltra_DEBUG") {}
state("MBUltra64_DEBUG") {}
state("MBUltra_OPTIMIZEDDEBUG") {}
state("MBUltra64_OPTIMIZEDDEBUG") {}


startup
{
	settings.Add("splitBeginner", true, "Split on finishing Beginner levels");
	settings.CurrentDefaultParent = "splitBeginner";

	settings.Add("split1", true, "1: Learning to Roll");
	settings.Add("split2", true, "2: Moving Up");
	settings.Add("split3", true, "3: Gem Collection");
	settings.Add("split4", true, "4: Frictional Concerns");
	settings.Add("split5", true, "5: Triple Gravity");
	settings.Add("split6", true, "6: Bridge Crossing");
	settings.Add("split7", true, "7: Bunny Slope");
	settings.Add("split8", true, "8: Hazardous Climb");
	settings.Add("split9", true, "9: First Flight");
	settings.Add("split10", true, "10: Marble Melee Primer");
	settings.Add("split11", true, "11: Pitfalls");
	settings.Add("split12", true, "12: Gravity Helix");
	settings.Add("split13", true, "13: Platform Party");
	settings.Add("split14", true, "14: Early Frost");
	settings.Add("split15", true, "15: Winding Road");
	settings.Add("split16", true, "16: Skate Park");
	settings.Add("split17", true, "17: Ramp Matrix");
	settings.Add("split18", true, "18: Half-Pipe");
	settings.Add("split19", true, "19: Jump Jump Jump!");
	settings.Add("split20", true, "20: Upward Spiral");

	settings.CurrentDefaultParent = null;
	settings.Add("splitIntermediate", true, "Split on finishing Intermediate levels");
	settings.CurrentDefaultParent = "splitIntermediate";

	settings.Add("split21", true, "21: Mountaintop Retreat");
	settings.Add("split22", true, "22: Urban Jungle");
	settings.Add("split23", true, "23: Gauntlet");
	settings.Add("split24", true, "24: Around the World");
	settings.Add("split25", true, "25: Skyscraper");
	settings.Add("split26", true, "26: Timely Ascent");
	settings.Add("split27", true, "27: Duality");
	settings.Add("split28", true, "28: Sledding");
	settings.Add("split29", true, "29: The Road Less Traveled");
	settings.Add("split30", true, "30: Aim High");
	settings.Add("split31", true, "31: Points of the Compass");
	settings.Add("split32", true, "32: Obstacle Course");
	settings.Add("split33", true, "33: Fork in the Road");
	settings.Add("split34", true, "34: Great Divide");
	settings.Add("split35", true, "35: Black Diamond");
	settings.Add("split36", true, "36: Skate to the Top");
	settings.Add("split37", true, "37: Spelunking");
	settings.Add("split38", true, "38: Whirl");
	settings.Add("split39", true, "39: Hop Skip and a Jump");
	settings.Add("split40", true, "40: Tree House");

	settings.CurrentDefaultParent = null;
	settings.Add("splitAdvanced", true, "Split on finishing Advanced levels");
	settings.CurrentDefaultParent = "splitAdvanced";

	settings.Add("split41", true, "41: Divergence");
	settings.Add("split42", true, "42: Slick Slide");
	settings.Add("split43", true, "43: Ordeal");
	settings.Add("split44", true, "44: Daedalus");
	settings.Add("split45", true, "45: Survival of the Fittest");
	settings.Add("split46", true, "46: Ramps Reloaded");
	settings.Add("split47", true, "47: Cube Root");
	settings.Add("split48", true, "48: Scaffold");
	settings.Add("split49", true, "49: Acrobat");
	settings.Add("split50", true, "50: Endurance");
	settings.Add("split51", true, "51: Battlements");
	settings.Add("split52", true, "52: Three-Fold Maze");
	settings.Add("split53", true, "53: Half-Pipe Elite");
	settings.Add("split54", true, "54: Will o' Wisp");
	settings.Add("split55", true, "55: Under Construction");
	settings.Add("split56", true, "56: Extreme Skiing");
	settings.Add("split57", true, "57: Three-Fold Race");
	settings.Add("split58", true, "58: King of the Mountain");
	settings.Add("split59", true, "59: Natural Selection");
	settings.Add("split60", true, "60: Schadenfreude");

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
}


init
{
	vars.doStart = false;
	vars.doSplit = false;
	vars.isLoading = false;

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
			if (!settings.StartEnabled)
				continue;
			if (timer.CurrentPhase == TimerPhase.NotRunning)
				vars.doStart = true;
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
	return vars.isLoading;
}
