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
			if (loadFromJson(week.trim()) == null)
				continue;

			w.push(week.trim());
		}

		return w;
	}

	public static function loadFromJson(week:String):WeekData
	{
		if (week == null || week == '') return null;

        var path = Paths.json('weeks/' + week);
        if (!Assets.exists(path)) return null;

		var rawJson = Assets.getText(path);
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
