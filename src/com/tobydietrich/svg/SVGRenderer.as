/**
 * Renders an SVG file as a flash DisplayObject. Does not allow manipulation of svg file
 * The functions in this file follow a lightweight AST method. First parse, then pass over the data to render.
 */
package com.tobydietrich.svg
{
	import flash.display.Sprite;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
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
			// parse
			var w:Number = 600; //(isPct(elt.@width))?pct(elt.@width)*this.parent.width:getAbs(elt.@width); // FIXME
			var h:Number = 600; //(isPct(elt.@height))?pct(elt.@height)*this.parent.height:getAbs(elt.@height); // FIXME
			
			// trace
			var traceXML:XML = <handleSvg width={w} height={h} />;
			traceXML.appendChild(elt);
			//trace(traceXML.toXMLString());
			
			// render
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
			// parse
			var px:Number = (elt.@x==null)?0:elt.@x;
			var py:Number = (elt.@y==null)?0:elt.@y;
			
			// trace
			var traceXML:XML = <handleText x={px} y={py} />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.x = px;
			s.y = py;
			// s.graphics. // TODO: Draw text
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
			var stroke:uint = getColor(elt.@stroke);
			var strokeWidth:int = int(elt.attribute("stroke-width"));
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
			
			// trace
			var traceXML:XML = <handleRect width={w} height={h} x={px} y={py} isComplex={isComplex} 
			 rx={rx} ry={ry} fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.x = px;
			s.y = py;
			s.graphics.beginFill(fill);
			s.graphics.lineStyle(strokeWidth, stroke);
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
			// parse
			var fill:uint = getColor(elt.@stroke);
			var stroke:uint = getColor(elt.@stroke);
			var strokeWidth:int = int(elt.attribute("stroke-width"));
			
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
         	var Mre:RegExp = /\s*M\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var mre:RegExp = /\s*m\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Lre:RegExp = /\s*L\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var lre:RegExp = /\s*l\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Vre:RegExp = /\s*V\s*(-?\d+(\.\d+)?)\s*/;
            var vre:RegExp = /\s*v\s*(-?\d+(\.\d+)?)\s*/;
            var Hre:RegExp = /\s*H\s*(-?\d+(\.\d+)?)\s*/;
            var hre:RegExp = /\s*h\s*(-?\d+(\.\d+)?)\s*/;
            var Tre:RegExp = /\s*T\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var tre:RegExp = /\s*t\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Qre:RegExp = /\s*Q\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var qre:RegExp = /\s*q\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Cre:RegExp = /\s*C\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var cre:RegExp = /\s*c\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Sre:RegExp = /\s*S\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var sre:RegExp = /\s*s\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var Are:RegExp = /\s*A\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var are:RegExp = /\s*a\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*/;
            var zre:RegExp = /\s*[Zz]\s*/;
         	 
         	// TODO: import the code.
         	/* while 1:
                m = Mre.match(path)
                if(m):
                    s.closepath(stylemap,1)
                    s.movePenTo(float(m.group(1)), float(m.group(3)))
                    path = Mre.sub("", path, 1)
                    s.resetorig()
                    continue
                m = mre.match(path)
                if(m):
                    s.closepath(stylemap,1)
                    s.movePen(float(m.group(1)), float(m.group(3)))
                    path = mre.sub("", path, 1)
                    s.resetorig()
                    continue
                m = Lre.match(path)
                if(m):
                    s.drawLineTo(float(m.group(1)), float(m.group(3)))
                    path = Lre.sub("", path, 1)
                    continue
                m = lre.match(path)
                if(m):
                    s.drawLine(float(m.group(1)), float(m.group(3)))
                    path = lre.sub("", path, 1)
                    continue
                m = Vre.match(path)
                if(m):
                    s.drawLineTo(s.cpx,float(m.group(1)))
                    path = Vre.sub("", path, 1)
                    continue
                m = vre.match(path)
                if(m):
                    s.drawLine(0,float(m.group(1)))
                    path = vre.sub("", path, 1)
                    continue
                m = Hre.match(path)
                if(m):
                    s.drawLineTo(float(m.group(1)),s.cpy)
                    path = Hre.sub("", path, 1)
                    continue
                m = hre.match(path)
                if(m):
                    s.drawLine(float(m.group(1)),0)
                    path = hre.sub("", path, 1)
                    continue
                m = Tre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    bx=qcx+(qcx-qbx)
                    by=qcy+(qcy-qby)
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    qbx=bx
                    qby=by
                    qcx=cx
                    qcy=cy
                    s.drawCurveTo(bx,by,cx,cy)
                    path = Tre.sub("", path, 1)
                    continue
                m = tre.match(path)
                if(m):
                    bx=qcx+(qcx-qbx)-s.cpx
                    by=qcy+(qcy-qby)-s.cpy
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    qbx=bx+s.cpx
                    qby=by+s.cpy
                    qcx=cx+s.cpx
                    qcy=cy+s.cpy
                    s.drawCurve(bx,by,cx,cy)
                    path = tre.sub("", path, 1)
                    continue
                m = Qre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    qbx=bx
                    qby=by
                    qcx=cx
                    qcy=cy
                    s.drawCurveTo(bx,by,cx,cy)
                    path = Qre.sub("", path, 1)
                    continue
                m = qre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    qbx=bx+s.cpx
                    qby=by+s.cpy
                    qcx=cx+s.cpx
                    qcy=cy+s.cpy
                    s.drawCurve(bx,by,cx,cy)
                    path = qre.sub("", path, 1)
                    continue
                m = Cre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    dx=float(m.group(9))
                    dy=float(m.group(11))
                    acx=cx
                    acy=cy
                    adx=dx
                    ady=dy
                    s.drawCurveTo(bx,by,cx,cy,dx,dy)
                    path = Cre.sub("", path, 1)
                    continue
                m = cre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    dx=float(m.group(9))
                    dy=float(m.group(11))
                    acx=cx+s.cpx
                    acy=cy+s.cpy
                    adx=dx+s.cpx
                    ady=dy+s.cpy
                    s.drawCurve(bx,by,cx,cy,dx,dy)
                    path = cre.sub("", path, 1)

                    continue
                m = Sre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    bx=adx+(adx-acx)
                    by=ady+(ady-acy)
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    dx=float(m.group(5))
                    dy=float(m.group(7))
                    acx=cx
                    acy=cy
                    adx=dx
                    ady=dy
                    s.drawCurveTo(bx,by,cx,cy,dx,dy)
                    path = Sre.sub("", path, 1)
                    continue
                m = sre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    printout("path", " --  cpx: %d cpy: %d acx: %d acy: %d" % (s.cpx, s.cpy, acx, acy))
                    bx=adx+(adx-acx)-s.cpx
                    by=ady+(ady-acy)-s.cpy
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    dx=float(m.group(5))
                    dy=float(m.group(7))
                    acx=cx+s.cpx
                    acy=cy+s.cpy
                    adx=dx+s.cpx
                    ady=dy+s.cpy
                    s.drawCurve(bx,by,cx,cy,dx,dy)
                    path = sre.sub("", path, 1)
                    continue
                m = Are.match(path)
                if(m):
                    rx=float(m.group(1))
                    ry=float(m.group(3))
                    x_axis_rotation=float(m.group(5))
                    large_arc_flag=float(m.group(7))
                    sweep_flag=float(m.group(9))
                    x=float(m.group(11))
                    y=float(m.group(13))
                    s.path_arc(rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)
                    path = Are.sub("", path, 1)
                    continue
                m = are.match(path)
                if(m):
                    rx=float(m.group(1))
                    ry=float(m.group(3))
                    x_axis_rotation=float(m.group(5))
                    large_arc_flag=float(m.group(7))
                    sweep_flag=float(m.group(9))
                    x=float(m.group(11))+s.cpx
                    y=float(m.group(13))+s.cpy
                    printout("path", "(rx=%d, ry=%d, x_axis_rotation=%d, large_arc_flag=%d, sweep_flag=%d, x=%d, y=%d)" % (rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y))
                    s.path_arc(rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)
                    printout("path", "After path_arc x: %d, y: %d" % (s.cpx, s.cpy))
                    path = are.sub("", path, 1)
                    continue
                m = zre.match(path)
                if(m):
                    s.closepath(stylemap, 0)
                    path = zre.sub("", path, 1)
                    continue
                if(path==""):
                    break
                raise AttributeError, "Unrecogized gunk in path attribute: " + path
			*/
         	
         	
         	// trace
         	var traceXML:XML = <handlePath fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());	
         	
         	// render
         	var s:Sprite = new Sprite();
         	s.graphics.beginFill(fill);
         	s.graphics.lineStyle(strokeWidth, stroke);
         	s.graphics.endFill();
			return s;
		}
		private function handlePolywhatever(elt:XML, isPolygon:Boolean):Sprite {
			// parse
			var fill:uint = getColor(elt.@fill);
		    var stroke:uint = getColor(elt.@stroke);
			var strokeWidth:int = int(elt.attribute("stroke-width"));
			
			var MoveToRe:RegExp = /\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            var PointsRe:RegExp = /[,\s]\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            var WhitespaceRe:RegExp = /s*/;
            
			var points:String = elt.@points;
			var arrPoint:Object = {};
			
			if(points == null) {
				throw new SVGRendererError("points cannot be null " + elt.toXMLString());
			}
			
			if(!MoveToRe.test(points)) {
				throw new SVGRendererError("must have a first point " + elt.@points);
			}
            var result:Object = MoveToRe.exec(points);
            var startPoint:Point = new Point(new Number(result[1]), new Number(result[3]));
           
            points = chomp(points, result);
            while(true) {
                result = PointsRe.exec(points);
                if(result != null) {
                    arrPoint[arrPoint.length] = new Point(new Number(result[1]), new Number(result[3]));
                    points = chomp(points, result);
                	continue;
                }
                result = WhitespaceRe.exec(points);
                if(result != null) {
                	points = chomp(points, result);
                }
                if(points=="") { 
                	break;
                }
                throw new SVGRendererError("Unrecogized gunk in points attribute: " + elt.@points);

            }

			// trace
			var traceXML:XML;
			if(isPolygon) {
				traceXML = <handlePolygon stroke={stroke} stroke-width={strokeWidth} fill={fill} />;
			} else {
				traceXML = <handlePolyline stroke={stroke} stroke-width={strokeWidth} />;
			}
			traceXML.appendChild(<startPoint x={startPoint.x} y={startPoint.y} />);
			for each(var p:Point in arrPoint) {
            	traceXML.appendChild(<intermediatePoint x={p.x} y={p.y} />);
            }
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
            // render
            var s:Sprite = new Sprite();
            s.x = startPoint.x;
            s.y = startPoint.y;
            s.graphics.lineStyle(strokeWidth, stroke);
            if(isPolygon) {
            	s.graphics.beginFill(fill);
            }
            for each(var p:Point in arrPoint) {
            	s.graphics.lineTo(p.x, p.y);
            }
            if(isPolygon) {
            	s.graphics.lineTo(0, 0);
            	s.graphics.endFill();
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
			// parse
			var p1:Point = new Point(new Number(elt.@x1), new Number(elt.@y1));
			var p2:Point = new Point(new Number(elt.@x2), new Number(elt.@y2));
			var stroke:uint = getColor(elt.@stroke);
			var strokeWidth:int = int(elt.attribute("stroke-width"));
			
			// trace
			var traceXML:XML = <handleLine x1={p1.x} y1={p1.y} x2={p2.x} y2={p2.y} stroke={stroke} stroke-width={strokeWidth} />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.x = p1.x;
			s.y = p1.y;
			s.graphics.lineStyle(strokeWidth, stroke);
			s.graphics.lineTo(p2.x, p2.y);
			return s;
		}
		private function handleCircle(elt:XML):Sprite {
			// parse
			var c:Point = new Point(new Number(elt.@cx), new Number(elt.@cy));
			var r:Number = elt.@r;
			var fill:uint = getColor(elt.@fill);
			var stroke:uint = getColor(elt.@stroke);
			var strokeWidth:int = int(elt.attribute("stroke-width"));
			// trace
			var traceXML:XML = <handleCircle cx={c.x} cy={c.y} r={r} fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.x = c.x;
			s.y = c.y;
			s.graphics.lineStyle(); // TODO
			s.graphics.beginFill(fill);
			s.graphics.drawCircle(0, 0, r);
			return s;
		}
		private function handleG(elt:XML):Sprite {
			// parse
			var m:Matrix = parseMatrix(elt.@transform);
			
			// trace
			var traceXML:XML = <handleG a={m.a} b={m.b} c={m.c} d={m.d} tx={m.tx} ty={m.ty} />;
			traceXML.appendChild(elt);
			//trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.transform.matrix = m;
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		private function handleA(elt:XML):Sprite {
			// parse
			
			// trace
			var traceXML:XML = <handleA />;
			traceXML.appendChild(elt);
			trace(traceXML.toXMLString());
			
			// render
			var s:Sprite = new Sprite();
			s.useHandCursor = true; // TODO
			for each(var childElt:XML in elt.*) {
				s.addChild(visit(childElt));
			}
			return s;
		}
		// helpers
		private static function parseMatrix(m:String):Matrix {
			// TODO
			return new Matrix(); // identity transform
		}
		private static function styleMerge(env:String, style:String):String {
			// TODO
			if(env != "" && env.substring(env.length-1) != ";") {
				env += ";";
			}
			return env + style;
		}
		private static function getColor(c:String):uint {
			return uint(c);
		}
		private static function isPct(s:Object):Boolean {
			return (s==null)?false:String(s).lastIndexOf("%") >= 0;
		}
		private static function pct(s:Object):Number {
			return (s==null)?0:new Number(String(s).substring(0, s.length-2))/100;
		}
		private static function getAbs(s:Object):Number {
			return (s==null)?0:new Number(String(s));
		}
		private static function chomp(s:String, result:Object):String {
			return s.substr(result.index + result[0].length());
		}
	}
}