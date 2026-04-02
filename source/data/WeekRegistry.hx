package data;

import haxe.io.Path;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class WeekRegistry
{
	public static var weeks(get, never):Array<String>;

	static function get_weeks():Array<String>
	{
		var w = [];

		for (week in Assets.getText(Paths.txt('weekList')).split('\n'))
		{
			if (loadFromJson(week) == null)
				continue;

			w.push(week);
		}

		return w;
	}

	public static function loadFromJson(week:String):WeekData
	{
		var rawJson = Assets.getText(Paths.json('weeks/' + week));
		var weekJson:WeekData = null;

		try
		{
			weekJson = Json.parse(rawJson);
		}
		catch (e)
		{
			weekJson = null;
			trace('Couldnt parse week JSON: $week\n$e');
		}

		return weekJson;
	}
}
