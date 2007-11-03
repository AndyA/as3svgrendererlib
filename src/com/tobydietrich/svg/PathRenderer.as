package com.tobydietrich.svg
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.w3c.dom.svg.SVGPathSeg;
	
	/**
	 * Renders a class from a normalized AST
	 */
	public class PathRenderer implements IPathDrawer
	{
		private var myPenX:Number;
		private var myPenY:Number;
		private var myPenSprite:Sprite;
		
		public function get penX():Number {
			return myPenX;
		}
		public function get penY():Number {
			return myPenY;
		}
		public function get penSprite():Sprite {
			return myPenSprite;
		}
		private var first:Point = new Point();
		
		public function PathRenderer(s:Sprite, path:XML) {
			//trace(path.parent().parent().toXMLString());
			myPenSprite = s;
			var i:int = 0;
			for each(var e:XML in path.*) {
				if(i == 0) {
					first.x = e.@x;
					first.y = e.@y;
				}
				i++;
				var name:String = e.name();
				switch(name) {
					case "SVGPathSegMovetoLinetoItem":
						if(e.@type==SVGPathSeg.PATHSEG_MOVETO_ABS) {
							moveto(e);
						} else if (e.@type == SVGPathSeg.PATHSEG_LINETO_ABS) {
							lineto(e);
						} else {
							throw new Error("parse error in movetoLineto");
						}
						break;
					case "SVGPathSegCurvetoCubicItem":
						curvetoCubic(e);
						break;
					case 'SVGPathSegCurvetoQuadraticItem':
						curvetoQuadratic(e);
						break;
					case 'SVGPathSegArcAbsItem':
						arcAbs(e);
						break;
					case "SVGPathSegGenericItem":
						if(e.@type == SVGPathSeg.PATHSEG_MOVETO_ABS) {
							moveto(e);
						} else {
							throw new Error("parse error in SVGPathSegGenericItem");
						}
						break;
					case "SVGPathSegItem":
						if(e.@type == SVGPathSeg.PATHSEG_CLOSEPATH) {
							closePath(e);
						} else {
							throw new Error("parse error in SVGPathSegItem");
						}
						break;
					default:
						throw new Error("unknown name " + e.name() + e.toXMLString());
				}
			}
		}
		public function moveto(e:XML):void {
			penSprite.graphics.moveTo(e.@x, e.@y);
			updatePen(e.@x, e.@y);
		}
		public function lineto(e:XML):void {
			penSprite.graphics.lineTo(e.@x, e.@y);
			updatePen(e.@x, e.@y);
		}
		public function curvetoCubic(e:XML):void {
			var p:SVGPen = new SVGPen(this);
			p.curveToCubic(e.@x1, e.@y1, e.@x2, e.@y2, e.@x, e.@y);
			updatePen(e.@x, e.@y);
		}
		public function curvetoQuadratic(e:XML):void {
			penSprite.graphics.curveTo(e.@x1, e.@y1, e.@x, e.@y);
			updatePen(e.@x, e.@y);
		}
		public function closePath(e:XML):void {
			penSprite.graphics.lineTo(first.x,first.y);
			updatePen(first.x, first.y);
		}
		public function arcAbs(e:XML):void {
			var p:SVGPen = new SVGPen(this);
			p.arcAbs(e.@rx, e.@ry, e.@xAxisRotation, e.@largeArcFlag, e.@sweepFlag, e.@x, e.@y);
			updatePen(e.@x, e.@y);
		}
		private function updatePen(x:Number, y:Number):void {
			myPenX = x;
			myPenY = y;
			//trace(new XML(<myPen x={x} y={y} />).toXMLString());
		}
	}
}