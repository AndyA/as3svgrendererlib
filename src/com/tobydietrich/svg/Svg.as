package com.tobydietrich.svg
{
	import flash.display.Sprite;

	public class Svg extends SVGRenderer
	{
		public function Svg(svg:XML)
		{
			var myAST:SVGParser = new SVGParser(svg);
			super(myAST.xml);
		}
		
	}
}