// OpenMBU Autosplitter


state("MBUltra") {}
state("MBUltra64") {}
state("MBUltra_DEBUG") {}
state("MBUltra64_DEBUG") {}
state("MBUltra_OPTIMIZEDDEBUG") {}
state("MBUltra64_OPTIMIZEDDEBUG") {}


init {
	vars.doStart = false;
	vars.doSplit = false;
	vars.isLoading = false;

	print("Opening OpenMBU autosplitter file");
	String path = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
	path = Path.Combine(path, "GarageGames", "Marble Blast Ultra", "autosplitter.txt");
	print("OpenMBU Autosplitter path: " + path);
	FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete);

	vars.streamReader = new StreamReader(fs);

	// Clear out old data
	print("Discarding: " + vars.streamReader.ReadToEnd());
}


update {
	String line;
	while ((line = vars.streamReader.ReadLine()) != null)
	{
		print("OpenMBU autosplitter got line: " + line);
		if (line.StartsWith("start"))
			vars.doStart = true;
		else if (line.StartsWith("finish"))
			vars.doSplit = true;
		else if (line.StartsWith("loading started"))
			vars.isLoading = true;
		else if (line.StartsWith("loading finished"))
			vars.isLoading = false;
	}
}


start {
	if (vars.doStart) {
		vars.doStart = false;
		return true;
	}
	return false;
}


split {
	if (vars.doSplit) {
		vars.doSplit = false;
		return true;
	}
	return false;
}


isLoading {
	return vars.isLoading;
}
