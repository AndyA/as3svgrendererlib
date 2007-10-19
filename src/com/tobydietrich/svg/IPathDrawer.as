package com.tobydietrich.svg
{
	import flash.display.Sprite;
	
	public interface IPathDrawer
	{
		function get penX():Number;
		function get penY():Number;
		function get penSprite():Sprite;
	}
}