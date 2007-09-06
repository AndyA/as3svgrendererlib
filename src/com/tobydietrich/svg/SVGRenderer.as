/**
 * Renders an SVG file as a flash DisplayObject. Does not allow manipulation of svg file
 */
package com.tobydietrich.svg
{
	import flash.display.Sprite;
	
	import flash.geom.Matrix;
	
	public class SVGRenderer extends Sprite
	{
		private var mySVG:XML;
		
		public function SVGRenderer(svg:XML) {
			mySVG = svg;
			addChild(visit(svg));
		}
		
		// visit a node in the xml tree with the specified environment
		private function visit(elt:XML):Sprite {
			
			elt.@styleenv = styleMerge(elt.parent.@styleenv, elt.@style);
			switch(elt.localName()) {
				case 'svg':
				return handleSvg(elt);
				
				case 'text':
				return handleText(elt);
				
				case 'rect':
				return handleRect(elt);
				
				case 'path':
				return handlePath(elt);
				
				case 'polygon':
				return handlePolygon(elt);
				
				case 'polyline':
				return handlePolyline(elt);
				
				case 'line':
				return handleLine(elt);
				
				case 'circle':
				return handleCircle(elt);
				
				case 'g':
				return handleG(elt);
				
				case 'a':
				return handleA(elt);
				
				default:
				throw new SVGRendererError("Unknown tag type " + elt.localName());
			}
		}
		private function handleSvg(elt:XML):Sprite {
			// parse element
			var w:Number = 600; //(isPct(elt.@width))?pct(elt.@width)*this.parent.width:getAbs(elt.@width); // FIXME
			var h:Number = 600; //(isPct(elt.@height))?pct(elt.@height)*this.parent.height:getAbs(elt.@height); // FIXME
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF); // FIXME?
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function handleText(elt:XML):Sprite {
			var px:Number = (elt.@x==null)?0:elt.@x;
			var py:Number = (elt.@y==null)?0:elt.@y;
			
			var s:Sprite = new Sprite();
			s.x = px;
			s.y = py;
			// s.graphics. // Draw text
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function handleRect(elt:XML):Sprite {
			// parse
			var w:Number = 600; //(isPct(elt.@width))?pct(elt.@width)*this.parent.width:getAbs(elt.@width); // FIXME
			var h:Number = 600; //(isPct(elt.@height))?pct(elt.@height)*this.parent.height:getAbs(elt.@height); // FIXME
			var fill:Number = getColor(elt.@fill);
			var px:Number = (elt.@x==null)?0:elt.@x;
			var py:Number = (elt.@y==null)?0:elt.@y;
			var isComplex:Boolean = !(elt.@rx == null && elt.@ry == null);
			var rx:Number;
			var ry:Number;
			if (isComplex) {
				rx = (elt.@rx==null)?0:elt.@rx;
				ry = (elt.@ry==null)?0:elt.@ry;
				rx = (ry != 0 && rx == 0)?ry:rx;
				ry = (rx != 0 && ry == 0)?rx:ry;
			}
			
			var s:Sprite = new Sprite();
			s.x = px;
			s.y = py;
			s.graphics.beginFill(fill);
			s.graphics.lineStyle(); // FIXME
			if(isComplex) {
				s.graphics.drawRoundRectComplex(0, 0, 
				 w, h, rx, ry, rx, ry); // FIXME
			} else {
				s.graphics.drawRect(0, 0, w, h);
			}
			s.graphics.endFill();
			return s;
		}
		private function handlePath(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			/*
			 *  Handle the dreaded "d" attribute
             * It'll look something like this
             * M10 405 h275 M205 405 v35 M10 426 h195 M205 422 h80
         	 * M=absolute moveto
         	 * m=relative moveto
         	 * H=absolute hortizontal (cpx, cpy) to (x, cpy)
         	 * h=relative horizontal 
         	 * V=absolute vertical (cpx, cpy) to (cpx, y)
         	 * v=relative vertical
         	 */
         	// TODO: import the code.
			return s;
		}
		private function handlePolywhatever(elt:XML, isPolygon:Boolean):Sprite {
			var MoveToRe:RegExp = /\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            var PointsRe:RegExp = /[,\s]\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            var WhitespaceRe:RegExp = /s*/;
            
			var s:Sprite = new Sprite();
			
			if(elt.@points == null) {
				throw new SVGRendererError("points cannot be null " + elt.toXMLString());
			}
			var points:String = elt.@points;
			
			if(!MoveToRe.test(points)) {
				throw new SVGRendererError("must have a first point " + elt.@points);
			}
            var result:Object = MoveToRe.exec(points);
            s.x = result[1];
            s.y = result[3];
            points = points.substr(result.index + result[0].length());
            while(true) {
                result = PointsRe.exec(points);
                if(result != null) {
                	var px:Number = result[1];
                	var py:Number = result[3];
                    s.graphics.lineTo(px, py);
                    points = points.substr(result.index + result[0].length());
                	continue;
                }
                result = WhitespaceRe.exec(points);
                if(result != null) {
                	points = points.substr(result.index + result[0].length());
                }
                if(points=="") { 
                	break;
                }
                throw new SVGRendererError("Unrecogized gunk in points attribute: " + elt.@points);

            }
            if(isPolygon) {
            	s.graphics.lineTo(0, 0);
            }
			return s;
		}
		private function handlePolygon(elt:XML):Sprite {
			return handlePolywhatever(elt, true);
		}
		private function handlePolyline(elt:XML):Sprite {
			return handlePolywhatever(elt, false);
		}
		private function handleLine(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@x1;
			s.y = elt.@y1;
			s.graphics.lineStyle(); // TODO
			s.graphics.lineTo(elt.@x2, elt.@y2);
			return s;
		}
		private function handleCircle(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.x = elt.@cx;
			s.y = elt.@cy;
			s.graphics.lineStyle(); // TODO
			s.graphics.beginFill(0xFF0000); // TODO
			s.graphics.drawCircle(0, 0, elt.@r);
			return s;
		}
		private function handleG(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.transform.matrix = parseMatrix(elt.@transform);
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function handleA(elt:XML):Sprite {
			var s:Sprite = new Sprite();
			s.useHandCursor = true; // TODO
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		// helpers
		private function parseMatrix(m:String):Matrix {
			// TODO
			return new Matrix(); // identity transform
		}
		private function styleMerge(env:String, style:String):String {
			// TODO
			if(env != "" && env.substring(env.length-1) != ";") {
				env += ";";
			}
			return env + style;
		}
		private function getColor(c:String):uint {
			return uint(c);
		}
		private function isPct(s:Object):Boolean {
			return (s==null)?false:String(s).lastIndexOf("%") >= 0;
		}
		private function pct(s:Object):Number {
			return (s==null)?0:int(String(s).substring(0, s.length-2))/100;
		}
		private function getAbs(s:Object):Number {
			return (s==null)?0:int(String(s));
		}
	}
}