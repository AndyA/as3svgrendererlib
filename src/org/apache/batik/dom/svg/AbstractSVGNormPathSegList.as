/*

   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 */
package org.apache.batik.dom.svg {

import as3java.awt.Shape;
import as3java.awt.geom.AffineTransform;
import as3java.awt.geom.Arc2D;
import as3java.awt.geom.PathIterator;

import org.apache.batik.ext.awt.geom.ExtendedGeneralPath;
import org.apache.batik.parser.DefaultPathHandler;
import org.apache.batik.parser.ParseException;
import org.apache.batik.parser.PathParser;
import org.w3c.dom.svg.SVGPathSeg;

import org.apache.batik.dom.svg.SVGPathSegConstants;

import com.tobydietrich.svg.ASListHandler;

/**
 * This class is the implementation of the normalized
 * <code>SVGPathSegList</code>.
 *
 * @author <a href="mailto:andrest@world-affair.com">Andres Toussaint</a>
 * @version $Id: AbstractSVGNormPathSegList.java 2005-07-28$
 */
 /* actionscript conversion
 * listhandler could be in the start, middle, or end of a list when loaded. Thus we can't start an xml node
  * not sure that this is a practical concern 
  * more importantly, this is getting me into too many classes.
  * don't know where SVGPathSegMovetoLinetoItem is, but I can guess what it does
 */
public class AbstractSVGNormPathSegList extends AbstractSVGPathSegList {

    /**
     * Creates a new SVGNormPathSegList.
     */
    public function AbstractSVGNormPathSegList() {
        super();
    }

    /**
     * Parse the 'd' attribute.
     *
     * @param value 'd' attribute value
     * @param handler : list handler
     */
    protected function doParse(value:String):void {
        var pathParser:PathParser = new PathParser();

        var builder:NormalizedPathSegListBuilder = new NormalizedPathSegListBuilder();

        pathParser.setPathHandler(builder);
        pathParser.parse(value);
    }
}
}

import as3java.awt.Shape;
import as3java.awt.geom.AffineTransform;
import as3java.awt.geom.Arc2D;
import as3java.awt.geom.PathIterator;

import org.apache.batik.ext.awt.geom.ExtendedGeneralPath;
import org.apache.batik.parser.DefaultPathHandler;
import org.apache.batik.parser.ParseException;
import org.apache.batik.parser.PathParser;
import org.w3c.dom.svg.SVGPathSeg;


