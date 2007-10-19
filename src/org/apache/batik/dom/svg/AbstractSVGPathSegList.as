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

import org.apache.batik.parser.PathParser;
import org.w3c.dom.svg.SVGPathSeg;

/**
 * This class is the implementation of
 * <code>SVGPathSegList</code>.
 *
 * @author nicolas.socheleau@bitflash.com
 * @version $Id: AbstractSVGPathSegList.java 476924 2006-11-19 21:13:26Z dvholten $
 */
public class AbstractSVGPathSegList
    extends AbstractSVGList
    implements SVGPathSegList,
               SVGPathSegConstants {

    /**
     * Separator for a point list.
     */
    public static var SVG_PATHSEG_LIST_SEPARATOR:String
        =" ";

    /**
     * Creates a new SVGPathSegList.
     */
    protected function AbstractSVGPathSegList() {
        super();
    }

    /**
     * Return the separator between segments in the list.
     */
    protected function getItemSeparator():String {
        return SVG_PATHSEG_LIST_SEPARATOR;
    }

    /**
     * Create an SVGException when the checkItemType fails.
     *
     * @return SVGException
     */
    protected function createSVGException(type:int,
                                                       key:String,
                                                       args:Object):SVGException {
                                                       	throw new Error("abstract class");
                                                       }


    /**
     */
    public function initialize (newItem:SVGPathSeg ):SVGPathSeg {

        return initializeImpl(newItem) as SVGPathSeg
    }

    /**
     */
    public function  getItem ( index:int ):SVGPathSeg
        {

        return getItemImpl(index) as SVGPathSeg
    }

    /**
     */
    public function  insertItemBefore ( newItem:SVGPathSeg, index:int ):SVGPathSeg
         {

        return insertItemBeforeImpl(newItem,index) as SVGPathSeg;
    }

    /**
     */
    public function  replaceItem ( newItem:SVGPathSeg, index:int ):SVGPathSeg
         {

        return replaceItemImpl(newItem,index) as SVGPathSeg;
    }

    /**
     */
    public function  removeItem ( index:int ):SVGPathSeg
        {

        return removeItemImpl(index) as SVGPathSeg;
    }

    /**
     */
    public function  appendItem ( newItem:SVGPathSeg ):SVGPathSeg
         {

        return appendItemImpl(newItem) as SVGPathSeg;
    }

    /**
     */
    protected function createSVGItem(newItem:Object):SVGItem {

        var pathSeg:SVGPathSeg = newItem as SVGPathSeg;

        return createPathSegItem(pathSeg);
    }

    /**
     * Parse the 'd' attribute.
     *
     * @param value 'd' attribute value
     * @param handler : list handler
     */
    protected function doParse(value:String, handler:ListHandler):void
        {

        var pathParser:PathParser = new PathParser();

        var builder:PathSegListBuilder = new PathSegListBuilder(handler);

        pathParser.setPathHandler(builder);
        pathParser.parse(value);

    }

    /**
     * Check if the item is an SVGPathSeg.
     */
    protected function checkItemType(newItem:Object):void {
        if ( !( newItem is SVGPathSeg ) ){
            createSVGException(SVGException.SVG_WRONG_TYPE_ERR,
                               "expected SVGPathSeg",
                               null);
        }
    }

    /**
     * create an SVGItem representing this SVGPathSeg.
     */
    protected function createPathSegItem(pathSeg:SVGPathSeg):SVGPathSegItem{

        var pathSegItem:SVGPathSegItem = null;

        var type:int = pathSeg.getPathSegType();

        switch(type){
        case SVGPathSeg.PATHSEG_ARC_ABS:
        case SVGPathSeg.PATHSEG_ARC_REL:
            pathSegItem = new SVGPathSegArcItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_CLOSEPATH:
            pathSegItem = new SVGPathSegItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS:
        case SVGPathSeg.PATHSEG_CURVETO_CUBIC_REL:
            pathSegItem = new SVGPathSegCurvetoCubicItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
        case SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
            pathSegItem = new SVGPathSegCurvetoCubicSmoothItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
        case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
            pathSegItem = new SVGPathSegCurvetoQuadraticItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
        case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
            pathSegItem = new SVGPathSegCurvetoQuadraticSmoothItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_LINETO_ABS:
        case SVGPathSeg.PATHSEG_LINETO_REL:
        case SVGPathSeg.PATHSEG_MOVETO_ABS:
        case SVGPathSeg.PATHSEG_MOVETO_REL:
            pathSegItem = new SVGPathSegMovetoLinetoItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_REL:
        case SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_ABS:
            pathSegItem = new SVGPathSegLinetoHorizontalItem(pathSeg);
            break;
        case SVGPathSeg.PATHSEG_LINETO_VERTICAL_REL:
        case SVGPathSeg.PATHSEG_LINETO_VERTICAL_ABS:
            pathSegItem = new SVGPathSegLinetoVerticalItem(pathSeg);
            break;
        default:
        }
        return pathSegItem;
    }
               }
    
}

