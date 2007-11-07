package com.tobydietrich.svg
{
	import flash.display.*;
	import flash.geom.*;
	
	public class ViewWindowMinimizer
	{	
		public static function minimizeViewWindow(svg:Sprite):void {		
			var activeArea:Sprite = getActiveArea(svg);
			var viewBox:Sprite = getViewBox(svg);
			
			activeArea.x = 0;
			activeArea.y = 0;
			
			var width:int = activeArea.width;
			var height:int = activeArea.height;
				

			// scale up to full viewbox
			activeArea.width = viewBox.width;
		    activeArea.height = viewBox.height;
		    
		    viewBox.width = width;
		    viewBox.height = height;
		}
		
		public static function fitInContainer(myContainer:Sprite, mySVG:Sprite):void {
			var scale:Number = Math.min(myContainer.width/mySVG.width, myContainer.height/mySVG.height);
			mySVG.scaleX = mySVG.scaleY = scale;
		}
		
		public static function expandToContainer(myContainer:Sprite, mySVG:Sprite):void {
			mySVG.width = myContainer.width;
			mySVG.height = myContainer.height;
		}
		
		
		private static function getViewBox(svg:Sprite):Sprite {
			return svg.getChildAt(0) as Sprite;
				
		}
		
		private static function getActiveArea(svg:Sprite):Sprite {
			return getViewBox(svg).getChildAt(0) as Sprite;
		}
	}
}