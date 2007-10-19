// ActionScript file
/*
 * Copyright (c) 2001 World Wide Web Consortium,
 * (Massachusetts Institute of Technology, Institut National de
 * Recherche en Informatique et en Automatique, Keio University). All
 * Rights Reserved. This program is distributed under the W3C's Software
 * Intellectual Property License. This program is distributed in the
 * hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 * PURPOSE.
 * See W3C License http://www.w3.org/Consortium/Legal/ for more details.
 */

package org.w3c.dom.svg {

public class SVGPathSeg {
  // Path Segment Types
  public static var PATHSEG_UNKNOWN:int                      = 0;
  public static var PATHSEG_CLOSEPATH:int                    = 1;
  public static var PATHSEG_MOVETO_ABS:int                   = 2;
  public static var PATHSEG_MOVETO_REL:int                   = 3;
  public static var PATHSEG_LINETO_ABS:int                   = 4;
  public static var PATHSEG_LINETO_REL:int                   = 5;
  public static var PATHSEG_CURVETO_CUBIC_ABS:int            = 6;
  public static var PATHSEG_CURVETO_CUBIC_REL:int            = 7;
  public static var PATHSEG_CURVETO_QUADRATIC_ABS:int        = 8;
  public static var PATHSEG_CURVETO_QUADRATIC_REL:int        = 9;
  public static var PATHSEG_ARC_ABS:int                      = 10;
  public static var PATHSEG_ARC_REL:int                      = 11;
  public static var PATHSEG_LINETO_HORIZONTAL_ABS:int        = 12;
  public static var PATHSEG_LINETO_HORIZONTAL_REL:int        = 13;
  public static var PATHSEG_LINETO_VERTICAL_ABS:int          = 14;
  public static var PATHSEG_LINETO_VERTICAL_REL:int          = 15;
  public static var PATHSEG_CURVETO_CUBIC_SMOOTH_ABS:int     = 16;
  public static var PATHSEG_CURVETO_CUBIC_SMOOTH_REL:int     = 17;
  public static var PATHSEG_CURVETO_QUADRATIC_SMOOTH_ABS:int = 18;
  public static var PATHSEG_CURVETO_QUADRATIC_SMOOTH_REL:int = 19;

  public function getPathSegType( ):int {
  	throw new Error("interface");
  }
  public function getPathSegTypeAsLetter( ):String {
  	throw new Error("interface");
  }
}
}