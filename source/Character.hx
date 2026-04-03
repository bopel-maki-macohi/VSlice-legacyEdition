import flixel.util.FlxSort;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends CharacterBase
{
	public var isPlayer:Bool = false;
	public var holdTimer:Float = 0;

	override public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super('characters/', x, y, character);

		this.isPlayer = isPlayer;

		switch (curCharacter)
		{
			case 'pico-speaker':
				loadMappedAnims();
				playAnim('shoot1');
		}

		dadVar = 4;
		if (curCharacter == 'dad') dadVar = 6.1;

		danceCallback = function() {
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel' | 'gf-tankmen':
					if (!animation.curAnim?.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced) playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
					return false;

				case 'tankman':
					return !animation.curAnim?.name.endsWith('DOWN-alt');

				case 'spooky':
					danced = !danced;

					if (danced) playAnim('danceRight');
					else
						playAnim('danceLeft');
					return false;
			}

			return true;
		}

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public var dadVar:Float = 4;

	public var startedDeath:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!debugMode)
		{
			if (animation.curAnim?.name.startsWith('sing')) holdTimer += elapsed;
			else
				holdTimer = 0;

			if (animation.curAnim?.name.endsWith('miss') && animation.curAnim?.finished && !debugMode) playAnim('idle', true, false, 10);

			if (animation.curAnim?.name == 'firstDeath' && animation.curAnim?.finished && startedDeath) playAnim('deathLoop');
		}

		if (!isPlayer)
		{
			if (animation.curAnim?.name.startsWith('sing')) holdTimer += elapsed;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		if (curCharacter.endsWith('-car'))
		{
			// looping hair anims after idle finished
			if (!animation.curAnim?.name.startsWith('sing') && animation.curAnim?.finished) playAnim('idleHair');
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim?.name == 'hairFall' && animation.curAnim?.finished) playAnim('danceRight');
			case "pico-speaker":
				// for pico??
				if (animationNotes.length > 0)
				{
					if (Conductor.songPosition > animationNotes[0][0])
					{
						var shootAnim:Int = 1;

						if (animationNotes[0][1] >= 2) shootAnim = 3;

						shootAnim += FlxG.random.int(0, 1);

						playAnim('shoot$shootAnim', true);
						animationNotes.shift();

						trace('played shoot anim $shootAnim');
					}
				}

				if (animation.curAnim?.finished) playAnim(animation.curAnim?.name, false, false, animation.curAnim?.numFrames - 3);
		}
	}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		super.playAnim(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT') danced = true;
			else if (AnimName == 'singRIGHT') danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN') danced = !danced;
		}
	}

	public var animationNotes:Array<Dynamic> = [];

	public function loadMappedAnims()
	{
		var swagshit = SongRegistry.loadFromJson('picospeaker', 'stress');

		var notes = swagshit.notes;

		for (section in notes)
		{
			for (idk in section.sectionNotes)
			{
				animationNotes.push(idk);
			}
		}

		TankmenBG.animationNotes = animationNotes;

		trace(animationNotes);
		animationNotes.sort(sortAnims);
	}

	function sortAnims(val1:Array<Dynamic>, val2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, val1[0], val2[0]);
	}

	override function loadData(c:String)
	{
		super.loadData(c);

		dance();
		animation.finish();
		updateHitbox();
	}
}
