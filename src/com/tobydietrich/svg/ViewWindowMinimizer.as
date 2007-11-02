package com.tobydietrich.svg
{
	import flash.display.Sprite;
	
	public class ViewWindowMinimizer
	{
		
		// transform the sprite so that it fills the viewBox
		public static function scaleUp(svg:Sprite):void {
			var activeArea:Sprite = getActiveArea(svg);
			var viewBox:Sprite = getViewBox(svg);
			// scale up to full viewbox
			activeArea.width = viewBox.width;
		    activeArea.height = viewBox.height;
		    // scale down the larger scale factor
		    if(activeArea.scaleX < activeArea.scaleY) {
		    	activeArea.scaleY = activeArea.scaleX;
		    } else {
		    	activeArea.scaleX = activeArea.scaleY;
		    }
		}
		// transform sprite, then viewbox
		public static function resizeContainer(svg:Sprite):void {
			var activeArea:Sprite = getActiveArea(svg);
			var viewBox:Sprite = getViewBox(svg);
			// scale up to full viewbox
			var width:int = activeArea.width;
			var height:int = activeArea.height;
			activeArea.width = viewBox.width;
		    activeArea.height = viewBox.height;
		    viewBox.width = width;
		    viewBox.height = height;
		}
		
		public static function getViewBox(svg:Sprite):Sprite {
			return svg.getChildAt(0) as Sprite;
				
		}
		
		public static function getActiveArea(svg:Sprite):Sprite {
			return getViewBox(svg).getChildAt(0) as Sprite;
		}
	}
}