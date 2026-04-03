package data;

typedef CharacterData =
{
	?path:String,
	animations:Array<
		{
			name:String,
			prefix:String,
			?indices:Array<Int>,
			?postfix:String,
			?looping:Bool,
			?offsets:Array<Float>,
		}>,
	?offsets:Array<Float>,
	?scale:Array<Float>,
	?flipX:Bool,
	?flipY:Bool,
	?offsetFile:String,
	?packer:Bool,
	?startingAnim:String,
	?antialiasing:Bool,
	?isPixel:Bool,
}