import org.apache.batik.dom.svg.SVGPathSegConstants;

    class NormalizedPathSegListBuilder extends DefaultPathHandler {

        protected var listHandler:XML = <list />;
        protected var lastAbs:XML;

        public function NormalizedPathSegListBuilder(){
  			
        }
        /**
         * Implements {@link org.apache.batik.parser.PathHandler#startPath()}.
         */
        public override function startPath():void {
            lastAbs = createSVGPathSegGenericItem(SVGPathSeg.PATHSEG_MOVETO_ABS,
                    SVGPathSegConstants.PATHSEG_MOVETO_ABS_LETTER, 0,0,0,0,0,0);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#endPath()}.
         */
        public override function endPath():void {
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoRel(Number,Number)}.
         */
        public override function movetoRel(x:Number, y:Number):void {
            movetoAbs(lastAbs.@x + x, lastAbs.@y + y);
        } 

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoAbs(Number,Number)}.
         */
        public override function movetoAbs(x:Number, y:Number):void {
            listHandler.appendChild(createSVGPathSegMovetoLinetoItem(SVGPathSeg.PATHSEG_MOVETO_ABS,SVGPathSegConstants.PATHSEG_MOVETO_ABS_LETTER,
                            x,y));
            lastAbs.@x = x;
            lastAbs.@y = y;
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_MOVETO_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#closePath()}.
         */
        public override function closePath():void  {
        	listHandler.appendChild(createSVGPathSegItem(SVGPathSeg.PATHSEG_CLOSEPATH,SVGPathSegConstants.PATHSEG_CLOSEPATH_LETTER));
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoRel(Number,Number)}.
         */
        public override function linetoRel(x:Number, y:Number):void  {
            linetoAbs(lastAbs.@x + x, lastAbs.@y + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoAbs(Number,Number)}.
         */
        public override function linetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(createSVGPathSegMovetoLinetoItem
                    (SVGPathSeg.PATHSEG_LINETO_ABS,SVGPathSegConstants.PATHSEG_LINETO_ABS_LETTER,
                            x,y));
            lastAbs.@x = x;
            lastAbs.@y = y;
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_LINETO_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalRel(Number)}.
         */
        public override function linetoHorizontalRel(x:Number):void  {
            linetoAbs(lastAbs.@x + x, lastAbs.@y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalAbs(Number)}.
         */
        public override function linetoHorizontalAbs(x:Number):void  {
            linetoAbs(x, lastAbs.@y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalRel(Number)}.
         */
        public override function linetoVerticalRel(y:Number):void  {
            linetoAbs(lastAbs.@x, lastAbs.@y + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalAbs(Number)}.
         */
        public override function linetoVerticalAbs(y:Number):void  {
            linetoAbs(lastAbs.@x, y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicRel(Number,Number,Number,Number,Number,Number)}.
         */
        public override function curvetoCubicRel(x1:Number, y1:Number,
                x2:Number, y2:Number,
                x:Number, y:Number):void  {
            curvetoCubicAbs(lastAbs.@x +x1, lastAbs.@y + y1,
                    lastAbs.@x +x2, lastAbs.@y + y2,
                    lastAbs.@x +x, lastAbs.@y + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicAbs(Number,Number,Number,Number,Number,Number)}.
         */
        public override function curvetoCubicAbs(x1:Number, y1:Number,
                x2:Number, y2:Number,
                x:Number, y:Number):void  {
            listHandler.appendChild(createSVGPathSegCurvetoCubicItem
                    (SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS,SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_ABS_LETTER,
                            x1,y1,x2,y2,x,y));
            setValue(lastAbs, x1,y1,x2,y2,x,y);
            lastAbs.@PathSegType = SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS;
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothRel(Number,Number,Number,Number)}.
         */
        public override function curvetoCubicSmoothRel(x2:Number, y2:Number,
                x:Number, y:Number):void  {
            curvetoCubicSmoothAbs(lastAbs.@x + x2, lastAbs.@y + y2,
                    lastAbs.@x + x, lastAbs.@y + y);

        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothAbs(Number,Number,Number,Number)}.
         */
        public override function curvetoCubicSmoothAbs(x2:Number, y2:Number,
                x:Number, y:Number):void  {
            if (lastAbs.@PathSegType==SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS) {
                curvetoCubicAbs(lastAbs.@x + (lastAbs.@x - lastAbs.@x2),
                        lastAbs.@y + (lastAbs.@y - lastAbs.@y2),
                        x2, y2, x, y);
            } else {
                curvetoCubicAbs(lastAbs.@x, lastAbs.@y, x2, y2, x, y);
            }
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticRel(Number,Number,Number,Number)}.
         */
        public override function curvetoQuadraticRel(x1:Number, y1:Number,
                x:Number, y:Number):void  {
            curvetoQuadraticAbs(lastAbs.@x + x1, lastAbs.@y + y1,
                    lastAbs.@x + x, lastAbs.@y + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticAbs(Number,Number,Number,Number)}.
         */
        public override function curvetoQuadraticAbs(x1:Number, y1:Number,
                x:Number, y:Number):void  {
                        curvetoCubicAbs(lastAbs.@x + 2 * (x1 - lastAbs.@x) / 3,
                                                        lastAbs.@y + 2 * (y1 - lastAbs.@y) / 3,
                                                        x + 2 * (x1 - x) / 3,
                                                        y + 2 * (y1 - y) / 3,
                                                        x, y);
                        lastAbs.@x1 = x1;
                        lastAbs.@y1 = y1;
                        lastAbs.@PathSegType = SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS;
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothRel(Number,Number)}.
         */
        public override function curvetoQuadraticSmoothRel(x:Number, y:Number):void
         {
            curvetoQuadraticSmoothAbs(lastAbs.@x + x, lastAbs.@y + y);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothAbs(Number,Number)}.
         */
        public override function curvetoQuadraticSmoothAbs(x:Number, y:Number):void
         {
            if (lastAbs.@PathSegType==SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS) {
                curvetoQuadraticAbs(lastAbs.@x + (lastAbs.@x - lastAbs.@x1),
                        lastAbs.@y + (lastAbs.@y - lastAbs.@y1),
                        x, y);
            } else {
                curvetoQuadraticAbs(lastAbs.@x, lastAbs.@y, x, y);
            }

        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcRel(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public override function arcRel(rx:Number, ry:Number,
                xAxisRotation:Number,
                largeArcFlag:Boolean, sweepFlag:Boolean,
                x:Number, y:Number):void  {
            arcAbs(rx,ry,xAxisRotation, largeArcFlag, sweepFlag, lastAbs.@x + x, lastAbs.@y + y);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcAbs(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public override function arcAbs(rx:Number, ry:Number,
                xAxisRotation:Number,
                largeArcFlag:Boolean, sweepFlag:Boolean,
                x:Number, y:Number):void  {

                        //         Ensure radii are valid
                        if (rx == 0 || ry == 0) {
                                linetoAbs(x, y);
                                return;
                        }

                        // Get the current (x, y) coordinates of the path
                        var x0:Number = lastAbs.@x;
                        var y0:Number = lastAbs.@y;
                        if (x0 == x && y0 == y) {
                                // If the endpoints (x, y) and (x0, y0) are identical, then this
                                // is equivalent to omitting the elliptical arc segment entirely.
                                return;
                        }

                        // this draws an arc. for some reason. 
                        lastAbs.@PathSegType = SVGPathSeg.PATHSEG_ARC_ABS;
        }
        private function createSVGPathSegGenericItem(type:int, letter:String, x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):XML {
        	return <SVGPathSegGenericItem type={type} letter={letter} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />;
        }
        private function createSVGPathSegMovetoLinetoItem(type:int, letter:String, x:Number, y:Number):XML {
        	return <SVGPathSegMovetoLinetoItem type={type} letter={letter} x={x} y={y} />;
        }
        private function createSVGPathSegItem(type:int, letter:String):XML {
        	return <SVGPathSegItem type={type} letter={letter} />;
        }
        private function setValue(lastAbs:XML, x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):void {
        	lastAbs.@x1 = x1;
        	lastAbs.@y1 = y1;
        	lastAbs.@x2 = x2;
        	lastAbs.@y2 = y2;
        	lastAbs.@x = x;
        	lastAbs.@y = y;
        }
        private function createSVGPathSegCurvetoCubicItem(type:int, letter:String, x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number):XML {
        	return <SVGPathSegCurvetoCubicItem type={type} letter={letter} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />;
        }

		private function arc():void {
			/*
			var arc:Arc2D = ExtendedGeneralPath.computeArc(x0, y0, rx, ry, xAxisRotation,
                                        largeArcFlag, sweepFlag, x, y);
                        if (arc == null) return;

                        var t:AffineTransform = AffineTransform.getRotateInstance
                        (Math.toRadians(xAxisRotation), arc.getCenterX(), arc.getCenterY());
                        var s:Shape = t.createTransformedShape(arc);

                        var pi:PathIterator = s.getPathIterator(new AffineTransform());
                        var d:Array = new Array(0, 0, 0, 0, 0, 0);
                        var i:int = -1;

                        while (!pi.isDone()) {
                                i = pi.currentSegment(d);

                                switch (i) {
                                case PathIterator.SEG_CUBICTO:
                                        curvetoCubicAbs(d[0],d[1],d[2],d[3],d[4],d[5]);
                                        break;
                                }
                                pi.next();
                        }
			
			*/
		}
    }