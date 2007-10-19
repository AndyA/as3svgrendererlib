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
 * This class represents a parser with support for numbers.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: NumberParser.java 502167 2007-02-01 09:26:51Z dvholten $
 */
public class NumberParser extends AbstractParser {

    /**
     * Parses the content of the buffer and converts it to a float.
     */
    protected function parseFloat():Number {
        var mant:int = 0;
        var mantDig:int = 0;
        var mantPos:Boolean  = true;
        var mantRead:Boolean = false;

        var exp:int = 0;
        var expDig:int = 0;
        var expAdj:int = 0;
        var expPos:Boolean = true;

        switch (current) {
        case String('-').charCodeAt():
            mantPos = false;
            // fallthrough
        case String('+').charCodeAt():
            current = reader.read();
        }

        m1: switch (current) {
        default:
            reportUnexpectedCharacterError( current );
            return 0.0;

        case String('.').charCodeAt():
            break;

        case String('0').charCodeAt():
            mantRead = true;
            l1: for (;;) {
                current = reader.read();
                switch (current) {
                case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                    break l1;
                case String('.').charCodeAt(): case String('e').charCodeAt(): case String('E').charCodeAt():
                    break m1;
                default:
                    return 0.0;
                case String('0').charCodeAt():
                }
            }

        case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
        case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
            mantRead = true;
            l2: for (;;) {
                if (mantDig < 9) {
                    mantDig++;
                    mant = mant * 10 + (int(current)-48)
                } else {
                    expAdj++;
                }
                current = reader.read();
                switch (current) {
                default:
                    break l2;
                case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                }
            }
        }

        if (current == String('.').charCodeAt()) {
            current = reader.read();
            m2: switch (current) {
            default:
            case String('e').charCodeAt(): case String('E').charCodeAt():
                if (!mantRead) {
                    reportUnexpectedCharacterError( current );
                    return 0.0;
                }
                break;

            case String('0').charCodeAt():
                if (mantDig == 0) {
                    l3: for (;;) {
                        current = reader.read();
                        expAdj--;
                        switch (current) {
                        case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                        case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                            break l3;
                        default:
                            if (!mantRead) {
                                return 0.0;
                            }
                            break m2;
                        case String('0').charCodeAt():
                        }
                    }
                }
            case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                l4: for (;;) {
                    if (mantDig < 9) {
                        mantDig++;
                        mant = mant * 10 + (int(current)-48);
                        expAdj--;
                    }
                    current = reader.read();
                    switch (current) {
                    default:
                        break l4;
                    case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                    case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                    }
                }
            }
        }

        switch (current) {
        case String('e').charCodeAt(): case String('E').charCodeAt():
            current = reader.read();
            switch (current) {
            default:
                reportUnexpectedCharacterError( current );
                return 0;
            case String('-').charCodeAt():
                expPos = false;
            case String('+').charCodeAt():
                current = reader.read();
                switch (current) {
                default:
                    reportUnexpectedCharacterError( current );
                    return 0;
                case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                }
            case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
            }

            en: switch (current) {
            case String('0').charCodeAt():
                l5: for (;;) {
                    current = reader.read();
                    switch (current) {
                    case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                    case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                        break l5;
                    default:
                        break en;
                    case String('0').charCodeAt():
                    }
                }

            case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
            case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                l6: for (;;) {
                    if (expDig < 3) {
                        expDig++;
                        exp = exp * 10 + (int(current)-48);
                    }
                    current = reader.read();
                    switch (current) {
                    default:
                        break l6;
                    case String('0').charCodeAt(): case String('1').charCodeAt(): case String('2').charCodeAt(): case String('3').charCodeAt(): case String('4').charCodeAt():
                    case String('5').charCodeAt(): case String('6').charCodeAt(): case String('7').charCodeAt(): case String('8').charCodeAt(): case String('9').charCodeAt():
                    }
                }
            }
        default:
        }

        if (!expPos) {
            exp = -exp;
        }
        exp += expAdj;
        if (!mantPos) {
            mant = -mant;
        }

        return buildFloat(mant, exp);
    }

    /**
     * Computes a float from mantissa and exponent.
     */
    public static function buildFloat(mant:int, exp:int):Number {
    	if(!isCached) cache();
        if (exp < -125 || mant == 0) {
            return 0.0;
        }

        if (exp >=  128) {
            return (mant > 0)
                ? Number.POSITIVE_INFINITY
                : Number.NEGATIVE_INFINITY;
        }

        if (exp == 0) {
            return mant;
        }

        if (mant >= (1 << 26)) {
            mant++;  // round up trailing bits if they will be dropped.
        }

        return new Number((exp > 0) ? mant * pow10[exp] : mant / pow10[-exp]);
    }

    /**
     * Array of powers of ten. Using double instead of float gives a tiny bit more precision.
     */
    private static var pow10:Object = {};
    private static var isCached:Boolean = false;

    private static function cache():void {
    	isCached = true;
        for (var i:int = 0; i < 128; i++) {
            pow10[i] = Math.pow(10, i);
        }
    }
}
}