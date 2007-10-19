package com.tobydietrich.svg
{
	import flash.display.*;
	import flash.geom.*;
	
	/** 
	 * Extends the graphics property of the target
	 */
	public class SVGPen
	{
		private var myTarget:IPathDrawer;
		
		public function SVGPen(target:IPathDrawer) {
		      myTarget = target;    
		 }
		 
/////////////////////////////////////////////////////////////////////////
//
// Bezier_lib.as - v1.2 - 19/05/02
// Timothee Groleau
//
// The purpose of this file is mainly to provide a function drawCubicBezier
// for the MovieClip prototype to approximate a cubic Bezier curve
// from the quadratic curveTo of the Flash drawing API
//
// By doing so, several useful functions are created to calculate cubic
// bezier points and derivative. Other Bezier functions can be added to
// the _global.Bezier object, like quadratic or quartic function as necessary.
//
// Also a few functions are added to the Math object to handle 2D line equations
//
/////////////////////////////////////////////////////////////////////////
	 
/////////////////////////////////////////////////////////////////////////
//
// Add a drawCubicBezier2 to the movieClip prototype based on a MidPoint 
// simplified version of the midPoint algorithm by Helen Triolo
//
/////////////////////////////////////////////////////////////////////////

// This function will trace a cubic approximation of the cubic Bezier
// It will calculate a serie of [control point/Destination point] which 
// will be used to draw quadratic Bezier starting from P0
		 public function curveToCubic(x1:Number, y1:Number, 
		 	x2:Number, y2:Number,
		 	x:Number, y:Number):void {
		 		
	 		// the start, end and control points
	 		var p0:Point = new Point(myTarget.penX, myTarget.penY);
	 		var p1:Point = new Point(x1, y1);
	 		var p2:Point = new Point(x2, y2);
	 		var p3:Point = new Point(x,y);
		 		
			// calculates the useful base points
			var pA:Point = getPointOnSegment(p0, p1, 3/4);
			var pB:Point = getPointOnSegment(p3, p2, 3/4);
			
			// get 1/16 of the [p3, p0] segment
			var dx:Number = (p3.x - p0.x)/16;
			var dy:Number = (p3.y - p0.y)/16;
			
			// calculates control point 1
			var controlPoint1:Point = getPointOnSegment(p0, p1, 3/8);
			
			// calculates control point 2
			var controlPoint2:Point = getPointOnSegment(pA, pB, 3/8);
			controlPoint2.x -= dx;
			controlPoint2.y -= dy;
			
			// calculates control point 3
			var controlPoint3:Point = getPointOnSegment(pB, pA, 3/8);
			controlPoint3.x -= dx;
			controlPoint3.y -= dy;
			
			// calculates control point 4
			var controlPoint4:Point = getPointOnSegment(p3, p2, 3/8);
			
			// calculates the 3 anchor points
			var anchor1:Point = getMiddle(controlPoint1, controlPoint2);
			var anchor2:Point = getMiddle(pA, pB);
			var anchor3:Point = getMiddle(controlPoint3, controlPoint4);
		
			// draw the four quadratic myTargetubsegments
			myTarget.penSprite.graphics.curveTo(controlPoint1.x, controlPoint1.y, anchor1.x, anchor1.y);
			myTarget.penSprite.graphics.curveTo(controlPoint2.x, controlPoint2.y, anchor2.x, anchor2.y);
			myTarget.penSprite.graphics.curveTo(controlPoint3.x, controlPoint3.y, anchor3.x, anchor3.y);
			myTarget.penSprite.graphics.curveTo(controlPoint4.x, controlPoint4.y, p3.x, p3.y);
		 }
		 
		 private function getPointOnSegment(pA:Point, pB:Point, ratio:Number):Point {
		 	return new Point(pA.x + ((pB.x - pA.x) * ratio), pA.y + ((pB.y - pA.y) * ratio));
		 }
		 
		 private function getMiddle(pA:Point, pB:Point):Point {
		 	return new Point((pA.x+pB.x)/2, (pA.y+pB.y)/2);
		 }
		 
		 public function arcAbs(rx:Number, ry:Number,
		 	xAxisRotation:Number, largeArcFlag:Boolean, sweepFlag:Boolean, 
		 	x:Number, y:Number):void {
			// ==============
				// mc.drawArc() - by Ric Ewing (ric@formequalsfunction.com) - version 1.5 - 4.7.2002
				// 
				// rx, ry = x and y radius of ellipse
				// xAxisRotation = 
				// x, y = endpoint
				// ==============
				// Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
				// ==============
				
				var arc:Number = getSubtendedAngle(rx, ry, rx*rx+ry*ry);
				var angleMid:Number;
				var a:Point = new Point();
				var b:Point = new Point();
				var c:Point = new Point();
				
				// Flash uses 8 segments per circle, to match that, we draw in a maximum
				// of 45 degree segments. First we calculate how many segments are needed
				// for our arc.
				var numSegs:Number = Math.ceil(Math.abs(arc)/45);
				// Now calculate the sweep of each segment as arc/numSegs in radians
				var theta:Number = -((arc/numSegs)/180)*Math.PI;
				// convert angle xAxisRotation to radians (?radians? - FIXME)
				var angle:Number = -(xAxisRotation/180)*Math.PI;
				// find our starting point a relative to the secified x,y (?HUH)
				a.x = myTarget.penX-Math.cos(angle)*rx;
				a.y = myTarget.penY-Math.sin(angle)*ry;
				// if our arc is larger than 45 degrees, draw as 45 degree segments
				// so that we match Flash's native circle routines.
				if (numSegs>0) {
					// Loop for drawing arc segments
					for (var i:int = 0; i<numSegs; i++) {
						// increment our angle
						angle += theta;
						// find the angle halfway between the last angle and the new
						angleMid = angle-(theta/2);
						// calculate our end point
						b.x = a.x+Math.cos(angle)*rx;
						b.y = a.y+Math.sin(angle)*ry;
						// calculate our control point
						c.x = a.x+Math.cos(angleMid)*(rx/Math.cos(theta/2));
						c.y = a.y+Math.sin(angleMid)*(ry/Math.cos(theta/2));
						// draw the arc segment
						myTarget.penSprite.graphics.curveTo(c.x, c.y, b.x, b.y);
					}
				}
		}
		
		/** 
		 * law of cosines
		 * @return radians
		 */
		private function getSubtendedAngle(a:Number, b:Number, c:Number):Number {
			return (a*a + b*b - c*c)/(2*a*b);
		}
	}
}