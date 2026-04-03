package scriptos;

import haxe.Json;
import sys.io.File;

// haxe -m scriptos.CharacterJsonGenerator --interp
class CharacterJsonGenerator
{
	static function main()
	{
		for (char in [
			'gf',
			'bf',
			'bf-car',
			'bf-christmas',
			'bf-holding-gf-dead',
			'bf-holding-gf',
			'bf-pixel-dead',
			'bf-pixel',
			'dad',
			'gf-car',
			'gf-christmas',
			'gf-pixel',
			'mom-car',
			'mom',
			'monster-christmas',
			'monster',
			'parents-christmas',
			'pico-speaker',
			'pico',
			'senpai',
			'senpai-angry',
			'spirit',
			'spooky',
			'tankman',
		])
			switchStatement(char);
	}

	static var daPixelZoom = 6;

	static function switchStatement(character:String)
	{
		var animations:Array<Dynamic> = [];
		var scale:Array<Float> = [1, 1];
		var isPlayer = false;
		var packer = false;
		var startingAnim:String = '';
		var isPixel = false;

		function getSparrowAtlas(v:String)
		{
			packer = false;
			return v;
		}

		function getPackerAtlas(v:String)
		{
			packer = true;
			return v;
		}

		function addByPrefix(a:String, b:String, c:Int = 24, d:Bool = false)
			animations.push({
				name: a,
				prefix: b,
				fps: c,
				looping: d,
			});

		function quickAnimAdd(a:String, b:String)
			addByPrefix(a, b, 24, false);

		function addByIndices(a:String, b:String, c:Array<Int>, d:String = '', e:Int = 24, f:Bool = false)
			animations.push({
				name: a,
				prefix: b,
				indices: c,
				postfix: d,
				fps: e,
				looping: f,
			});

		function setGraphicSize(s:Int = 1)
		{
			scale = [s, s];
		}

		var offsetFile = character;
		function loadOffsetFile(v:String)
		{
			offsetFile = v;
		}
		function playAnim(v:String)
		{
			startingAnim = v;
		}
		function updateHitbox() {}
		function loadMappedAnims() {}

		var width = 1.0;
		var height = 1.0;

		var path = '';
		var flipX = false;
		var flipY = false;
		var antialiasing = true;

		switch (character)
		{
			case 'gf':
				// GIRLFRIEND CODE
				path = getSparrowAtlas('characters/GF_assets');
				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
				addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addByPrefix('scared', 'GF FEAR', 24, true);

				loadOffsetFile(character);

				playAnim('danceRight');

			case 'gf-christmas':
				path = getSparrowAtlas('characters/gfChristmas');
				quickAnimAdd('cheer', 'GF Cheer');
				quickAnimAdd('singLEFT', 'GF left note');
				quickAnimAdd('singRIGHT', 'GF Right Note');
				quickAnimAdd('singUP', 'GF Up Note');
				quickAnimAdd('singDOWN', 'GF Down Note');
				addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				addByPrefix('scared', 'GF FEAR', 24, true);

				loadOffsetFile(character);

				playAnim('danceRight');
			case 'gf-tankmen':
				path = getSparrowAtlas('characters/gfTankmen');
				addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, true);
				addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile('gf');
				playAnim('danceRight');

			case 'bf-holding-gf':
				path = getSparrowAtlas('characters/bfAndGF');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singUP', 'BF NOTE UP0');

				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('bfCatch', 'BF catches GF');

				loadOffsetFile(character);

				playAnim('idle');

				flipX = true;

			case 'gf-car':
				path = getSparrowAtlas('characters/gfCar');
				addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				addByIndices('idleHair', 'GF Dancing Beat Hair blowing CAR', [10, 11, 12, 25, 26, 27], "", 24, true);

				loadOffsetFile(character);

				playAnim('danceRight');

			case 'gf-pixel':
				path = getSparrowAtlas('characters/gfPixel');
				addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(character);

				playAnim('danceRight');

				// setGraphicSize(Std.int(width * daPixelZoom));
				isPixel = true;
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				path = getSparrowAtlas('characters/DADDY_DEAREST');
				quickAnimAdd('idle', 'Dad idle dance');
				quickAnimAdd('singUP', 'Dad Sing Note UP');
				quickAnimAdd('singRIGHT', 'Dad Sing Note RIGHT');
				quickAnimAdd('singDOWN', 'Dad Sing Note DOWN');
				quickAnimAdd('singLEFT', 'Dad Sing Note LEFT');

				loadOffsetFile(character);

				playAnim('idle');
			case 'spooky':
				path = getSparrowAtlas('characters/spooky_kids_assets');
				quickAnimAdd('singUP', 'spooky UP NOTE');
				quickAnimAdd('singDOWN', 'spooky DOWN note');
				quickAnimAdd('singLEFT', 'note sing left');
				quickAnimAdd('singRIGHT', 'spooky sing right');
				addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				loadOffsetFile(character);

				playAnim('danceRight');
			case 'mom':
				path = getSparrowAtlas('characters/Mom_Assets');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Up Pose");
				quickAnimAdd('singDOWN', "MOM DOWN POSE");
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				quickAnimAdd('singRIGHT', 'Mom Pose Left');

				loadOffsetFile(character);

				playAnim('idle');

			case 'mom-car':
				path = getSparrowAtlas('characters/momCar');

				quickAnimAdd('idle', "Mom Idle");
				quickAnimAdd('singUP', "Mom Up Pose");
				quickAnimAdd('singDOWN', "MOM DOWN POSE");
				quickAnimAdd('singLEFT', 'Mom Left Pose');
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				quickAnimAdd('singRIGHT', 'Mom Pose Left');
				addByIndices('idleHair', "Mom Idle", [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(character);

				playAnim('idle');
			case 'monster':
				path = getSparrowAtlas('characters/Monster_Assets');
				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				loadOffsetFile(character);

				playAnim('idle');
			case 'monster-christmas':
				path = getSparrowAtlas('characters/monsterChristmas');
				quickAnimAdd('idle', 'monster idle');
				quickAnimAdd('singUP', 'monster up note');
				quickAnimAdd('singDOWN', 'monster down');
				quickAnimAdd('singLEFT', 'Monster left note');
				quickAnimAdd('singRIGHT', 'Monster Right note');

				loadOffsetFile(character);

				playAnim('idle');
			case 'pico':
				path = getSparrowAtlas('characters/Pico_FNF_assetss');
				quickAnimAdd('idle', "Pico Idle Dance");
				quickAnimAdd('singUP', 'pico Up note0');
				quickAnimAdd('singDOWN', 'Pico Down Note0');
				if (isPlayer)
				{
					quickAnimAdd('singLEFT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHT', 'Pico Note Right0');
					quickAnimAdd('singRIGHTmiss', 'Pico Note Right Miss');
					quickAnimAdd('singLEFTmiss', 'Pico NOTE LEFT miss');
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					quickAnimAdd('singLEFT', 'Pico Note Right0');
					quickAnimAdd('singRIGHT', 'Pico NOTE LEFT0');
					quickAnimAdd('singRIGHTmiss', 'Pico NOTE LEFT miss');
					quickAnimAdd('singLEFTmiss', 'Pico Note Right Miss');
				}

				quickAnimAdd('singUPmiss', 'pico Up note miss');
				quickAnimAdd('singDOWNmiss', 'Pico Down Note MISS');

				loadOffsetFile(character);

				playAnim('idle');

				flipX = true;

			case 'pico-speaker':
				path = getSparrowAtlas('characters/picoSpeaker');

				quickAnimAdd('shoot1', "Pico shoot 1");
				quickAnimAdd('shoot2', "Pico shoot 2");
				quickAnimAdd('shoot3', "Pico shoot 3");
				quickAnimAdd('shoot4', "Pico shoot 4");

				// here for now, will be replaced later for less copypaste
				loadOffsetFile(character);
				playAnim('shoot1');

				loadMappedAnims();

			case 'bf-christmas':
				path = getSparrowAtlas('characters/bfChristmas');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				loadOffsetFile(character);

				playAnim('idle');

				flipX = true;
			case 'bf-car':
				path = getSparrowAtlas('characters/bfCar');
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				addByIndices('idleHair', 'BF idle dance', [10, 11, 12, 13], "", 24, true);

				loadOffsetFile(character);

				playAnim('idle');

				flipX = true;
			case 'bf-pixel':
				path = getSparrowAtlas('characters/bfPixel');
				quickAnimAdd('idle', 'BF IDLE');
				quickAnimAdd('singUP', 'BF UP NOTE');
				quickAnimAdd('singLEFT', 'BF LEFT NOTE');
				quickAnimAdd('singRIGHT', 'BF RIGHT NOTE');
				quickAnimAdd('singDOWN', 'BF DOWN NOTE');
				quickAnimAdd('singUPmiss', 'BF UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF DOWN MISS');

				loadOffsetFile(character);

				// setGraphicSize(Std.int(width * 6));
				isPixel = true;
				updateHitbox();

				playAnim('idle');

				// width -= 100;
				// height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				path = getSparrowAtlas('characters/bfPixelsDEAD');
				quickAnimAdd('singUP', "BF Dies pixel");
				quickAnimAdd('firstDeath', "BF Dies pixel");
				addByPrefix('deathLoop', "Retry Loop", 24, true);
				quickAnimAdd('deathConfirm', "RETRY CONFIRM");
				playAnim('firstDeath');

				loadOffsetFile(character);

				playAnim('firstDeath');
				// pixel bullshit
				// setGraphicSize(Std.int(width * 6));
				isPixel = true;
				updateHitbox();
				antialiasing = false;
				flipX = true;

			case 'bf-holding-gf-dead':
				path = getSparrowAtlas('characters/bfHoldingGF-DEAD');
				quickAnimAdd('singUP', 'BF Dead with GF Loop');
				quickAnimAdd('firstDeath', 'BF Dies with GF');
				addByPrefix('deathLoop', 'BF Dead with GF Loop', 24, true);
				quickAnimAdd('deathConfirm', 'RETRY confirm holding gf');

				loadOffsetFile(character);

				playAnim('firstDeath');

				flipX = true;

			case 'senpai':
				path = getSparrowAtlas('characters/senpai');
				quickAnimAdd('idle', 'Senpai Idle');
				// at framerate 16.8 animation plays over 2 beats at 144bpm,
				// but if the game lags or the bpm is > 144 (mods etc.)
				// he may miss his next dance
				// getByName('idle').frameRate = 16.8;

				quickAnimAdd('singUP', 'SENPAI UP NOTE');
				quickAnimAdd('singLEFT', 'SENPAI LEFT NOTE');
				quickAnimAdd('singRIGHT', 'SENPAI RIGHT NOTE');
				quickAnimAdd('singDOWN', 'SENPAI DOWN NOTE');

				loadOffsetFile(character);

				playAnim('idle');

				// setGraphicSize(Std.int(width * 6));
				isPixel = true;
				updateHitbox();

				antialiasing = false;
			case 'senpai-angry':
				path = getSparrowAtlas('characters/senpai');
				quickAnimAdd('idle', 'Angry Senpai Idle');
				quickAnimAdd('singUP', 'Angry Senpai UP NOTE');
				quickAnimAdd('singLEFT', 'Angry Senpai LEFT NOTE');
				quickAnimAdd('singRIGHT', 'Angry Senpai RIGHT NOTE');
				quickAnimAdd('singDOWN', 'Angry Senpai DOWN NOTE');

				loadOffsetFile(character);

				playAnim('idle');

				// setGraphicSize(Std.int(width * 6));
				isPixel = true;
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				path = getPackerAtlas('characters/spirit');
				quickAnimAdd('idle', "idle spirit_");
				quickAnimAdd('singUP', "up_");
				quickAnimAdd('singRIGHT', "right_");
				quickAnimAdd('singLEFT', "left_");
				quickAnimAdd('singDOWN', "spirit down_");

				loadOffsetFile(character);

				// setGraphicSize(Std.int(width * 6));
				isPixel = true;
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

			case 'parents-christmas':
				path = getSparrowAtlas('characters/mom_dad_christmas_assets');
				quickAnimAdd('idle', 'Parent Christmas Idle');
				quickAnimAdd('singUP', 'Parent Up Note Dad');
				quickAnimAdd('singDOWN', 'Parent Down Note Dad');
				quickAnimAdd('singLEFT', 'Parent Left Note Dad');
				quickAnimAdd('singRIGHT', 'Parent Right Note Dad');

				quickAnimAdd('singUP-alt', 'Parent Up Note Mom');

				quickAnimAdd('singDOWN-alt', 'Parent Down Note Mom');
				quickAnimAdd('singLEFT-alt', 'Parent Left Note Mom');
				quickAnimAdd('singRIGHT-alt', 'Parent Right Note Mom');

				loadOffsetFile(character);

				playAnim('idle');
			case 'tankman':
				path = getSparrowAtlas('characters/tankmanCaptain');

				quickAnimAdd('idle', "Tankman Idle Dance");

				if (isPlayer)
				{
					quickAnimAdd('singLEFT', 'Tankman Note Left ');
					quickAnimAdd('singRIGHT', 'Tankman Right Note ');
					quickAnimAdd('singLEFTmiss', 'Tankman Note Left MISS');
					quickAnimAdd('singRIGHTmiss', 'Tankman Right Note MISS');
				}
				else
				{
					// Need to be flipped! REDO THIS LATER
					quickAnimAdd('singLEFT', 'Tankman Right Note ');
					quickAnimAdd('singRIGHT', 'Tankman Note Left ');
					quickAnimAdd('singLEFTmiss', 'Tankman Right Note MISS');
					quickAnimAdd('singRIGHTmiss', 'Tankman Note Left MISS');
				}

				quickAnimAdd('singUP', 'Tankman UP note ');
				quickAnimAdd('singDOWN', 'Tankman DOWN note ');
				quickAnimAdd('singUPmiss', 'Tankman UP note MISS');
				quickAnimAdd('singDOWNmiss', 'Tankman DOWN note MISS');

				// PRETTY GOOD tankman
				// TANKMAN UGH instanc

				quickAnimAdd('singDOWN-alt', 'PRETTY GOOD');
				quickAnimAdd('singUP-alt', 'TANKMAN UGH');

				loadOffsetFile(character);

				playAnim('idle');

				flipX = true;
			case 'bf':
				var tex = getSparrowAtlas('characters/BOYFRIEND');
				path = tex;
				quickAnimAdd('idle', 'BF idle dance');
				quickAnimAdd('singUP', 'BF NOTE UP0');
				quickAnimAdd('singLEFT', 'BF NOTE LEFT0');
				quickAnimAdd('singRIGHT', 'BF NOTE RIGHT0');
				quickAnimAdd('singDOWN', 'BF NOTE DOWN0');
				quickAnimAdd('singUPmiss', 'BF NOTE UP MISS');
				quickAnimAdd('singLEFTmiss', 'BF NOTE LEFT MISS');
				quickAnimAdd('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				quickAnimAdd('singDOWNmiss', 'BF NOTE DOWN MISS');
				quickAnimAdd('hey', 'BF HEY');

				quickAnimAdd('firstDeath', "BF dies");
				addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				quickAnimAdd('deathConfirm', "BF Dead confirm");

				addByPrefix('scared', 'BF idle shaking', 24, true);

				playAnim('idle');

				flipX = true;

				loadOffsetFile(character);
		}

		File.saveContent('assets/preload/data/characters/$character.json', Json.stringify({
			path: path,
			animations: animations,
			antialiasing: antialiasing,
			flipY: flipY,
			flipX: flipX,
			scale: scale,
			offsets: [0, 0],
			offsetFile: offsetFile,
			packer: packer,
			startingAnim: startingAnim,
			isPixel: isPixel,
		}, '\t'));
	}
}
