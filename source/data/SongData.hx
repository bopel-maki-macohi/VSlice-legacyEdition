package data;

typedef SongData =
{
	var song:String;
	var notes:Array<SectionData>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;
}