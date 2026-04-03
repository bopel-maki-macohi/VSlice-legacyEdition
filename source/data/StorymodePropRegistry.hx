package data;

import haxe.Json;
import haxe.io.Path;
import lime.utils.Assets;

class StorymodePropRegistry
{
	public static var props(get, never):Array<String>;

	static function get_props():Array<String>
	{
		var p = [];

		for (file in Assets.list().filter(f -> return Path.directory(f) == 'assets/data/ui/storymode/props'))
		{
			final f = Path.withoutDirectory(Path.withoutExtension(file));

			if (loadFromJson(f) == null)
				continue;

			p.push(f);
		}

		return p;
	}

	public static function loadFromJson(prop:String):CharacterData
	{
        if (prop == '' || prop == null) return null;

        var path = Paths.json('ui/storymode/props/' + prop);
        if (!Assets.exists(path)) return null;

		var rawJson = Assets.getText(path);
		var propJson:CharacterData = null;

		try
		{
			propJson = Json.parse(rawJson);
		}
		catch (e)
		{
			propJson = null;
			trace('Couldnt parse Storymode Prop JSON: $prop\n$e');
		}

		return propJson;
	}
}
