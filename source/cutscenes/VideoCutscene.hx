package cutscenes;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxSprite;
import flixel.FlxBasic;

class VideoCutscene extends FlxSpriteGroup
{
	public var blackScreen:FlxSprite;

	public var vid:FlxVideoSprite;

	public var finishCallback:FlxSignal = new FlxSignal();

	override public function new()
	{
		super();

		blackScreen = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackScreen.scrollFactor.set();

		vid = new FlxVideoSprite(0, 0);

		vid.bitmap.onEndReached.add(finishVideo.bind(0.5));
		vid.autoPause = false;

		// Resize videos bigger or smaller than the screen.
		vid.bitmap.onTextureSetup.add(() ->
		{
			vid.setGraphicSize(FlxG.width, FlxG.height);
			vid.updateHitbox();
			vid.x = 0;
			vid.y = 0;
			// vid.scale.set(0.5, 0.5);
		});

		add(blackScreen);
		add(vid);

		blackScreen.visible = vid.visible = false;
	}

	public function play(cutscene:String)
	{
		if (vid != null)
		{
			vid.play(cutscene, false);
			// onVideoStarted.dispatch();

			blackScreen.visible = vid.visible = true;
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
		}
	}

	public function finishVideo(?transitionTime:Float = 0.5)
	{
		if (vid != null)
		{
			vid.stop();
			remove(vid);
			vid.destroy();
		}
		vid = null;

		if (finishCallback != null)
			finishCallback.dispatch();
	}

	public function restartVideo(resume:Bool = true):Void
	{
		if (vid == null)
			return;

		// Seek to the start of the video.
		vid.bitmap.time = 0;
		if (resume)
		{
			// Resume the video if it was paused.
			vid.resume();
		}

		// onVideoRestarted.dispatch();
	}

	public function pauseVideo():Void
	{
		if (vid == null)
			return;

		vid.pause();
		// onVideoPaused.dispatch();
	}

	public function hideVideo():Void
	{
		blackScreen.visible = false;

		if (vid == null)
			return;

		vid.visible = false;
	}

	public function showVideo():Void
	{
		blackScreen.visible = true;

		if (vid == null)
			return;

		vid.visible = true;
	}

	public function resumeVideo():Void
	{
		if (vid == null)
			return;

		vid.resume();
		// onVideoResumed.dispatch();
	}
}
