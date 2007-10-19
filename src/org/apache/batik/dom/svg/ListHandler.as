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

/**
 * Interface that defines the functionnality
 * of a list handler for the parser of 
 * attributes that are list.
 *
 * The attribute parser should use this interface 
 * in order to create the list representing
 * the values of the attribute.
 *
 * @author <a href="mailto:nicolas.socheleau@bitflash.com">Nicolas Socheleau</a>
 * @version $Id: ListHandler.java 475477 2006-11-15 22:44:28Z cam $
 */
public interface ListHandler {

    /**
     * Indicates that the parser starts
     * generating the list
     */
    function startList():void;

    /**
     * Indicates a new item to add to the list.
     *
     * @param item the new item to be added
     */
    function item(item:SVGItem):void;

    /**
     * Indicates that the parser ends 
     * generating the list
     */
    function endList():void;

}
}