/**
     * Internal representation of the item SVGPathSeg.
     */
    protected class SVGPathSegItem extends AbstractSVGItem
        implements SVGPathSeg,
                   SVGPathSegClosePath {

        protected var type:int;

        protected var letter:String;

        protected var x:Number;
        protected var y:Number;
        protected var x1:Number;
        protected var y1:Number;
        protected var x2:Number;
        protected var y2:Number;
        protected var r1:Number;
        protected var r2:Number;
        protected var Number angle;
        protected var largeArcFlag:Boolean;
        protected var sweepFlag:Boolean;

        public function SVGPathSegItem(type:int=0,letter:String=0){
            this.type = type;
            this.letter = letter;
        }

        public function SVGPathSegItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_CLOSEPATH:
                letter = PATHSEG_CLOSEPATH_LETTER;
                break;
            default:
            }
        }
        protected function getStringValue():String{
            return letter;
        }

        public function getPathSegType():int {
            return type;
        }


        public function getPathSegTypeAsLetter():String{
            return letter;
        }

    }

    public class SVGPathSegMovetoLinetoItem extends SVGPathSegItem
        implements SVGPathSegMovetoAbs,
                   SVGPathSegMovetoRel,
                   SVGPathSegLinetoAbs,
                   SVGPathSegLinetoRel {

        public function SVGPathSegMovetoLinetoItem(type:int, letter:String,
                                          x:Number, y:Number){
            super(type,letter);
            this.x = x;
            this.y = y;
        }

        public function SVGPathSegMovetoLinetoItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_LINETO_REL:
                letter = PATHSEG_LINETO_REL_LETTER;
                x = ((SVGPathSegLinetoRel)pathSeg).getX();
                y = ((SVGPathSegLinetoRel)pathSeg).getY();
                break;
            case SVGPathSeg.PATHSEG_LINETO_ABS:
                letter = PATHSEG_LINETO_ABS_LETTER;
                x = ((SVGPathSegLinetoAbs)pathSeg).getX();
                y = ((SVGPathSegLinetoAbs)pathSeg).getY();
                break;
            case SVGPathSeg.PATHSEG_MOVETO_REL:
                letter = PATHSEG_MOVETO_REL_LETTER;
                x = ((SVGPathSegMovetoRel)pathSeg).getX();
                y = ((SVGPathSegMovetoRel)pathSeg).getY();
                break;
            case SVGPathSeg.PATHSEG_MOVETO_ABS:
                letter = PATHSEG_MOVETO_ABS_LETTER;
                x = ((SVGPathSegMovetoAbs)pathSeg).getX();
                y = ((SVGPathSegMovetoAbs)pathSeg).getY();
                break;
            default:
            }
        }

        public function Number getX(){
            return x;
        }
        public function Number getY(){
            return y;
        }

        public function  setX(x:Number):void{
            this.x = x;
            resetAttribute();
        }
        public function  setY(y:Number):void{
            this.y = y;
            resetAttribute();
        }

        protected function getStringValue():String{
            return letter
                    + ' '
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
        }
    }

    public class SVGPathSegCurvetoCubicItem extends SVGPathSegItem
        implements SVGPathSegCurvetoCubicAbs,
                   SVGPathSegCurvetoCubicRel {

        public function SVGPathSegCurvetoCubicItem(type:int,letter:String,
                                      x1:Number,y1:Number,x2:Number, y2:Number,
                                      x:Number, y:Number){
            super(type,letter);
            this.x = x;
            this.y = y;
            this.x1 = x1;
            this.y1 = y1;
            this.x2 = x2;
            this.y2 = y2;
        }

        public function SVGPathSegCurvetoCubicItem(pathSeg:SVGPathSeg){
            this.type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS:
                letter = PATHSEG_CURVETO_CUBIC_ABS_LETTER;
                x = ((SVGPathSegCurvetoCubicAbs)pathSeg).getX();
                y = ((SVGPathSegCurvetoCubicAbs)pathSeg).getY();
                x1 = ((SVGPathSegCurvetoCubicAbs)pathSeg).getX1();
                y1 = ((SVGPathSegCurvetoCubicAbs)pathSeg).getY1();
                x2 = ((SVGPathSegCurvetoCubicAbs)pathSeg).getX2();
                y2 = ((SVGPathSegCurvetoCubicAbs)pathSeg).getY2();
                break;
            case SVGPathSeg.PATHSEG_CURVETO_CUBIC_REL:
                letter = PATHSEG_CURVETO_CUBIC_REL_LETTER;
                x = ((SVGPathSegCurvetoCubicRel)pathSeg).getX();
                y = ((SVGPathSegCurvetoCubicRel)pathSeg).getY();
                x1 = ((SVGPathSegCurvetoCubicRel)pathSeg).getX1();
                y1 = ((SVGPathSegCurvetoCubicRel)pathSeg).getY1();
                x2 = ((SVGPathSegCurvetoCubicRel)pathSeg).getX2();
                y2 = ((SVGPathSegCurvetoCubicRel)pathSeg).getY2();
                break;
            default:
            }
        }

        public function Number getX(){
            return x;
        }
        public function Number getY(){
            return y;
        }

        public function  setX(x:Number):void{
            this.x = x;
            resetAttribute();
        }
        public function  setY(y:Number):void{
            this.y = y;
            resetAttribute();
        }

        public function Number getX1(){
            return x1;
        }
        public function Number getY1(){
            return y1;
        }

        public function void setX1(x1:Number){
            this.x1 = x1;
            resetAttribute();
        }
        public function void setY1(y1:Number){
            this.y1 = y1;
            resetAttribute();
        }

        public function Number getX2(){
            return x2;
        }
        public function Number getY2(){
            return y2;
        }

        public function void setX2(x2:Number){
            this.x2 = x2;
            resetAttribute();
        }
        public function void setY2(y2:Number){
            this.y2 = y2;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(x1)
                    + ' '
                    + Number.toString(y1)
                    + ' '
                    + Number.toString(x2)
                    + ' '
                    + Number.toString(y2)
                    + ' '
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
        }
    }

    public class SVGPathSegCurvetoQuadraticItem extends SVGPathSegItem
        implements SVGPathSegCurvetoQuadraticAbs,
                   SVGPathSegCurvetoQuadraticRel {

        public function SVGPathSegCurvetoQuadraticItem(type:int,letter:String,
                                          x1:Number,y1:Number,x:Number, y:Number ){
            super(type,letter);
            this.x = x;
            this.y = y;
            this.x1 = x1;
            this.y1 = y1;
        }

        public function SVGPathSegCurvetoQuadraticItem(pathSeg:SVGPathSeg){
            this.type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS:
                letter = PATHSEG_CURVETO_QUADRATIC_ABS_LETTER;
                x = ((SVGPathSegCurvetoQuadraticAbs)pathSeg).getX();
                y = ((SVGPathSegCurvetoQuadraticAbs)pathSeg).getY();
                x1 = ((SVGPathSegCurvetoQuadraticAbs)pathSeg).getX1();
                y1= ((SVGPathSegCurvetoQuadraticAbs)pathSeg).getY1();
                break;
            case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_REL:
                letter = PATHSEG_CURVETO_QUADRATIC_REL_LETTER;
                x = ((SVGPathSegCurvetoQuadraticRel)pathSeg).getX();
                y = ((SVGPathSegCurvetoQuadraticRel)pathSeg).getY();
                x1 = ((SVGPathSegCurvetoQuadraticRel)pathSeg).getX1();
                y1= ((SVGPathSegCurvetoQuadraticRel)pathSeg).getY1();
                break;
        default:

            }
        }

        public function Number getX(){
            return x;
        }
        public function Number getY(){
            return y;
        }

        public function void setX(x:Number){
            this.x = x;
            resetAttribute();
        }
        public function void setY(y:Number){
            this.y = y;
            resetAttribute();
        }

        public function Number getX1(){
            return x1;
        }
        public function Number getY1(){
            return y1;
        }

        public function void setX1(x1:Number){
            this.x1 = x1;
            resetAttribute();
        }
        public function void setY1(y1:Number){
            this.y1 = y1;
            resetAttribute();
        }

        protected String getStringValue(){

            return letter
                    + ' '
                    + Number.toString(x1)
                    + ' '
                    + Number.toString(y1)
                    + ' '
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
         }
    }

    public function class SVGPathSegArcItem extends SVGPathSegItem
        implements SVGPathSegArcAbs,
                   SVGPathSegArcRel {

        public function SVGPathSegArcItem(type:int,letter:String,
                             r1:Number,r2:Number,Number angle,
                             largeArcFlag:Boolean, sweepFlag:Boolean,
                             x:Number, y:Number ){
            super(type,letter);
            this.x = x;
            this.y = y;
            this.r1 = r1;
            this.r2 = r2;
            this.angle = angle;
            this.largeArcFlag = largeArcFlag;
            this.sweepFlag = sweepFlag;
        }

        public function SVGPathSegArcItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_ARC_ABS:
                letter = PATHSEG_ARC_ABS_LETTER;
                x = ((SVGPathSegArcAbs)pathSeg).getX();
                y = ((SVGPathSegArcAbs)pathSeg).getY();
                r1 = ((SVGPathSegArcAbs)pathSeg).getR1();
                r2 = ((SVGPathSegArcAbs)pathSeg).getR2();
                angle = ((SVGPathSegArcAbs)pathSeg).getAngle();
                largeArcFlag = ((SVGPathSegArcAbs)pathSeg).getLargeArcFlag();
                sweepFlag = ((SVGPathSegArcAbs)pathSeg).getSweepFlag();
                break;
            case SVGPathSeg.PATHSEG_ARC_REL:
                letter = PATHSEG_ARC_REL_LETTER;
                x = ((SVGPathSegArcRel)pathSeg).getX();
                y = ((SVGPathSegArcRel)pathSeg).getY();
                r1 = ((SVGPathSegArcRel)pathSeg).getR1();
                r2 = ((SVGPathSegArcRel)pathSeg).getR2();
                angle = ((SVGPathSegArcRel)pathSeg).getAngle();
                largeArcFlag = ((SVGPathSegArcRel)pathSeg).getLargeArcFlag();
                sweepFlag = ((SVGPathSegArcRel)pathSeg).getSweepFlag();
                break;
            default:
            }
        }

        public function Number getX(){
            return x;
        }
        public function Number getY(){
            return y;
        }

        public function void setX(x:Number){
            this.x = x;
            resetAttribute();
        }
        public function void setY(y:Number){
            this.y = y;
            resetAttribute();
        }

        public function Number getR1(){
            return r1;
        }
        public function Number getR2(){
            return r2;
        }

        public function void setR1(r1:Number){
            this.r1 = r1;
            resetAttribute();
        }
        public function void setR2(r2:Number){
            this.r2 = r2;
            resetAttribute();
        }

        public function Number getAngle(){
            return angle;
        }

        public function void setAngle(Number angle){
            this.angle = angle;
            resetAttribute();
        }

        public function Boolean getSweepFlag(){
            return sweepFlag;
        }

        public function void setSweepFlag(sweepFlag:Boolean){
            this.sweepFlag = sweepFlag;
            resetAttribute();
        }

        public function Boolean getLargeArcFlag(){
            return largeArcFlag;
        }

        public function void setLargeArcFlag(largeArcFlag:Boolean){
            this.largeArcFlag = largeArcFlag;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(r1)
                    + ' '
                    + Number.toString(r2)
                    + ' '
                    + Number.toString(angle)
                    + ' '
                    + ((largeArcFlag?"1":"0"))
                    + ' '
                    + ((sweepFlag?"1":"0"))
                    + (' ')
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
        }
    }

    public class SVGPathSegLinetoHorizontalItem
        extends SVGPathSegItem
        implements SVGPathSegLinetoHorizontalAbs,
                   SVGPathSegLinetoHorizontalRel {

        public function SVGPathSegLinetoHorizontalItem(type:int, letter:String,
                                              Number value){
            super(type,letter);
            this.x = value;
        }
        public function SVGPathSegLinetoHorizontalItem(pathSeg:SVGPathSeg){
            this.type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_ABS:
                letter = PATHSEG_LINETO_HORIZONTAL_ABS_LETTER;
                x = ((SVGPathSegLinetoHorizontalAbs)pathSeg).getX();
                break;
            case SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_REL:
                letter = PATHSEG_LINETO_HORIZONTAL_REL_LETTER;
                x = ((SVGPathSegLinetoHorizontalRel)pathSeg).getX();
                break;
            default:
            }
        }

        public function Number getX(){
            return x;
        }

        public function void setX(x:Number){
            this.x = x;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(x);
        }
    }

    public class SVGPathSegLinetoVerticalItem
        extends SVGPathSegItem
    implements SVGPathSegLinetoVerticalAbs,
               SVGPathSegLinetoVerticalRel {

        public function SVGPathSegLinetoVerticalItem(type:int, letter:String,
                                          Number value){
            super(type,letter);
            this.y = value;
        }

        public function SVGPathSegLinetoVerticalItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_LINETO_VERTICAL_ABS:
                letter = PATHSEG_LINETO_VERTICAL_ABS_LETTER;
                y = ((SVGPathSegLinetoVerticalAbs)pathSeg).getY();
                break;
            case SVGPathSeg.PATHSEG_LINETO_VERTICAL_REL:
                letter = PATHSEG_LINETO_VERTICAL_REL_LETTER;
                y = ((SVGPathSegLinetoVerticalRel)pathSeg).getY();
                break;
            default:
            }
        }

        public function Number getY(){
            return y;
        }

        public function void setY(y:Number){
            this.y = y;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(y);
        }
    }

    public class SVGPathSegCurvetoCubicSmoothItem extends SVGPathSegItem
        implements SVGPathSegCurvetoCubicSmoothAbs,
                   SVGPathSegCurvetoCubicSmoothRel {

        public function SVGPathSegCurvetoCubicSmoothItem(type:int,letter:String,
                                          x2:Number,y2:Number,x:Number, y:Number ){
            super(type,letter);
            this.x = x;
            this.y = y;
            this.x2 = x2;
            this.y2 = y2;
        }

        public function SVGPathSegCurvetoCubicSmoothItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:
                letter = PATHSEG_CURVETO_CUBIC_SMOOTH_ABS_LETTER;
                x = ((SVGPathSegCurvetoCubicSmoothAbs)pathSeg).getX();
                y = ((SVGPathSegCurvetoCubicSmoothAbs)pathSeg).getY();
                x2 = ((SVGPathSegCurvetoCubicSmoothAbs)pathSeg).getX2();
                y2 = ((SVGPathSegCurvetoCubicSmoothAbs)pathSeg).getY2();
                break;
            case SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL:
                letter = PATHSEG_CURVETO_CUBIC_SMOOTH_REL_LETTER;
                x = ((SVGPathSegCurvetoCubicSmoothRel)pathSeg).getX();
                y = ((SVGPathSegCurvetoCubicSmoothRel)pathSeg).getY();
                x2 = ((SVGPathSegCurvetoCubicSmoothRel)pathSeg).getX2();
                y2 = ((SVGPathSegCurvetoCubicSmoothRel)pathSeg).getY2();
                break;
            default:
            }
        }

        public function Number getX(){
            return x;
        }
        public function Number getY(){
            return y;
        }

        public function void setX(x:Number){
            this.x = x;
            resetAttribute();
        }
        public function void setY(y:Number){
            this.y = y;
            resetAttribute();
        }

        public function Number getX2(){
            return x2;
        }
        public function Number getY2(){
            return y2;
        }

        public function void setX2(x2:Number){
            this.x2 = x2;
            resetAttribute();
        }
        public function void setY2(y2:Number){
            this.y2 = y2;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(x2)
                    + ' '
                    + Number.toString(y2)
                    + ' '
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
        }
    }

    public class SVGPathSegCurvetoQuadraticSmoothItem extends SVGPathSegItem
        implements SVGPathSegCurvetoQuadraticSmoothAbs ,
                   SVGPathSegCurvetoQuadraticSmoothRel {

        public SVGPathSegCurvetoQuadraticSmoothItem(type:int, letter:String,
                                                x:Number, y:Number){
            super(type,letter);
            this.x = x;
            this.y = y;
        }

        public SVGPathSegCurvetoQuadraticSmoothItem(pathSeg:SVGPathSeg){
            type = pathSeg.getPathSegType();
            switch(type){
            case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:
                letter = PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS_LETTER;
                x = ((SVGPathSegCurvetoQuadraticSmoothAbs)pathSeg).getX();
                y = ((SVGPathSegCurvetoQuadraticSmoothAbs)pathSeg).getY();
                break;
            case SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:
                letter = PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL_LETTER;
                x = ((SVGPathSegCurvetoQuadraticSmoothRel)pathSeg).getX();
                y = ((SVGPathSegCurvetoQuadraticSmoothRel)pathSeg).getY();
                break;
            default:
            }
        }

        public Number getX(){
            return x;
        }
        public Number getY(){
            return y;
        }

        public void setX(x:Number){
            this.x = x;
            resetAttribute();
        }
        public void setY(y:Number){
            this.y = y;
            resetAttribute();
        }

        protected String getStringValue(){
            return letter
                    + ' '
                    + Number.toString(x)
                    + ' '
                    + Number.toString(y);
        }
    }

    protected class PathSegListBuilder extends DefaultPathHandler {

        protected var listHandler:XML = <list />;

        public function PathSegListBuilder(){
        }
        /**
         * Implements {@link org.apache.batik.parser.PathHandler#startPath()}.
         */
        public function startPath():void  {
            
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#endPath()}.
         */
        public function endPath():void  {
            
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoRel(Number,Number)}.
         */
        public function movetoRel(x:Number, y:Number):void  {
        	listHandler.appendChild(<SVGPathSegMovetoLinetoItem type={SVGPathSeg.PATHSEG_MOVETO_REL} letter={PATHSEG_MOVETO_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#movetoAbs(Number,Number)}.
         */
        public function movetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_MOVETO_ABS} letter={PATHSEG_MOVETO_ABS_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#closePath()}.
         */
        public function closePath():void  {
            listHandler.appendChild(<SVGPathSegItem
                type={SVGPathSeg.PATHSEG_CLOSEPATH} letter={PATHSEG_CLOSEPATH_LETTER} />);

        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoRel(Number,Number)}.
         */
        public function linetoRel(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_LINETO_REL} letter={PATHSEG_LINETO_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoAbs(Number,Number)}.
         */
        public function linetoAbs(x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegMovetoLinetoItem
                type={SVGPathSeg.PATHSEG_LINETO_ABS} letter={PATHSEG_LINETO_ABS_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalRel(Number)}.
         */
        public function linetoHorizontalRel(x:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoHorizontalItem
                type={SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_REL} letter={PATHSEG_LINETO_HORIZONTAL_REL_LETTER} x={x} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoHorizontalAbs(Number)}.
         */
        public function linetoHorizontalAbs(x:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoHorizontalItem
                type={SVGPathSeg.PATHSEG_LINETO_HORIZONTAL_ABS} letter={PATHSEG_LINETO_HORIZONTAL_ABS_LETTER} x={x} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalRel(Number)}.
         */
        public function linetoVerticalRel(y:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoVerticalItem
                type={SVGPathSeg.PATHSEG_LINETO_VERTICAL_REL} letter={PATHSEG_LINETO_VERTICAL_REL_LETTER} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#linetoVerticalAbs(Number)}.
         */
        public function linetoVerticalAbs(y:Number):void  {
            listHandler.appendChild(<SVGPathSegLinetoVerticalItem
                type={SVGPathSeg.PATHSEG_LINETO_VERTICAL_ABS} letter={PATHSEG_LINETO_VERTICAL_ABS_LETTER} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicRel(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicRel(x1:Number, y1:Number,
                                    x2:Number, y2:Number,
                                    x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_REL} letter={PATHSEG_CURVETO_CUBIC_REL_LETTER} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicAbs(Number,Number,Number,Number,Number,Number)}.
         */
        public function curvetoCubicAbs(x1:Number, y1:Number,
                                    x2:Number, y2:Number,
                                    x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_ABS} letter={PATHSEG_CURVETO_CUBIC_ABS_LETTER} x1={x1} y1={y1} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothRel(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothRel(x2:Number, y2:Number,
                                          x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_REL} letter={PATHSEG_CURVETO_CUBIC_SMOOTH_REL_LETTER} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoCubicSmoothAbs(Number,Number,Number,Number)}.
         */
        public function curvetoCubicSmoothAbs(x2:Number, y2:Number,
                                          x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoCubicSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_CUBIC_SMOOTH_ABS} letter={PATHSEG_CURVETO_CUBIC_SMOOTH_ABS_LETTER} x2={x2} y2={y2} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticRel(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticRel(x1:Number, y1:Number,
                                        x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_REL} letter={PATHSEG_CURVETO_QUADRATIC_REL_LETTER} x1={x1} y1={y1} x={x} y={y} />);
        }

        /**
         * Implements {@link
         * org.apache.batik.parser.PathHandler#curvetoQuadraticAbs(Number,Number,Number,Number)}.
         */
        public function curvetoQuadraticAbs(x1:Number, y1:Number,
                                        x:Number, y:Number):void  {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_ABS} letter={PATHSEG_CURVETO_QUADRATIC_ABS_LETTER} x1={x1} y1={y1} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothRel(Number,Number)}.
         */
        public function curvetoQuadraticSmoothRel(x:Number, y:Number):void
             {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL} letter={PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL_LETTER} x={x} y={y} />);
        }

        /**
         * Implements {@link org.apache.batik.parser.PathHandler#curvetoQuadraticSmoothAbs(Number,Number)}.
         */
        public function curvetoQuadraticSmoothAbs(x:Number, y:Number):void
             {
            listHandler.appendChild(<SVGPathSegCurvetoQuadraticSmoothItem
                type={SVGPathSeg.PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS} letter={PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS_LETTER} x={x} y={y} />);
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
                type={SVGPathSeg.PATHSEG_ARC_REL} letter={PATHSEG_ARC_REL_LETTER} rx={rx} ry={ry} xAxisRotation={xAxisRotation} largeArcFlag={largeArcFlag} sweepFlag={sweepFlag} x={x} y={y} />);
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
                type={SVGPathSeg.PATHSEG_ARC_ABS} letter={PATHSEG_ARC_ABS_LETTER} rx={rx} ry={ry} xAxisRotation={xAxisRotation} largeArcFlag={largeArcFlag} sweepFlag={sweepFlag} x={x} y={y} />);
        }
    }
}