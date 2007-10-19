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

import as3java.io.Reader;

/**
 * This class represents a reader which normalizes the line break: \n,
 * \r, \r\n are replaced by \n.  The methods of this reader are not
 * synchronized.  The input is buffered.
 *
 * @author <a href="mailto:stephane@hillion.org">Stephane Hillion</a>
 * @version $Id: NormalizingReader.java 478169 2006-11-22 14:23:24Z dvholten $
 */
public class NormalizingReader extends Reader {

    /**
     * Read characters into a portion of an array.
     * @param cbuf  Destination buffer
     * @param off   Offset at which to start writing characters
     * @param len   Maximum number of characters to read
     * @return The number of characters read, or -1 if the end of the
     * stream has been reached
     */
     public function read():int {
     	throw new Error("prototype");
     }
}
}