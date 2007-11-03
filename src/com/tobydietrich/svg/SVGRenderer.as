/**
 * Renders an SVG AST representation as a flash DisplayObject. Does not allow manipulation of svg file
 */
package com.tobydietrich.svg
{
	import flash.display.*;
	import flash.geom.*;
	
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
				
				case 'notSupported':
				return new Sprite();
				
				default:
				throw new SVGRenderError("Unknown tag type " + elt.localName());
			}
		}
		private function visitSvg(elt:XML):Sprite {
			// the view box
			var viewBox:Sprite = new Sprite();
			viewBox.name = "viewBox";
			viewBox.graphics.drawRect(0,0,elt.@viewBoxWidth,elt.@viewBoxHeight);
			
			var activeArea:Sprite = new Sprite();
			activeArea.name = "activeArea";
			viewBox.addChild(activeArea);
		
			
			// iterate through the children of the svg node
			for each(var childElt:XML in elt.*) {
				activeArea.addChild(visit(childElt));
			}
			
			return viewBox;
		}
		
		private function visitRect(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "rectangle";
			s.x = elt.@x;
			s.y = elt.@y;
			beginFill(s, elt);
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
         	s.name = "path";
			beginFill(s, elt);
         	s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
         	var p:PathRenderer = new PathRenderer(s,elt);
         	s.graphics.lineStyle();
         	s.graphics.endFill();
			return s;
		}
		private function visitPolywhatever(elt:XML, isPolygon:Boolean):Sprite {
            var s:Sprite = new Sprite();
            s.name = isPolygon ? "polygon" : "polyline";
           
            s.x = elt.startPoint.@x;
            s.y = elt.startPoint.@y;
            
            s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
            if(isPolygon) {
				beginFill(s, elt);
            }
            var index:int = 0;
            for each(var e:XML in elt.intermediatePoint) {
            	s.graphics.lineTo(e.x, e.y);
            	index++;
            }
            if(isPolygon) {
            	s.graphics.lineTo(0, 0);
            	s.graphics.endFill();
            }
            s.graphics.lineStyle();
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
			s.name = "line";
			s.x = elt.@x1;
			s.y = elt.@y1;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			s.graphics.lineTo(elt.@x2, elt.@y2);
			s.graphics.lineStyle();
			return s;
		}
		private function visitCircle(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "circle";
			s.x = elt.@cx;
			s.y = elt.@cy;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			beginFill(s, elt);
			s.graphics.drawCircle(-elt.@r/2, -elt.@r/2, elt.@r);
			s.graphics.endFill();
			s.graphics.lineStyle();
			return s;
		}
		private function visitEllipse(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "ellipse";
			s.x = elt.@cx;
			s.y = elt.@cy;
			s.graphics.lineStyle(elt.@strokeWidth, getColor(elt.@stroke));
			beginFill(s, elt);
			s.graphics.drawEllipse(-elt.@rx/2, -elt.@ry/2, elt.@rx, elt.@ry);
			s.graphics.endFill();
			s.graphics.lineStyle();
			return s;
		}
		private function visitG(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "g";
			s.transform.matrix = new Matrix(elt.@a, elt.@b, elt.@c, elt.@d, elt.@tx, elt.@ty);
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function visitDefs(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "defs";
			
			notImplemented("defs");
			return s;
		}
		
		private function visitClipPath(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "clipPath";
			
			notImplemented("clipPath");
			return s;
		}
		
		private function visitUse(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.name = "use";
			
			notImplemented("use");
			return s;
		}
		private static function beginFill(s:Sprite, elt:XML):void {
			var color:uint = getColor(elt.@fill);
			var noFill:Boolean = elt.@fill == null || elt.@fill == '' || elt.@fill=='none';
			s.graphics.beginFill(color, noFill?0:1);
		}
		private static function getColor(s:String):uint {
			// FIXME
			return new Number("0x" + s.substring(1));
		}
		private static function notImplemented(s:String):void {
			trace("renderer has not implemented " + s);
		}
	}
}