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

import as3java.io.Reader;
import as3java.util.Locale;
import as3java.util.MissingResourceException;

import org.apache.batik.util.io.NormalizingReader;
import org.apache.batik.util.io.StringNormalizingReader;
import flash.errors.IOError;
import com.tobydietrich.svg.SVGParseError;

/**
 * This class is the superclass of all parsers. It provides localization
 * and error handling methods.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: AbstractParser.java 502167 2007-02-01 09:26:51Z dvholten $
 */
 /** 
 * as3 edits:
 * removed localization stuff - Charles
 */
public class AbstractParser implements Parser {

    /**
     * The normalizing reader.
     */
    protected var reader:NormalizingReader;

    /**
     * The current character.
     */
    protected var current:int;

    /**
     * Returns the current character value.
     */
    public function getCurrent():int {
        return current;
    }

    /**
     * Parses the given string.
     */
    public function parse(s:String):void {
        try {
            reader = new StringNormalizingReader(s);
            doParse();
        } catch (e:IOError) {
        	throw new SVGParseError("io.exception");
        }
    }

    /**
     * Method responsible for actually parsing data after AbstractParser
     * has initialized itself.
     */
    protected function doParse():void {
    	throw new Error("abstract");
    }
    
    /**
     * Signals an error to the error handler.
     * @param key The message key in the resource bundle.
     * @param args The message arguments.
     */
    protected function reportError(key:String):void {
        throw new Error("parse error " + key);
    }

    /**
     * simple api to call often reported error.
     * Just a wrapper for reportError().
     *
     * @param expectedChar what caller expected
     * @param currentChar what caller found
     */
    protected function reportCharacterExpectedError( expectedChar:String,  currentChar:int ):void {
        reportError("character.expected " + expectedChar + " at " + currentChar);
    }

    /**
     * simple api to call often reported error.
     * Just a wrapper for reportError().
     *
     * @param currentChar what the caller found and didnt expect
     */
    protected function reportUnexpectedCharacterError(  currentChar:int ):void {
        reportError("character.unexpected " + String.fromCharCode(currentChar));
    }

    /**
     * Skips the whitespaces in the current reader.
     */
    protected function skipSpaces():void {
        for (;;) {
            switch (current) {
            default:
                return;
            case 0x20:
            case 0x09:
            case 0x0D:
            case 0x0A:
            }
            current = reader.read();
        }
    }

    /**
     * Skips the whitespaces and an optional comma.
     */
    protected function skipCommaSpaces():void {
        wsp1: for (;;) {
            switch (current) {
            default:
                break wsp1;
            case 0x20:
            case 0x9:
            case 0xD:
            case 0xA:
            }
            current = reader.read();
        }
        if (current == String(',').charCodeAt()) {
            wsp2: for (;;) {
                switch (current = reader.read()) {
                default:
                    break wsp2;
                case 0x20:
                case 0x9:
                case 0xD:
                case 0xA:
                }
            }
        }
    }
}
}