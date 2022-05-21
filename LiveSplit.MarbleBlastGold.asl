// Marble Blast Gold Autosplitter
// Supports MBG 1.4.1 non-ignited
// by thearst3rd


state("marbleblast")
{
	string100 levelFilename : 0x297ABA;
	string10 gameState : 0x294A84, 0xCF0, 0x30; // Inconsistent, needs to be changed every time
}


start
{
	if (current.levelFilename.StartsWith("/data/missions/") && !old.levelFilename.StartsWith("/data/missions/"))
		return true;
}


split
{
	if (current.gameState == "End" && old.gameState != "End")
		return true;
}
