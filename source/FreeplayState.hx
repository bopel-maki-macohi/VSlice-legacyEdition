package;

#if discord_rpc
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.utils.Assets;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	// var selector:FunkinText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FunkinText;
	var diffText:FunkinText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	var coolColors:Array<Int> = [];

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];
	var bg:FlxSprite;
	var scoreBG:FlxSprite;

	override function create()
	{
		#if discord_rpc
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		addSong('Test', 0, 'bf-pixel', 'tutorial');
		#end

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		for (i => week in WeekRegistry.weekList)
		{
			final parsedWeek = WeekRegistry.loadFromJson(week);

			if (parsedWeek == null)
				continue;

			addWeek(parsedWeek.songs, i, parsedWeek?.freeplayChars ?? null, week);

			if (parsedWeek.color != null)
				coolColors.push(FlxColor.fromString(parsedWeek.color));
			else
				coolColors.push(coolColors[coolColors.length - 1] ?? 0xFFFFFF);
		}

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FunkinText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		add(scoreBG);

		diffText = new FunkinText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		super.create();
	}

	public function addSong(songName:String, ID:Int, songCharacter:String, week:String)
	{
		songs.push(new SongMetadata(songName, ID, songCharacter, week));
	}

	public function addWeek(songs:Array<String>, ID:Int, ?songCharacters:Array<String>, week:String)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, ID, songCharacters[num], week);

			if (songCharacters.length - 1 > num)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.volume < 0.7)
			{
				FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			}
		}

		lerpScore = CoolUtil.coolLerp(lerpScore, intendedScore, 0.4);
		bg.color = FlxColor.interpolate(bg.color, coolColors[songs[curSelected].ID % coolColors.length], CoolUtil.camLerpShit(0.045));

		scoreText.text = "PERSONAL BEST:" + Math.round(lerpScore);

		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
			changeSelection(-1);
		if (downP)
			changeSelection(1);

		if (FlxG.mouse.wheel != 0)
			changeSelection(-Math.round(FlxG.mouse.wheel / 4));

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(() -> new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), songs[curSelected].difficulties[curDifficulty]);
			PlayState.SONG = SongRegistry.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = songs[curSelected].difficulties[curDifficulty];

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK ${PlayState.storyWeek}');
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = songs[curSelected].difficulties.length - 1;
		if (curDifficulty > songs[curSelected].difficulties.length - 1)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected].songName, songs[curSelected].difficulties[curDifficulty]);

		PlayState.storyDifficulty = songs[curSelected].difficulties[curDifficulty];

		diffText.text = "< " + CoolUtil.difficultyString() + " >";
		positionHighscore();
		
		playTrack();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		intendedScore = Highscore.getScore(songs[curSelected].songName, songs[curSelected].difficulties[curDifficulty]);
		// lerpScore = 0;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		changeDiff(0);
	}

	var curTrack:String = '';

	function playTrack()
	{
		#if !PRELOAD_ALL
		return;
		#end
		
		final wantedTrack = Paths.inst(songs[curSelected].songName, songs[curSelected].difficulties[curDifficulty]);

		if (curTrack == wantedTrack) return;
		curTrack = wantedTrack;

		FlxG.sound.playMusic(curTrack, 0);
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - scoreBG.scale.x / 2;

		diffText.x = Std.int(scoreBG.x + scoreBG.width / 2);
		diffText.x -= (diffText.width / 2);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:String = '';
	public var songCharacter:String = "";
	public var ID:Int = 0;

	public var difficulties:Array<Int> = [];

	public function new(song:String, ID:Int, songCharacter:String, week:String)
	{
		this.songName = song;
		this.ID = ID;
		this.songCharacter = songCharacter;
		this.week = week;

		recalcDifficulties();
	}

	public function recalcDifficulties()
	{
		difficulties = [];

		for (i in 0...5)
		{
			var songJson:SongData = SongRegistry.loadFromJson(Highscore.formatSong(songName, i), songName);

			if (songJson != null)
				difficulties.push(i);
		}
	}
}
