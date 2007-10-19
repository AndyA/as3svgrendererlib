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
package org.apache.batik.parser {

/**
 * The class provides an adapter for PathHandler.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: DefaultPathHandler.java 478188 2006-11-22 15:19:17Z dvholten $
 */
public class DefaultPathHandler implements PathHandler {

    /**
     * The only instance of this class.
     */
    public static var PathHandler:DefaultPathHandler = new DefaultPathHandler();

    /**
     * This class does not need to be instantiated.
     */
    public function DefaultPathHandler() {
    }

    /**
     * Implements {@link PathHandler#startPath()}.
     */
    public function startPath():void {
    }

    /**
     * Implements {@link PathHandler#endPath()}.
     */
    public function endPath():void {
    }

    /**
     * Implements {@link PathHandler#movetoRel(Number,Number)}.
     */
    public function movetoRel(x:Number, y:Number):void {
    }

    /**
     * Implements {@link PathHandler#movetoAbs(Number,Number)}.
     */
    public function movetoAbs(x:Number, y:Number):void {
    }

    /**
     * Implements {@link PathHandler#closePath()}.
     */
    public function closePath():void {
    }

    /**
     * Implements {@link PathHandler#linetoRel(Number,Number)}.
     */
    public function linetoRel(x:Number, y:Number):void {
    }

    /**
     * Implements {@link PathHandler#linetoAbs(Number,Number)}.
     */
    public function linetoAbs(x:Number, y:Number):void {
    }

    /**
     * Implements {@link PathHandler#linetoHorizontalRel(Number)}.
     */
    public function linetoHorizontalRel(x:Number):void {
    }

    /**
     * Implements {@link PathHandler#linetoHorizontalAbs(Number)}.
     */
    public function linetoHorizontalAbs(x:Number):void {
    }

    /**
     * Implements {@link PathHandler#linetoVerticalRel(Number)}.
     */
    public function linetoVerticalRel(y:Number):void {
    }

    /**
     * Implements {@link PathHandler#linetoVerticalAbs(Number)}.
     */
    public function linetoVerticalAbs(y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoCubicRel(Number,Number,Number,Number,Number,Number)}.
     */
    public function curvetoCubicRel(x1:Number, y1:Number,
                                x2:Number, y2:Number,
                                x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoCubicAbs(Number,Number,Number,Number,Number,Number)}.
     */
    public function curvetoCubicAbs(x1:Number, y1:Number,
                                x2:Number, y2:Number,
                                x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoCubicSmoothRel(Number,Number,Number,Number)}.
     */
    public function curvetoCubicSmoothRel(x2:Number, y2:Number,
                                      x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoCubicSmoothAbs(Number,Number,Number,Number)}.
     */
    public function curvetoCubicSmoothAbs(x2:Number, y2:Number,
                                      x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoQuadraticRel(Number,Number,Number,Number)}.
     */
    public function curvetoQuadraticRel(x1:Number, y1:Number,
                                    x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#curvetoQuadraticAbs(Number,Number,Number,Number)}.
     */
    public function curvetoQuadraticAbs(x1:Number, y1:Number,
                                    x:Number, y:Number):void {
    }

    /**
     * Implements {@link PathHandler#curvetoQuadraticSmoothRel(Number,Number)}.
     */
    public function curvetoQuadraticSmoothRel(x:Number, y:Number)
       :void {
    }

    /**
     * Implements {@link PathHandler#curvetoQuadraticSmoothAbs(Number,Number)}.
     */
    public function curvetoQuadraticSmoothAbs(x:Number, y:Number)
       :void {
    }

    /**
     * Implements {@link
     * PathHandler#arcRel(Number,Number,Number,Boolean,Boolean,Number,Number)}.
     */
    public function arcRel(rx:Number, ry:Number,
                       xAxisRotation:Number,
                       largeArcFlag:Boolean, sweepFlag:Boolean,
                       x:Number, y:Number):void {
    }

    /**
     * Implements {@link
     * PathHandler#arcAbs(Number,Number,Number,Boolean,Boolean,Number,Number)}.
     */
    public function arcAbs(rx:Number, ry:Number,
                       xAxisRotation:Number,
                       largeArcFlag:Boolean, sweepFlag:Boolean,
                       x:Number, y:Number):void {
    }
}
}