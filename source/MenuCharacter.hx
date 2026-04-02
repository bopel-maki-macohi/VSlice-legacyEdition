package;

import flixel.FlxSprite;

class MenuCharacter extends FlxSprite
{
	public var propData:StorymodePropData = null;

	public var character(default, set):String;

	function set_character(c:String):String
	{
		if (c == null || c == '')
		{
			propData = null;
			this.visible = false;
			makeGraphic(8, 8);
			offset.set(1000000000000, 10000000000000);
			return null;
		}

		final prevPropData = propData;
		propData = StorymodePropRegistry.loadFromJson(c);

		if (propData == null || propData.animations.length < 1)
		{
			propData = prevPropData;
			return character;
		}

		var tex = Paths.getSparrowAtlas(propData.path ?? 'storymode/props/$c');
		frames = tex;

		if (frames == null)
			return character;

		for (n in this.animation.getNameList())
			animation.remove(n);

		for (a in propData.animations)
			animation.addByPrefix(a.name, a.prefix, 24, a.looping ?? true);

		playAnimation(propData.animations[0].name);
		updateHitbox();

		if (propData.scale != null)
			this.scale.set(propData?.scale[0] ?? 1, propData?.scale[0] ?? 1);
		else
			this.scale.set(1,1);

		return c;
	}

	public function playAnimation(anim:String)
	{
		if (character == '' || character == null)
			return;

		var offsets = [0.0, 0.0];

		if (propData != null)
			for (a in propData.animations)
				if (a.name == anim)
					offsets = a.offsets;

		animation.play(anim);
		offset.set(offsets[0] ?? 0, offsets[1] ?? 0);
	}

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;
	}
}
