﻿package com.lorentz.SVG.display {
	import com.lorentz.SVG.data.text.SVGDrawnText;
	import com.lorentz.SVG.display.base.SVGElement;
	import com.lorentz.SVG.display.base.SVGTextContainer;
	import com.lorentz.SVG.text.ISVGTextDrawer;
	import com.lorentz.SVG.utils.DisplayUtils;
	import com.lorentz.SVG.utils.SVGUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class SVGText extends SVGTextContainer {				
		public function SVGText(){
			super("text");
		}
		
		public var currentX:Number = 0;
		public var currentY:Number = 0;
		public var textDrawer:ISVGTextDrawer;
		public var textContainer:Sprite;
		
		private var _start:Number = 0;
		private var _end:Number = 0;
				
		protected override function render():void {
			super.render();
			
			while(content.numChildren > 0)
				content.removeChildAt(0);
			
			if(this.numTextElements == 0)
				return;
						
			textContainer = content;
			
			textDrawer = new document.textDrawerClass();
			textDrawer.start();
			
			var direction:String = getDirectionFromStyles() || "lr";
			var textDirection:String = direction;
			
			currentX = getUserUnit(svgX, SVGUtil.WIDTH);
			currentY = getUserUnit(svgY, SVGUtil.HEIGHT);
					
			_start = currentX;
			_renderObjects = new Vector.<DisplayObject>();
			
			var fillTextsSprite:Sprite;
			
			if(hasComplexFill)
			{
				fillTextsSprite = new Sprite();
				textContainer.addChild(fillTextsSprite);
			} else {
				fillTextsSprite = textContainer;
			}
			
			for(var i:int = 0; i < numTextElements; i++){
				var textElement:Object = getTextElementAt(i);
				
				if(textElement is String){
					var drawnText:SVGDrawnText = createTextSprite( textElement as String, textDrawer );
										
					if((drawnText.direction || direction) == "lr"){
						drawnText.displayObject.x = currentX - drawnText.startX;
						drawnText.displayObject.y = currentY - drawnText.startY;
						currentX += drawnText.textWidth;
					} else {
						drawnText.displayObject.x = currentX - drawnText.textWidth - drawnText.startX;
						drawnText.displayObject.y = currentY - drawnText.startY;
						currentX -= drawnText.textWidth;
					}
								
					if(drawnText.direction)	
						textDirection = drawnText.direction;
					
					fillTextsSprite.addChild(drawnText.displayObject);
					_renderObjects.push(drawnText.displayObject);
				} else if(textElement is SVGTextContainer) {
					var tspan:SVGTextContainer = textElement as SVGTextContainer;
															
					if(tspan.hasOwnFill()) {
						textContainer.addChild(tspan);
					} else
						fillTextsSprite.addChild(tspan);
					
					tspan.invalidateRender();
					tspan.validate();
					
					_renderObjects.push(tspan);
				}
			}
			
			_end = currentX;
			
			doAnchorAlign(textDirection, _start, _end);
			
			textDrawer.end();

			if(hasComplexFill && fillTextsSprite.numChildren > 0){
				var bounds:Rectangle = DisplayUtils.safeGetBounds(fillTextsSprite, content);
				bounds.inflate(2, 2);
				var fill:Sprite = new Sprite();
				beginFill(fill.graphics);
				fill.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
				fill.mask = fillTextsSprite;
				fillTextsSprite.cacheAsBitmap = true;
				fill.cacheAsBitmap = true;
				textContainer.addChildAt(fill, 0);
				
				_renderObjects.push(fill);
			}
		}
		
		override public function clone(deep:Boolean = true):SVGElement {
			var c:SVGText = super.clone(deep) as SVGText;
			c.svgX = svgX;
			c.svgY = svgY;
			
			return c;
		}
	}
}