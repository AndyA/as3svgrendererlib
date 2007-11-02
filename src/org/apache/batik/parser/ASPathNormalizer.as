package org.apache.batik.parser
{

import flash.events.*;

import org.apache.batik.dom.svg.SVGPathSegConstants;
import org.w3c.dom.svg.SVGPathSeg;


/**
 * Normalizes paths and emits xml;
 */
  public  class ASPathNormalizer extends EventDispatcher implements PathHandler {
  	
        public var listHandler:XML = <path type="ASPathNormalizer" />;
        protected var lastAbs:XML;

        public function ASPathNormalizer(){
  			
        }
        /**
         * Implements {@link org.apache.batik.parser.PathHandler#startPath()}.
         */
        public function startPath():void {
            lastAbs = <SVGPathSegGenericItem type={SVGPathSeg.PATHSEG_MOVETO_ABS} letter={SVGPathSegConstants.PATHSEG_MOVETO_ABS_LETTER} x1="0" y1="0" x2="0" y2="0" x="0" y="0" />;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#endPath()}.
         */
        public function endPath():void {
        	dispatchEvent(new Event(Event.COMPLETE));
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoRel(Number,Number)}.
         */
        public function movetoRel(x:Number, y:Number):void {
            movetoAbs(new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);
        } 

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoAbs(Number,Number)}.
         */
        public function movetoAbs(x:Number, y:Number):void {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem type={SVGPathSeg.PATHSEG_MOVETO_ABS} letter={SVGPathSegConstants.PATHSEG_MOVETO_ABS_LETTER} x={x} y={y} />);
            lastAbs.@x = x;
            lastAbs.@y = y;
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_MOVETO_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#closePath()}.
         */
        public function closePath():void  {
        	listHandler.appendChild(<SVGPathSegItem type={SVGPathSeg.PATHSEG_CLOSEPATH} letter={SVGPathSegConstants.PATHSEG_CLOSEPATH_LETTER} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoRel(Number,Number)}.
         */
        public function linetoRel(x:Number, y:Number):void  {
            linetoAbs(new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoAbs(Number,Number)}.
         */
        public function linetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem type={SVGPathSeg.PATHSEG_LINETO_ABS} letter={SVGPathSegConstants.PATHSEG_LINETO_ABS_LETTER} x={x} y={y} />);
            lastAbs.@x = x;
            lastAbs.@y = y;
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_LINETO_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalRel(Number)}.
         */
        public function linetoHorizontalRel(x:Number):void  {
            linetoAbs(new Number(lastAbs.@x) + x, new Number(lastAbs.@y));
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalAbs(Number)}.
         */
        public function linetoHorizontalAbs(x:Number):void  {
            linetoAbs(x, new Number(lastAbs.@y));
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalRel(Number)}.
         */
        public function linetoVerticalRel(y:Number):void  {
            linetoAbs(new Number(lastAbs.@x), new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalAbs(Number)}.
         */
        public function linetoVerticalAbs(y:Number):void  {
            linetoAbs(new Number(lastAbs.@x), y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicRel(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicRel(x1:Number, y1:Number,
                x2:Number, y2:Number,
                x:Number, y:Number):void  {
            curvetoCubicAbs(new Number(lastAbs.@x) +x1, new Number(lastAbs.@y) + y1,
                    new Number(lastAbs.@x) +x2, new Number(lastAbs.@y) + y2,
                    new Number(lastAbs.@x) +x, new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicAbs(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicAbs(x1:Number, y1:Number,
                x2:Number, y2:Number,
                x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicItem type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS} letter={SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_ABS_LETTER} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />);
            lastAbs.@x1 = x1;
        	lastAbs.@y1 = y1;
        	lastAbs.@x2 = x2;
        	lastAbs.@y2 = y2;
        	lastAbs.@x = x;
        	lastAbs.@y = y;
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS;
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothRel(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothRel(x2:Number, y2:Number,
                x:Number, y:Number):void  {
            curvetoCubicSmoothAbs(new Number(lastAbs.@x) + x2, new Number(lastAbs.@y) + y2,
                    new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);

        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothAbs(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothAbs(x2:Number, y2:Number,
                x:Number, y:Number):void  {
            if (lastAbs.@PathSegType==SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS) {
                curvetoCubicAbs(new Number(lastAbs.@x) + (new Number(lastAbs.@x) - new Number(lastAbs.@x2)),
                        new Number(lastAbs.@y) + (new Number(lastAbs.@y) - new Number(lastAbs.@y2)),
                        x2, y2, x, y);
            } else {
                curvetoCubicAbs(new Number(lastAbs.@x), new Number(lastAbs.@y), x2, y2, x, y);
            }
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticRel(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticRel(x1:Number, y1:Number,
                x:Number, y:Number):void  {
            curvetoQuadraticAbs(new Number(lastAbs.@x) + x1, new Number(lastAbs.@y) + y1,
                    new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticAbs(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticAbs(x1:Number, y1:Number,
                x:Number, y:Number):void  {
                listHandler.appendChild(<SVGPathSegCurvetoQuadraticItem 
                	type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS} 
                	letter={SVGPathSegConstants.PATHSEG_CURVETO_QUADRATIC_ABS_LETTER} 
                	x1={x1} y1={y1} x={x} y={y} />);
                /* this is for systems that only have cubic bezier splines
                        curvetoCubicAbs(new Number(lastAbs.@x) + 2 * (x1 - new Number(lastAbs.@x)) / 3,
                                                        new Number(lastAbs.@y) + 2 * (y1 - new Number(lastAbs.@y)) / 3,
                                                        x + 2 * (x1 - x) / 3,
                                                        y + 2 * (y1 - y) / 3,
                                                        x, y);
                 */
                        lastAbs.@x1 = x1;
                        lastAbs.@y1 = y1;
                        lastAbs.@PathSegType = SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothRel(Number,Number)}.
         */
        public function curvetoQuadraticSmoothRel(x:Number, y:Number):void
         {
            curvetoQuadraticSmoothAbs(new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothAbs(Number,Number)}.
         */
        public function curvetoQuadraticSmoothAbs(x:Number, y:Number):void
         {
            if (lastAbs.@PathSegType==SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS) {
                curvetoQuadraticAbs(new Number(lastAbs.@x) + (new Number(lastAbs.@x) - new Number(lastAbs.@x1)),
                        new Number(lastAbs.@y) + (new Number(lastAbs.@y) - new Number(lastAbs.@y1)),
                        x, y);
            } else {
                curvetoQuadraticAbs(new Number(lastAbs.@x), new Number(lastAbs.@y), x, y);
            }

        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcRel(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public function arcRel(rx:Number, ry:Number,
                xAxisRotation:Number,
                largeArcFlag:Boolean, sweepFlag:Boolean,
                x:Number, y:Number):void  {
            arcAbs(rx,ry,xAxisRotation, largeArcFlag, sweepFlag, new Number(lastAbs.@x) + x, new Number(lastAbs.@y) + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcAbs(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public function arcAbs(rx:Number, ry:Number,
                xAxisRotation:Number,
                largeArcFlag:Boolean, sweepFlag:Boolean,
                x:Number, y:Number):void  {

                        // Ensure radii are valid
                        if (rx == 0 || ry == 0) {
                                linetoAbs(x, y);
                                return;
                        }

                        // Get the current (x, y) coordinates of the path
                        var x0:Number = new Number(lastAbs.@x);
                        var y0:Number = new Number(lastAbs.@y);
                        if (x0 == x && y0 == y) {
                                // If the endpoints (x, y) and (x0, y0) are identical, then this
                                // is equivalent to omitting the elliptical arc segment entirely.
                                return;
                        }
						
                        listHandler.appendChild(<SVGPathSegArcAbsItem type={SVGPathSeg.PATHSEG_ARC_ABS} 
                        	letter={SVGPathSegConstants.PATHSEG_ARC_ABS_LETTER} 
                        	rx={rx} ry={ry} xAxisRotation={xAxisRotation} largeArcFlag={largeArcFlag} 
                        	sweepFlag={sweepFlag} x={x} y={y} />);
                        lastAbs.@PathSegType = SVGPathSeg.PATHSEG_ARC_ABS;
        }
    }
}