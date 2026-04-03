package scriptos;

import haxe.Timer;
import haxe.io.Path;
import sys.FileSystem;

// haxe -m scriptos.ClearOfMP3 --interp
class ClearOfMP3
{
	static function main()
	{
		final mp3s = ScriptosUtil.readDir('assets/').filter(s -> return Path.extension(s) == 'mp3');

		Timer.measure(() ->
		{
			for (file in mp3s)
				FileSystem.deleteFile(file);
		});

		trace('Removed ${mp3s.length} mp3 files');
	}
}
