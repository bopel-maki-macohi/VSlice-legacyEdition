package data;

typedef StorymodePropData =
{
	?path:String,
	animations:Array<
		{
			name:String,
			prefix:String,

			?looping:Bool,
			?offsets:Array<Float>,
		}>,
	?offsets:Array<Float>,
	?scale:Array<Float>,
	?flipX:Bool,
	?flipY:Bool,
}
