package org.apache.batik.parser
{
	import org.apache.batik.dom.svg.SVGPathSegConstants;
	import org.w3c.dom.svg.SVGPathSeg;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	 
	public class ASPathHandler extends EventDispatcher implements PathHandler
	{
		public var listHandler:XML = <path type="ASPathHandler" />;

        public function ASPathHandler(){
        }
        
		/**
         * Implements {@link org.apache.batik.parser.PathHandler#startPath()}.
         */
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#endPath()}.
         */
        public function endPath():void  {
        	dispatchEvent(new Event(Event.COMPLETE));
        	
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoRel(Number,Number)}.
         */
        public function movetoRel(x:Number, y:Number):void  {
        	
        	listHandler.appendChild(<SVGPathSegMovetoLinetoItem type={SVGPathSeg.PATHSEG_MOVETO_REL} letter={SVGPathSegConstants.PATHSEG_MOVETO_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoAbs(Number,Number)}.
         */
        public function movetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_MOVETO_ABS} letter={SVGPathSegConstants.PATHSEG_MOVETO_ABS_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#closePath()}.
         */
        public function closePath():void  {
            listHandler.appendChild(<SVGPathSegItem
                type={SVGPathSeg.PATHSEG_CLOSEPATH} letter={SVGPathSegConstants.PATHSEG_CLOSEPATH_LETTER} />);

        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoRel(Number,Number)}.
         */
        public function linetoRel(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_LINETO_REL} letter={SVGPathSegConstants.PATHSEG_LINETO_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoAbs(Number,Number)}.
         */
        public function linetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_LINETO_ABS} letter={SVGPathSegConstants.PATHSEG_LINETO_ABS_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalRel(Number)}.
         */
        public function linetoHorizontalRel(x:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoHorizontalItem
                type={SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_REL} letter={SVGPathSegConstants.PATHSEG_LINETO_HORIZONTAL_REL_LETTER} x={x} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalAbs(Number)}.
         */
        public function linetoHorizontalAbs(x:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoHorizontalItem
                type={SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_ABS} letter={SVGPathSegConstants.PATHSEG_LINETO_HORIZONTAL_ABS_LETTER} x={x} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalRel(Number)}.
         */
        public function linetoVerticalRel(y:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoVerticalItem
                type={SVGPathSeg.PATHSEG_LINETO_VERTICAL_REL} letter={SVGPathSegConstants.PATHSEG_LINETO_VERTICAL_REL_LETTER} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalAbs(Number)}.
         */
        public function linetoVerticalAbs(y:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoVerticalItem
                type={SVGPathSeg.PATHSEG_LINETO_VERTICAL_ABS} letter={SVGPathSegConstants.PATHSEG_LINETO_VERTICAL_ABS_LETTER} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicRel(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicRel(x1:Number, y1:Number,
                                    x2:Number, y2:Number,
                                    x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_REL} letter={SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_REL_LETTER} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicAbs(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicAbs(x1:Number, y1:Number,
                                    x2:Number, y2:Number,
                                    x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS} letter={SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_ABS_LETTER} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothRel(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothRel(x2:Number, y2:Number,
                                          x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL} letter={SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_SMOOTH_REL_LETTER} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothAbs(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothAbs(x2:Number, y2:Number,
                                          x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS} letter={SVGPathSegConstants.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS_LETTER} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticRel(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticRel(x1:Number, y1:Number,
                                        x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_REL} letter={SVGPathSegConstants.PATHSEG_CURVETO_QUADRATIC_REL_LETTER} x1={x1} y1={y1} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticAbs(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticAbs(x1:Number, y1:Number,
                                        x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS} letter={SVGPathSegConstants.PATHSEG_CURVETO_QUADRATIC_ABS_LETTER} x1={x1} y1={y1} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothRel(Number,Number)}.
         */
        public function curvetoQuadraticSmoothRel(x:Number, y:Number):void
             {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL} letter={SVGPathSegConstants.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothAbs(Number,Number)}.
         */
        public function curvetoQuadraticSmoothAbs(x:Number, y:Number):void
             {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS} letter={SVGPathSegConstants.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcRel(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public function arcRel(rx:Number, ry:Number,
                           xAxisRotation:Number,
                           largeArcFlag:Boolean, sweepFlag:Boolean,
                           x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegArcItem
                type={SVGPathSeg.PATHSEG_ARC_REL} letter={SVGPathSegConstants.PATHSEG_ARC_REL_LETTER} rx={rx} ry={ry} xAxisRotation={xAxisRotation} largeArcFlag={largeArcFlag} sweepFlag={sweepFlag} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#arcAbs(Number,Number,Number,Boolean,Boolean,Number,Number)}.
         */
        public function arcAbs(rx:Number, ry:Number,
                           xAxisRotation:Number,
                           largeArcFlag:Boolean, sweepFlag:Boolean,
                           x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegArcItem
                type={SVGPathSeg.PATHSEG_ARC_ABS} letter={SVGPathSegConstants.PATHSEG_ARC_ABS_LETTER} rx={rx} ry={ry} xAxisRotation={xAxisRotation} largeArcFlag={largeArcFlag} sweepFlag={sweepFlag} x={x} y={y} />);
        }
		
	}
}