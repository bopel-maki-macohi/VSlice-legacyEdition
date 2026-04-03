package data;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

class SongRegistry
{
	public static var songList(get, never):Array<String>;

	static function get_songList():Array<String>
	{
		// var s = Assets.list().filter(f -> return haxe.io.Path.directory(f) == 'assets/data/songs/');

		var s = [];

		for (week in WeekRegistry.weekList)
		{
			final parsedWeek = WeekRegistry.loadFromJson(week);

			if (parsedWeek == null) continue;

			for (song in parsedWeek.songs)
				s.push(song);
		}

		return s;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SongData
	{
		if (folder == null || folder == '') return null;
		if (jsonInput == null || jsonInput == '') return null;

		var path = Paths.json('songs/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase());
		if (!Assets.exists(path)) return null;

		var rawJson = Assets.getText(path).trim();

		return parseSavedChart(rawJson, jsonInput);
	}

	public static function parseSavedChart(chart:String, song:String):SongData
	{
		var swagShit:SongData = null;
		try
		{
			swagShit = cast Json.parse(chart).song;
			swagShit.validScore = true;
		}
		catch (e)
		{
			swagShit = null;
			trace('Couldnt parse song chart JSON: $song\n$e');
		}

		return swagShit;
	}
}
