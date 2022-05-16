// Marble Blast Gold Autosplitter
// Supports MBG 1.4.1 non-ignited
// by thearst3rd


state("marbleblast")
{
	string100 levelFilename : "marbleblast.exe", 0x297ABA;
}


start
{
	if (current.levelFilename.StartsWith("/data/missions/") && !old.levelFilename.StartsWith("/data/missions/"))
		return true;
}


split
{

}
