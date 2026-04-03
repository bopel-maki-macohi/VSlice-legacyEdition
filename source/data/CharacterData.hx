package data;

typedef CharacterData =
{
	?path:String,
	animations:Array<
		{
			name:String,
			prefix:String,

			?looping:Bool,
			?offsets:Array<Null<Float>>,
		}>,
	?offsets:Array<Null<Float>>,
	?scale:Array<Float>,
	?flipX:Bool,
	?flipY:Bool,
}
