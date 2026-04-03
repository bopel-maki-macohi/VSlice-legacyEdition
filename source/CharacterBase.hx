package;

import haxe.Json;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxSort;
import haxe.io.Path;

using StringTools;

class CharacterBase extends FlxSprite
{
	public var debugMode:Bool = false;

	public var animOffsets:Map<String, Array<Dynamic>>;

	public var curCharacter:String = 'bf';

	public function new(dataPath:String = '', x:Float, y:Float, ?character:String = "bf")
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;

		this.dataPath = dataPath;

		loadData(curCharacter);
	}

	function quickAnimAdd(name:String, prefix:String)
	{
		animation.addByPrefix(name, prefix, 24, false);
	}

	private function loadOffsetFile(offsetCharacter:String)
	{
		final path = Paths.txt('$dataPath${offsetCharacter}Offsets');

		if (!Assets.exists(path))
		{
			trace('Couldnt find offsets path: $path');
			return;
		}

		var daFile:Array<String> = CoolUtil.coolTextFile(path);

		for (i in daFile)
		{
			var splitWords:Array<String> = i.split(" ");
			addOffset(splitWords[0], Std.parseInt(splitWords[1]), Std.parseInt(splitWords[2]));
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * the return is if it should play "idle"
	 * 
	 * it's a callback now because of storymode characters
	 */
	public var danceCallback:Void->Bool = null;

	public function dance()
	{
		if (animation.curAnim == null || debugMode)
			return;

		if (danceCallback == null)
			danceCallback = () -> return true;

		if (danceCallback())
			playAnim('idle');
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var ox = 0.0;
		var oy = 0.0;

		if (animOffsets.exists(AnimName))
		{
			var daOffset = animOffsets.get(AnimName);

			ox += daOffset[0];
			oy += daOffset[1];
		}

		applyBaseOffset();
		offset.add(ox, oy);
	}

	public function applyBaseOffset()
	{
		offset.set(0, 0);

		if (data?.offsets != null)
			offset.set(data?.offsets[0] ?? 0, data?.offsets[1] ?? 0);

		// trace(offset.toString());
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
		animOffsets[name] = [x, y];

	public var data:CharacterData = null;

	public var dataPath:String = '';

	public function loadData(c:String)
	{
		final prevCharacterData = data;

		if (c == '' || c == null)
		{
			trace('Who dis? Blank "c"');
			return;
		}

		var path = Paths.json('$dataPath$c');
		if (!Assets.exists(path))
		{
			trace('Couldnt find data path: $path');
			return;
		}

		var rawJson = Assets.getText(path);

		try
		{
			data = Json.parse(rawJson);
		}
		catch (e)
		{
			data = null;
			trace('Couldnt parse Character Data JSON: $c\n$e');
		}

		if (data == null || data.animations.length < 1)
		{
			data = prevCharacterData;
			return;
		}

		var tex = Paths.getSparrowAtlas(data?.path ?? '$dataPath/$c');
		frames = tex;

		if (frames == null)
			return;

		for (n in this.animation.getNameList())
			animation.remove(n);

		for (a in data.animations)
		{
			if (a.name == null || a.prefix == null)
				continue;

			animation.addByPrefix(a.name, a.prefix, 24, a?.looping ?? true);

			if (a.offsets != null)
				addOffset(a.name, a.offsets[0] ?? 0, a.offsets[1] ?? 0);
		}

		if (data.scale != null)
			this.scale.set(data?.scale[0] ?? 1, data?.scale[0] ?? 1);
		else
			this.scale.set(1, 1);
		updateHitbox();

		flipX = data?.flipX;
		flipY = data?.flipY;
	}
}
