package objects;

import lime.app.Application;
import flixel.util.FlxColor;
import flixel.FlxG;

class VersionText extends FunkinText
{
	override public function new(x:Float, y:Float)
	{
		super(x, y, 0, 'V-Slice : Legacy Edition v${Application.current.meta.get('version')}', 12);

		scrollFactor.set();
		setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		#if debug
		text += ' (Debug build)';
		#elseif PLAYTESTING_BUILD
		text += ' (Playtesting build)';
		#end
	}
}
