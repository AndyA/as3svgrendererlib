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
 * This class implements an event-based parser for the SVG path's d
 * attribute values.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: PathParser.java 502167 2007-02-01 09:26:51Z dvholten $
 */
public class PathParser extends NumberParser {

    /**
     * The path handler used to report parse events.
     */
    protected var pathHandler:PathHandler;

    /**
     * Creates a new PathParser.
     */
    public function PathParser() {
        pathHandler = DefaultPathHandler.PathHandler;
    }

    /**
     * Allows an application to register a path handler.
     *
     * <p>If the application does not register a handler, all
     * events reported by the parser will be silently ignored.
     *
     * <p>Applications may register a new or different handler in the
     * middle of a parse, and the parser must begin using the new
     * handler immediately.</p>
     * @param handler The transform list handler.
     */
    public function setPathHandler(handler:PathHandler):void {
        pathHandler = handler;
    }

    /**
     * Returns the path handler in use.
     */
    public function getPathHandler():PathHandler {
        return pathHandler;
    }

    protected override function doParse():void {
        pathHandler.startPath();

        current = reader.read();
        loop: for (;;) {
            try {
                switch (current) {
                case 0xD:
                case 0xA:
                case 0x20:
                case 0x9:
                    current = reader.read();
                    break;
                case String('z').charCodeAt():
                case String('Z').charCodeAt():
                    current = reader.read();
                    pathHandler.closePath();
                    break;
                case String('m').charCodeAt(): parsem(); break;
                case String('M').charCodeAt(): parseM(); break;
                case String('l').charCodeAt(): parsel(); break;
                case String('L').charCodeAt(): parseL(); break;
                case String('h').charCodeAt(): parseh(); break;
                case String('H').charCodeAt(): parseH(); break;
                case String('v').charCodeAt(): parsev(); break;
                case String('V').charCodeAt(): parseV(); break;
                case String('c').charCodeAt(): parsec(); break;
                case String('C').charCodeAt(): parseC(); break;
                case String('q').charCodeAt(): parseq(); break;
                case String('Q').charCodeAt(): parseQ(); break;
                case String('s').charCodeAt(): parses(); break;
                case String('S').charCodeAt(): parseS(); break;
                case String('t').charCodeAt(): parset(); break;
                case String('T').charCodeAt(): parseT(); break;
                case String('a').charCodeAt(): parsea(); break;
                case String('A').charCodeAt(): parseA(); break;
                case -1:  break loop;
                default:
                    reportUnexpected(current);
                    break;
                }
            } catch (e:ParseException) {
                throw e;
                skipSubPath();
            }
        }

        skipSpaces();
        if (current != -1) {
        	// FIXME
            //reportError("end.of.stream.expected",
            //            new Object[] { new Integer(current) });
        }

        pathHandler.endPath();
    }

    /**
     * Parses a 'm' command.
     */
    protected function parsem():void {
        current = reader.read();
        skipSpaces();

        var x:Number = parseFloat();
        skipCommaSpaces();
        var y:Number = parseFloat();
        pathHandler.movetoRel(x, y);

        var expectNumber:Boolean = skipCommaSpaces2();
        _parsel(expectNumber);
    }

    /**
     * Parses a 'M' command.
     */
    protected function parseM():void {
        current = reader.read();
        skipSpaces();

        var x:Number = parseFloat();
        skipCommaSpaces();
        var y:Number = parseFloat();
        pathHandler.movetoAbs(x, y);

        var expectNumber:Boolean = skipCommaSpaces2();
        _parseL(expectNumber);
    }

    /**
     * Parses a 'l' command.
     */
    protected function parsel():void {
            current = reader.read();
        skipSpaces();
        _parsel(true);
    }

