/**
 * Renders an SVG AST representation as a flash DisplayObject. Does not allow manipulation of svg file
 */
package com.tobydietrich.svg
{
	import flash.display.Sprite;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SVGRenderer extends Sprite
	{
		private var mySVGAST:XML;
		
		public function SVGRenderer(svgAST:XML) {
			mySVGAST = svgAST;
			addChild(visit(svgAST));
		}
		
		
		// visit a node in the xml tree with the specified environment
		private function visit(elt:XML):Sprite {
			switch(elt.localName()) {
				case 'svg':
				return visitSvg(elt);
				
				case 'rect':
				return visitRect(elt);
				
				case 'path':
				return visitPath(elt);
				
				case 'polygon':
				return visitPolygon(elt);
				
				case 'polyline':
				return visitPolyline(elt);
				
				case 'line':
				return visitLine(elt);
				
				case 'circle':
				return visitCircle(elt);
				
				case 'ellipse':
				return visitEllipse(elt);
				
				case 'g':
				return visitG(elt);
				
				case 'defs':
				return visitDefs(elt);
				
				case 'clipPath':
				return visitClipPath(elt);
				
				case 'use':
				return visitUse(elt);
				
				default:
				throw new SVGRenderError("Unknown tag type " + elt.localName());
			}
		}
		private function visitSvg(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			// don't want to draw the viewBox
			//s.graphics.beginFill(0xFFFFFF);
			//s.graphics.drawRect(0,0,elt.@width,elt.@height);
			//s.graphics.endFill();
			// TODO: move the child sprite to the upper left corner
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			
			// normalize to a certain size (100x100)
			var r:Rectangle = s.transform.pixelBounds;
			for(var i:int = 0; i < s.numChildren; i++) {
				//s.getChildAt(i).x -= r.left;
				//s.getChildAt(i).y -= r.top;
			}
			s.scaleX = 200/r.width;
			s.scaleY = 200/r.height;
			return s;
		}
		private function visitRect(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@x;
			s.y = elt.@y;
			var fill:uint = getColor(elt.@fill);
			s.graphics.beginFill(getColor(elt.@fill));
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			if(elt.@isComplex) {
				s.graphics.drawRoundRectComplex(0, 0, 
				 elt.@width, elt.@height, elt.@rx, elt.@ry, elt.@rx, elt.@ry); // FIXME
			} else {
				s.graphics.drawRect(0, 0, elt.@width, elt.@height);
			}
			s.graphics.endFill();
			return s;
		}
		private function visitPath(elt:XML):Sprite {
         	var s:Sprite = new Sprite();
         	s.graphics.beginFill(getColor(elt.@fill));
         	s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
         	notImplemented("path");
         	s.graphics.endFill();
			return s;
		}
		private function visitPolywhatever(elt:XML, isPolygon:Boolean):Sprite {
            var s:Sprite = new Sprite();
            s.x = elt.startPoint.@x;
            s.y = elt.startPoint.@y;
            s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
            if(isPolygon) {
            	s.graphics.beginFill(getColor(elt.@fill));
            }
            for each(var e:XML in elt.intermediatePoint) {
            	s.graphics.lineTo(e.x, e.y);
            }
            if(isPolygon) {
            	s.graphics.lineTo(0, 0);
            	s.graphics.endFill();
            }
			return s;
		}
		private function visitPolygon(elt:XML):Sprite {
			return visitPolywhatever(elt, true);
		}
		private function visitPolyline(elt:XML):Sprite {
			return visitPolywhatever(elt, false);
		}
		private function visitLine(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@x1;
			s.y = elt.@y1;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			s.graphics.lineTo(elt.@x2, elt.@y2);
			return s;
		}
		private function visitCircle(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@cx;
			s.y = elt.@cy;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			s.graphics.beginFill(getColor(elt.@fill));
			s.graphics.drawCircle(0, 0, elt.@r);
			s.graphics.endFill();
			return s;
		}
		private function visitEllipse(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@cx;
			s.y = elt.@cy;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			s.graphics.beginFill(getColor(elt.@fill));
			s.graphics.drawEllipse(0, 0, elt.@rx, elt.@ry);
			s.graphics.endFill();
			return s;
		}
		private function visitG(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.transform.matrix = new Matrix(elt.@a, elt.@b, elt.@c, elt.@d, elt.@tx, elt.@ty);
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function visitDefs(elt:XML):Sprite {
			notImplemented("defs");
			return new Sprite();
		}
		
		private function visitClipPath(elt:XML):Sprite {
			notImplemented("clipPath");
			return new Sprite();;
		}
		
		private function visitUse(elt:XML):Sprite {
			notImplemented("use");
			return new Sprite();
		}
		private static function getColor(s:String):uint {
			return (s=="none")?null:new Number("0x" + s.substring(1));
		}
		private static function notImplemented(s:String):void {
			trace("renderer has not implemented " + s);
		}
	}
}