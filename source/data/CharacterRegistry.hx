package data;

import haxe.io.Path;
import haxe.Json;
import lime.utils.Assets;

using StringTools;

class CharacterRegistry
{
	public static var characterList(get, never):Array<String>;

	static function get_characterList():Array<String>
	{
		var c = [];

		for (asset in Assets.list().filter(p -> return p.startsWith('assets/data/characters/')))
		{
			var char = Path.withoutExtension(Path.withoutDirectory(asset));

			if (loadFromJson(char) == null)
				continue;

			c.push(char);
		}

		return c;
	}

	public static function loadFromJson(character:String, dataFolder:String = ''):CharacterData
	{
		if (character == null || character == '')
			return null;

		var path = Paths.json(dataFolder + character);
		if (!Assets.exists(path))
			return null;

		var rawJson = Assets.getText(path);
		var characterJson:CharacterData = null;

		try
		{
			characterJson = Json.parse(rawJson);
		}
		catch (e)
		{
			characterJson = null;
			trace('Couldnt parse character JSON: $character\n$e');
		}

		return characterJson;
	}
}
