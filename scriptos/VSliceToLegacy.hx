package scriptos;

import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import haxe.io.Path;

using StringTools;
using Reflect;

typedef SectionData =
{
	?sectionNotes:Array<Dynamic>,
	?lengthInSteps:Int,
	?typeOfSection:Int,
	?mustHitSection:Bool,
	?bpm:Null<Float>,
	?changeBPM:Bool,
	?altAnim:Bool,
}

typedef SongData =
{
	?song:String,
	?notes:Array<SectionData>,
	?bpm:Float,
	?needsVoices:Bool,
	?speed:Float,

	?player1:String,
	?player2:String,
	?validScore:Bool,
}

// haxe -m scriptos.VSliceToLegacy --interp
class VSliceToLegacy
{
	public static var datas:Map<String, Array<Dynamic>> = [];

	public static var pairs:Map<String, Map<String, Array<Dynamic>>> = [];

	static var currentChart:SongData;

	static function main()
	{
		final charts = ScriptosUtil.readDir('scriptos/vsliceCharts/').filter(s -> return Path.extension(s) == 'json');

		for (chart in charts)
		{
			// trace('$chart');

			final chartisjdi = Path.withoutDirectory(Path.withoutExtension(chart)).replace('-chart', '').replace('-metadata', '');

			if (!pairs.exists(chartisjdi))
				pairs.set(chartisjdi, [
					'easy' => [null, null],
					'normal' => [null, null],
					'hard' => [null, null],

					'erect' => [null, null],
					'nightmare' => [null, null],
				]);

			if (Path.withoutDirectory(Path.withoutExtension(chart)).contains('-chart'))
				chartFile(chart, chartisjdi);
			else if (Path.withoutDirectory(Path.withoutExtension(chart)).contains('-metadata'))
				metadataFile(chart, chartisjdi);
		}

		for (songName => songDiffs in pairs)
		{
			trace('$songName');

			for (diff => diffData in songDiffs)
			{
				if (diffData.length == 0)
					continue;
				if (diffData[0] == null)
					continue;

				final songNotes:Dynamic = diffData[0];
				final songEvents:Dynamic = diffData[1];

				currentChart = {
					song: songName,
                    notes: songNotes
				};

				datas.set(currentChart.song, [(diff == 'normal') ? '' : '-$diff', currentChart]);
			}
		}

		trace('Results: ');
		for (song => chart in datas)
		{
			trace(' * $song');

            final dir = 'assets/preload/data/songs/$song';

            FileSystem.createDirectory(dir);

            File.saveContent('$dir/$song${chart[0]}.json', Json.stringify(chart[1], '\t'));
		}
	}

	static function chartFile(chart:String, pairName:String)
	{
		var parsed:Dynamic = Json.parse(File.getContent(chart));

		var notesField:Dynamic = parsed.notes;

		for (difficulty in notesField.fields())
		{
			// trace(difficulty);

			var notes:Array<Dynamic> = notesField.field(difficulty);
			var newNotes:Array<SectionData> = [];

			for (i => note in notes)
			{
				if (newNotes.length - 1 < (i % 16))
					newNotes.push({
						lengthInSteps: 16,
						bpm: null,
						changeBPM: false,
						mustHitSection: true,
						sectionNotes: [],
						typeOfSection: 0,
						altAnim: false
					});
			}

			// trace(newNotes);

			for (i => note in notes)
			{
				var time = note.t;
				var direction = note.d;
				var length = note.l ?? 0;
				var kind = note.k;

				newNotes[i % 16].sectionNotes.push([time, direction, length, kind]);

				newNotes[i % 16].sectionNotes.sort((a, b) -> Std.int(a[0] - b[0]));
			}

			pairs.get(pairName).get(difficulty)[0] = newNotes;
		}
	}

	static function metadataFile(chart:String, pairName:String)
	{
		var parsed = Json.parse(File.getContent(chart));
	}
}
