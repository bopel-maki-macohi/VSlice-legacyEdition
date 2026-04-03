package scriptos;

import haxe.io.Path;
import sys.FileSystem;

class ScriptosUtil
{
	public static function readDir(dir:String):Array<String>
	{
		var files:Array<String> = [];

		for (file in FileSystem.readDirectory(dir))
		{
			final path = '${Path.removeTrailingSlashes(dir)}/$file';

			if (FileSystem.isDirectory(path))
				for (subfile in readDir(path))
					files.push(subfile);
			else
				files.push(path);
		}

		return files;
	}
}
