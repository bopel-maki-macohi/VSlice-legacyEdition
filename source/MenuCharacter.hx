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

			graphic = null;

			return null;
		}

		final prevPropData = propData;
		propData = StorymodePropRegistry.loadFromJson(c);

		if (propData == null || propData.animations.length < 1)
		{
			propData = prevPropData;
			return character;
		}

		var tex = Paths.getSparrowAtlas(propData?.path ?? 'storymode/props/$c');
		frames = tex;

		if (frames == null)
			return character;

		for (n in this.animation.getNameList())
			animation.remove(n);

		for (a in propData.animations)
		{
			if (a.name == null || a.prefix == null)
				continue;

			animation.addByPrefix(a.name, a.prefix, 24, a?.looping ?? true);
		}

		playAnimation('idle');

		if (propData.scale != null)
			this.scale.set(propData?.scale[0] ?? 1, propData?.scale[0] ?? 1);
		else
			this.scale.set(1, 1);
		updateHitbox();

		flipX = propData?.flipX;
		flipY = propData?.flipY;

		return c;
	}

	public function playAnimation(anim:String)
	{
		animation.play(anim);

		if (character == '' || character == null)
			return;

		var offsets = [0.0, 0.0];

		if (propData != null)
			for (a in propData.animations)
				if (a.name == anim)
					offsets = a.offsets;

		offset.set(offsets[0] ?? 0, offsets[1] ?? 0);
	}

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;
	}
}
