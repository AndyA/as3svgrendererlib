package com.tobydietrich.svg
{
	import flexunit.framework.TestCase;

	public class SVGParserTest extends TestCase
	{
		public function SVGParserTest(methodName:String=null)
		{
			super(methodName);
		}
		public function testRectangles():void {
			var p:SVGParser = new SVGParser(TestImages.rectangles);
			assertTrue(p.xml + "!=" + TestImages.rectanglesResult, p.xml == TestImages.rectanglesResult);
		}
		public function testCircles():void {
			var p:SVGParser = new SVGParser(TestImages.circles);
			assertTrue(p.xml + "!=" + TestImages.circlesResult, p.xml == TestImages.circlesResult);
		}
		public function testEllipses():void {
			var p:SVGParser = new SVGParser(TestImages.ellipses);
			assertTrue(p.xml + "!=" + TestImages.ellipsesResult, p.xml == TestImages.ellipsesResult);
			
		}
		
		
	}
}