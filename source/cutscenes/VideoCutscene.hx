package cutscenes;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup;
#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideoSprite;
#end
import flixel.FlxSprite;
import flixel.FlxBasic;

class VideoCutscene extends FlxSpriteGroup
{
	public var blackScreen:FlxSprite;

	#if VIDEOS_ALLOWED
	public var vid:FlxVideoSprite;
	#end

	public var finishCallback:FlxSignal = new FlxSignal();

	override public function new()
	{
		super();

		blackScreen = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		blackScreen.scrollFactor.set();

		#if VIDEOS_ALLOWED
		vid = new FlxVideoSprite(0, 0);

		vid.active = false;

		vid.bitmap.onEndReached.add(finishVideo.bind(0.5));

		vid.bitmap.onFormatSetup.add(function():Void {
			if (vid.bitmap != null && vid.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / vid.bitmap.bitmapData.width, FlxG.height / vid.bitmap.bitmapData.height);

				vid.setGraphicSize(vid.bitmap.bitmapData.width * scale, vid.bitmap.bitmapData.height * scale);
				vid.updateHitbox();
				vid.screenCenter();
			}
		});

		vid.bitmap.onEncounteredError.add(function(msg:String):Void {
			trace('Video error: $msg');
			finishVideo(0.5);
		});
		#end
	}

	public function play(cutscene:String)
	{
		FlxTween.cancelTweensOf(blackScreen);
		blackScreen.alpha = 1;
		if (!members.contains(blackScreen)) add(blackScreen);

		#if VIDEOS_ALLOWED
		if (vid != null)
		{
			if (!members.contains(vid)) add(vid);

			final fileOptions:Array<String> = [];

			vid.load(cutscene, fileOptions);
			vid.play();
			// onVideoStarted.dispatch();
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
			finishVideo(0.5);
		}
		#else
		trace('ALERT: Video cutscenes unsupported!');
		finishVideo(0.5);
		#end
	}

	public function finishVideo(?transitionTime:Float = 0.5)
	{
		#if VIDEOS_ALLOWED
		if (vid != null)
		{
			vid.stop();
			if (members.contains(vid)) remove(vid);
			vid.destroy();
		}
		vid = null;
		#end

		FlxTween.tween(blackScreen, {alpha: 0}, transitionTime,
			{
				onComplete: t -> {
					if (members.contains(blackScreen)) remove(blackScreen);

					if (finishCallback != null) finishCallback.dispatch();
				}
			});
	}

	public function restartVideo(resume:Bool = true):Void
	{
		#if VIDEOS_ALLOWED
		if (vid == null) return;

		// Seek to the start of the video.
		vid.bitmap.time = 0;
		if (resume)
		{
			// Resume the video if it was paused.
			vid.resume();
		}
		#end

		// onVideoRestarted.dispatch();
	}

	public function pauseVideo():Void
	{
		#if VIDEOS_ALLOWED
		if (vid == null) return;

		vid.pause();
		#end

		// onVideoPaused.dispatch();
	}

	public function hideVideo():Void
	{
		blackScreen.visible = false;

		#if VIDEOS_ALLOWED
		if (vid == null) return;

		vid.visible = false;
		#end
	}

	public function showVideo():Void
	{
		blackScreen.visible = true;

		#if VIDEOS_ALLOWED
		if (vid == null) return;

		vid.visible = true;
		#end
	}

	public function resumeVideo():Void
	{
		#if VIDEOS_ALLOWED
		if (vid == null) return;

		vid.resume();
		#end

		// onVideoResumed.dispatch();
	}
}
