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
package org.apache.batik.util.io {

/**
 * This class represents a NormalizingReader which handles Strings.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: StringNormalizingReader.java 475477 2006-11-15 22:44:28Z cam $
 */
public class StringNormalizingReader extends NormalizingReader {

    /**
     * The characters.
     */
    protected var string:String;

    /**
     * The length of the string.
     */
    protected var length:int;
    
    /**
     * The index of the next character.
     */
    protected var next:int;

    /**
     * The current line in the stream.
     */
    protected var line:int = 1;

    /**
     * The current column in the stream.
     */
    protected var column:int;

    /**
     * Creates a new StringNormalizingReader.
     * @param s The string to read.
     */
    public function StringNormalizingReader(s:String) {
        string = s;
        length = s.length;
    }

    /**
     * Read a single character.  This method will block until a
     * character is available, an I/O error occurs, or the end of the
     * stream is reached.
     */
    public override function read():int {
        var result:int = (length == next) ? -1 : string.charCodeAt(next++);
        if (result <= 13) {
            switch (result) {
            case 13:
                column = 0;
                line++;
                var c:int = (length == next) ? -1 : string.charCodeAt(next);
                if (c == 10) {
                    next++;
                }
                return 10;
                
            case 10:
                column = 0;
                line++;
            }
        }
        return result;
    }

    /**
     * Returns the current line in the stream.
     */
    public function getLine():int {
        return line;
    }

    /**
     * Returns the current column in the stream.
     */
    public function getColumn():int {
        return column;
    }

    /**
     * Close the stream.
     */
    public function close():void {
        string = null;
    }
}
}
