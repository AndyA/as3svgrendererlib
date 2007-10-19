package com.tobydietrich.svg
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.StringUtil;
	
	import org.apache.batik.parser.*;
	import org.apache.batik.parser.PathParser;
	
	public class SVGParser
	{
		private var mySVG:XML;
		
		private var mySVGAST:XML;
        
		public function SVGParser(svg:XML) {
			if(svg == null) throw new SVGParseError("svg cannot be null");
			mySVG = svg;
			mySVGAST = visit(svg);
		}
		public function get xml():XML {
			return mySVGAST;
		}
		
		// visit a node in the xml tree with the specified environment
		private function visit(elt:XML):XML {
			
			elt.@styleenv = styleMerge(elt.parent.@styleenv, elt.@style);
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
				notSupported("tag '" + elt.localName() + "'");
				return null;
			}
		}
		private function visitSvg(elt:XML):XML {
			// parse
			var viewBox:Rectangle = parseViewBox(elt.@viewBox);
			
			// AST
			var ast:XML = <svg viewBoxWidth={viewBox.width} viewBoxHeight={viewBox.height} />;
			for each(var e:XML in elt.*) {
				ast.appendChild(visit(e));
			}
			return ast;
		}
		
		private function visitRect(elt:XML):XML {
			// parse
			var w:Number = getNumber(elt.@width);
			var h:Number = getNumber(elt.@height);
			var styles:XML = getStyle(elt);
			var fill:String = getColor(styles.@fill);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			var px:Number = getNumber(elt.@x);
			var py:Number = getNumber(elt.@y);
			var rx:Number = getNumber(elt.@rx);
			var ry:Number = getNumber(elt.@ry);
			var isComplex:Boolean = rx != 0 || ry != 0;
			if (isComplex) {
				rx = (ry != 0 && rx == 0)?ry:rx;
				ry = (rx != 0 && ry == 0)?rx:ry;
			}
			
			// AST
			return <rect width={w} height={h} x={px} y={py} isComplex={isComplex} 
			 rx={rx} ry={ry} fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
		}
		private function visitPath(elt:XML):XML {
			// parse
			var styles:XML = getStyle(elt);
			var fill:String = getColor(styles.@fill);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			
			var path:XML = <path fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
			
			//var h:ASPathHandler = new ASPathHandler();
			var h:ASPathNormalizer = new ASPathNormalizer();
			h.addEventListener(Event.COMPLETE, function eComplete(event:Event):void {
				path.setChildren(event.target.listHandler.*);
				path.@type = event.target.listHandler.@type;
				//trace(path);
			});
			var pathParser:PathParser = new PathParser();
			pathParser.setPathHandler(h);
			pathParser.parse(elt.@d);
			
			
         	
         	// AST
         	return path;
		}
		private function visitPolywhatever(elt:XML, isPolygon:Boolean):XML {
			// parse
			var styles:XML = getStyle(elt);
			var fill:String = getColor(styles.@fill);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			
			var MoveToRe:RegExp = /\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            var PointsRe:RegExp = /[,\s]\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)/;
            
			var points:String = elt.@points;
			var arrPoint:Object = {};
			
			if(points == null) {
				throw new SVGParseError("points cannot be null " + elt.toXMLString());
			}
			
			if(!MoveToRe.test(points)) {
				throw new SVGParseError("must have a first point " + elt.@points);
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
                points = StringUtil.trim(points);
                if(points=="") { 
                	break;
                }
                throw new SVGParseError("Unrecogized gunk in points attribute: " + elt.@points);

            }

			// AST
			var ast:XML;
			if(isPolygon) {
				ast = <polygon stroke={stroke} stroke-width={strokeWidth} fill={fill} />;
			} else {
				ast = <polyline stroke={stroke} stroke-width={strokeWidth} />;
			}
			ast.appendChild(<startPoint x={startPoint.x} y={startPoint.y} />);
			for each(var p:Point in arrPoint) {
            	ast.appendChild(<intermediatePoint x={p.x} y={p.y} />);
            }
            return ast;
		}
		private function visitPolygon(elt:XML):XML {
			return visitPolywhatever(elt, true);
		}
		private function visitPolyline(elt:XML):XML {
			return visitPolywhatever(elt, false);
		}
		private function visitLine(elt:XML):XML {
			// parse
			var p1:Point = new Point(getNumber(elt.@x1, true), getNumber(elt.@y1, true));
			var p2:Point = new Point(getNumber(elt.@x2, true), getNumber(elt.@y2, true));
			var styles:XML = getStyle(elt);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			
			// AST
			return <line x1={p1.x} y1={p1.y} x2={p2.x} y2={p2.y} stroke={stroke} stroke-width={strokeWidth} />;
		}
		private function visitCircle(elt:XML):XML {
			// parse
			var c:Point = new Point(getNumber(elt.@cx), getNumber(elt.@cy));
			var r:Number = getNumber(elt.@r, true);
			var styles:XML = getStyle(elt);
			var fill:String = getColor(styles.@fill);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			// AST
			return <circle cx={c.x} cy={c.y} r={r} fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
		}
		private function visitEllipse(elt:XML):XML {
			// parse
			var c:Point = new Point(getNumber(elt.@cx), getNumber(elt.@cy));
			var rx:Number = getNumber(elt.@rx, true);
			var ry:Number = getNumber(elt.@ry, true);
			var styles:XML = getStyle(elt);
			var fill:String = getColor(styles.@fill);
			var stroke:String = getColor(styles.@stroke);
			var strokeWidth:int = int(styles["stroke-width"]);
			// AST
			return <ellipse cx={c.x} cy={c.y} rx={rx} ry={ry} fill={fill} stroke={stroke} stroke-width={strokeWidth} />;
		}
		private function visitG(elt:XML):XML {
			// parse
			var m:Matrix = parseMatrix(elt.@transform);
			
			// AST
			var ast:XML = <g a={m.a} b={m.b} c={m.c} d={m.d} tx={m.tx} ty={m.ty} />;
			for each(var e:XML in elt.*) {
				ast.appendChild(visit(e));
			}
			return ast;
		}
		private function visitDefs(elt:XML):XML {
			//parse
			var retVal:XML = elt;
			for each(var e:XML in elt.*) {
				retVal.appendChild(visit(e));
			}
			notImplemented("defs");
			// AST
			return retVal;
		}
		
		private function visitClipPath(elt:XML):XML {
			//parse
			var retVal:XML = elt;
			for each(var e:XML in elt.*) {
				retVal.appendChild(visit(e));
			}
			notImplemented("clipPath");
			// AST
			return retVal;
		}
		
		private function visitUse(elt:XML):XML {
			//parse
			var retVal:XML = elt;
			for each(var e:XML in elt.*) {
				retVal.appendChild(visit(e));
			}
			notImplemented("use");
			// AST
			return retVal;
		}
		
		
		// helpers
		private static function getNumber(s:Object, required:Boolean=false):Number {
			return new Number(s);
			// FIXME
			if(s instanceof Number) return s;
			if(required && !(s instanceof String) && !MyStringUtil.isNumeric(String(s))) {
				throw new SVGRendererError("failed get number");
			}
			return (!(s instanceof String))?0:new Number(s);
		}
		private static function parseMatrix(m:String):Matrix {
			if(m.length == 0) {
				return new Matrix();
			}
			if(m.indexOf("matrix") != 0) {
				throw new Error("not a matrix");
			}
			var start:int = m.indexOf("(");
			var end:int = m.indexOf(")");

			try {
				var elts:String = m.substring(start, end);
				elts = elts.replace("(", "").replace(")", "");
				var params:Object = elts.split(/,\s/);
				if(params.length() != 6) {
					notSupported("matrix is not expected length");
				}
				return new Matrix(params[0], params[1], params[2], params[3], params[4], params[5]);
			} catch(e:Error) {
				throw new SVGParseError("error in matrix representation: " + m);
			}
			throw new Error("unreachable code");
		}
		private static function styleMerge(env:String, style:String):String {
			// TODO?
			if(env != "" && env.substring(env.length-1) != ";") {
				env += ";";
			}
			return env + style;
		}
		private static function getStyle(elt:XML):XML {
			var env:String = elt.@styleenv;
			var envElts:Array = env.split(/;\s*/);
			var retVal:XML = <styles />;
			var keyValueSplitter:Function =  function(element:*, index:int, arr:Array):void {
				var elt:String = element as String;
				if(elt.length == 0) {
					return;
				}
				var splitElt:Array = elt.split(/:/);
				if(splitElt.length != 2) {
					throw new SVGParseError("can't parse stylesheet");
				}
				this.@[splitElt[0]] = splitElt[1];
			};
			envElts.forEach(keyValueSplitter, retVal);
			return retVal;
		}
		private static function getColor(c:String):String {
			return c;
		}
		private static function chomp(s:String, result:Object):String {
			return s.substr(result.index + result[0].length);
		}
		private static function notImplemented(s:String):void {
			trace("parser has not implemented: " + s);
			//throw SVGNotImplementedException(s);
		}
		private static function notSupported(s:String):void {
			trace("not supported: " + s);
			throw SVGNotSupportedException(s);
		}
		private static function parseViewBox(viewBox:String):Rectangle {
			var params:Object = viewBox.split(/\s/);
			return new Rectangle(params[0], params[1], params[2], params[3]);
		}
	}
}