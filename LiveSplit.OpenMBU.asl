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

	System.IO.Pipes.NamedPipeClientStream pipeClient = new System.IO.Pipes.NamedPipeClientStream(".", "mbuautosplitter", System.IO.Pipes.PipeDirection.In);

	print("Connecting to OpenMBU pipe...");
	pipeClient.Connect();

	print("Connected");

	vars.streamReader = new StreamReader(pipeClient);
	vars.streamReader.ReadTimeout = 1;
}


update {
	string temp = null; //vars.streamReader.ReadLine();
	if (temp != null)
	{
		if (temp.StartsWith("start"))
			vars.doStart = true;
		else if (temp.StartsWith("split"))
			vars.doSplit = true;
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
