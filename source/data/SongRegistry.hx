package data;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

class SongRegistry
{
	public static var songs(get, never):Array<String>;

	static function get_songs():Array<String>
	{
		// var s = Assets.list().filter(f -> return haxe.io.Path.directory(f) == 'assets/data/songs/');

		var s = [];

		for (week in WeekRegistry.weeks)
		{
			final parsedWeek = WeekRegistry.loadFromJson(week);

			if (parsedWeek == null)
				continue;

			for (song in parsedWeek.songs)
				s.push(song);
		}

		return s;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SongData
	{
		if (folder == null || folder == '')
			return null;
		if (jsonInput == null || jsonInput == '')
			return null;

		var path = Paths.json('songs/' + folder.toLowerCase() + '/' + jsonInput.toLowerCase());
		if (!Assets.exists(path))
			return null;

		var rawJson = Assets.getText(path).trim();

		return parseJSONshit(rawJson);
	}

	public static function parseJSONshit(rawJson:String):SongData
	{
		var swagShit:SongData = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
