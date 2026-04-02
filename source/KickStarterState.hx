package;

import flixel.FlxG;

class KickStarterState extends MusicBeatState
{
	public static var seenVideo:Bool = false;

	public var video:FlxVideo;

	override function create()
	{
		super.create();

		seenVideo = true;

		FlxG.save.data.seenVideo = true;
		FlxG.save.flush();

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		video = new FlxVideo('music/kickstarterTrailer.mp4');
		add(video);

		video.finishCallback = done;
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
			finishVideo();

		super.update(elapsed);
	}

	function finishVideo():Void
		video.finishVideo();

	function done():Void
	{
		TitleState.initialized = false;
		FlxG.switchState(new TitleState());
	}
}