    protected function _parsel(expectNumber:Boolean):void
         {
        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;
            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.linetoRel(x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'L' command.
     */
    protected function parseL():void {
            current = reader.read();
        skipSpaces();
        _parseL(true);
    }

    protected function _parseL(expectNumber:Boolean):void
         {
        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;
            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.linetoAbs(x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'h' command.
     */
    protected function parseh():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;
            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();
            pathHandler.linetoHorizontalRel(x);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'H' command.
     */
    protected function parseH():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();
            pathHandler.linetoHorizontalAbs(x);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'v' command.
     */
    protected function parsev():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();

            pathHandler.linetoVerticalRel(x);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'V' command.
     */
    protected function parseV():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }
            var x:Number = parseFloat();

            pathHandler.linetoVerticalAbs(x);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'c' command.
     */
    protected function parsec():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x1:Number = parseFloat();
            skipCommaSpaces();
            var y1:Number = parseFloat();
            skipCommaSpaces();
            var x2:Number = parseFloat();
            skipCommaSpaces();
            var y2:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoCubicRel(x1, y1, x2, y2, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'C' command.
     */
    protected function parseC():void {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x1:Number = parseFloat();
            skipCommaSpaces();
            var y1:Number = parseFloat();
            skipCommaSpaces();
            var x2:Number = parseFloat();
            skipCommaSpaces();
            var y2:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoCubicAbs(x1, y1, x2, y2, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'q' command.
     */
    protected function parseq():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x1:Number = parseFloat();
            skipCommaSpaces();
            var y1:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoQuadraticRel(x1, y1, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'Q' command.
     */
    protected function parseQ():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x1:Number = parseFloat();
            skipCommaSpaces();
            var y1:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoQuadraticAbs(x1, y1, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 's' command.
     */
    protected function parses():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x2:Number = parseFloat();
            skipCommaSpaces();
            var y2:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoCubicSmoothRel(x2, y2, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'S' command.
     */
    protected function parseS():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x2:Number = parseFloat();
            skipCommaSpaces();
            var y2:Number = parseFloat();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoCubicSmoothAbs(x2, y2, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 't' command.
     */
    protected function parset():void {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoQuadraticSmoothRel(x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'T' command.
     */
    protected function parseT():void {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.curvetoQuadraticSmoothAbs(x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'a' command.
     */
    protected function parsea():void {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var rx:Number = parseFloat();
            skipCommaSpaces();
            var ry:Number = parseFloat();
            skipCommaSpaces();
            var ax:Number = parseFloat();
            skipCommaSpaces();

            var laf:Boolean;
            switch (current) {
            default:  reportUnexpected(current); return;
            case String('0').charCodeAt(): laf = false; break;
            case String('1').charCodeAt(): laf = true;  break;
            }

            current = reader.read();
            skipCommaSpaces();

            var sf:Boolean;
            switch (current) {
            default: reportUnexpected(current); return;
            case String('0').charCodeAt(): sf = false; break;
            case String('1').charCodeAt(): sf = true;  break;
            }

            current = reader.read();
            skipCommaSpaces();

            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.arcRel(rx, ry, ax, laf, sf, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Parses a 'A' command.
     */
    protected function parseA():void  {
        current = reader.read();
        skipSpaces();
        var expectNumber:Boolean = true;

        for (;;) {
            switch (current) {
            default:
                if (expectNumber) reportUnexpected(current);
                return;

            case String('+').charCodeAt(): case String('-').charCodeAt(): case String('.').charCodeAt():
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                break;
            }

            var rx:Number = parseFloat();
            skipCommaSpaces();
            var ry:Number = parseFloat();
            skipCommaSpaces();
            var ax:Number = parseFloat();
            skipCommaSpaces();

            var laf:Boolean;
            switch (current) {
            default: reportUnexpected(current); return;
            case String('0').charCodeAt(): laf = false; break;
            case String('1').charCodeAt(): laf = true;  break;
            }

            current = reader.read();
            skipCommaSpaces();

            var sf:Boolean;
            switch (current) {
            default: reportUnexpected(current); return;
            case String('0').charCodeAt(): sf = false; break;
            case String('1').charCodeAt(): sf = true; break;
            }

            current = reader.read();
            skipCommaSpaces();
            var x:Number = parseFloat();
            skipCommaSpaces();
            var y:Number = parseFloat();

            pathHandler.arcAbs(rx, ry, ax, laf, sf, x, y);
            expectNumber = skipCommaSpaces2();
        }
    }

    /**
     * Skips a sub-path.
     */
    protected function skipSubPath():void  {
        for (;;) {
            switch (current) {
            case -1: case 'm': case 'M': return;
            default:                     break;
            }
            current = reader.read();
        }
    }

    protected function reportUnexpected(ch:int):void
         {
        reportUnexpectedCharacterError( current );
        skipSubPath();
    }

    /**
     * Skips the whitespaces and an optional comma.
     * @return true if comma was skipped.
     */
    protected function skipCommaSpaces2():Boolean {
        wsp1: for (;;) {
            switch (current) {
            default: break wsp1;
            case 0x20: case 0x9: case 0xD: case 0xA: break;
            }
            current = reader.read();
        }

        if (current != String(',').charCodeAt())
            return false; // no comma.

        wsp2: for (;;) {
            switch (current = reader.read()) {
            default: break wsp2;
            case 0x20: case 0x9: case 0xD: case 0xA: break;
            }
        }
        return true;  // had comma
    }
}
}