#!/usr/bin/python
# $Id: svg2swf,v 1.12 2001/07/30 04:07:32 robla Exp $
#
#    svg2swf - Convert an SVG file into a SWF file
#              SVG == Scalable Vector Graphics
#                     http://www.w3.org/Graphics/SVG
#              SWF == Macromedia Flash format
#
#    Version 0.1.3
#
#    Copyright (C) 2001 Rob Lanphier (robla@robla.net)
#                    http://robla.net/1996
#
#    This library is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser General Public
#    License as published by the Free Software Foundation; either
#    version 2.1 of the License, or (at your option) any later version.
#
#    This library is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser General Public License for more details.
#
#    You should have received a copy of the GNU Lesser General Public
#    License along with this library; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# Derived from simple_appl.py 0.3 1999/01/19 20:42:17 simon (Simon Pepping)
#    http://www.hobby.nl/~scaprea/XML/simple_appl.py
#
# path_arc and path_arc_segment  pulled from librsvg/rsvg-path.c
#    (Raph Levien <raph@acm.org>, http://www.levien.com) 
#
"""This is a converter from SVG into Macromedia Flash (swf) format"""
"""
Synopsis
DocumentHandler handles the traversal of the XML structure, and delegates control to SWF writer.
Contains a big switch statement

SWFWriter: creates an AST based on the XML, complete with environment. 
When a command is reached it is executed using the primitives of Swf2SvgShape

Swf2SvgShape = primitives to draw in an swf


"""
from xml.sax import saxexts, saxlib, saxutils
import sys, urllib, string, ming, os.path, re, math, copy

csscolors = {"black": 0x000000,
             "silver": 0xc0c0c0,
             "gray": 0x808080,
             "white": 0xFFFFFF,
             "maroon": 0x800000,
             "red": 0xFF0000,
             "purple": 0x800080,
             "fuchsia": 0xFF00FF,
             "green": 0x008000,
             "lime": 0x00FF00,
             "olive": 0x808000,
             "yellow": 0xFFFF00,
             "navy": 0x000080,
             "blue": 0x0000FF,
             "teal": 0x008080,
             "aqua": 0x00FFFF}

def printout(name, stuff):
    # Debugging function, print different messages depending on what is being debugged
    #if name == 'style':
    #    print stuff
    #if name == 'SWFShape':
    #    print stuff
    if name == 'a':
        print stuff
    if name == 'text':
        print stuff
    return

def parsepaint(paint):
# handled by builtin
    if (csscolors.has_key(paint)):
        colornum = int(csscolors[paint])
		# DUNNO
    elif (paint[0:3] == "rgb"):
        p = re.compile(r'rgb\s*\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)')
        m = p.match(paint)
        if(m):
            return (int(m.group(1)), int(m.group(2)), int(m.group(3)))
        else:
            raise ValueError, "Invalid color spec: " + paint
    else:
        p = re.compile(r'#([\dA-Fa-f][\dA-Fa-f][\dA-Fa-f][\dA-Fa-f][\dA-Fa-f][\dA-Fa-f])')
        m = p.match(paint)
        if(m):
            colornum = string.atoi(m.group(1),16)
        else:
            return paint
#convert to 3 valued rgb. ick.
    return (colornum / 0x10000, (colornum / 0x100) % 0x100, colornum % 0x100);


class SvgNullObject:
    def __init__(self):
        return

    def handledata(self, data):
        return

class SvgTextObject:
    def __init__(self):
        self.data=""
        return

		#sets the self.swftext property based on stylemap
    def setstyle(self, stylemap):

        # set text color
        if(self.stylemap.has_key('fill')):
            color = parsepaint(self.stylemap['fill'])

            if (color != 'none'):
                self.swftext.setColor(color[0],color[1],color[2])
        else:
            self.swftext.setColor(0,0,0)

        # set font family
        if(stylemap.has_key('font-family')):
            #fixme: figure out legal values
            f = ming.SWFFont("_sans")
        else:
            f = ming.SWFFont("_sans")
            
        self.swftext.setFont(f)

        # set font size
        if(self.stylemap.has_key('font-size')):
            lineheight=int(self.stylemap['font-size'])-1
        else:
            lineheight=10
           
        self.swftext.setHeight(lineheight)
        self.swftext.setLineSpacing(lineheight)
        self.swftext.setBounds(450,lineheight)

        if(self.stylemap.has_key('align')):
            #fixme
            self.swftext.align(ming.SWFTEXTFIELD_ALIGN_LEFT)
        else:
            self.swftext.align(ming.SWFTEXTFIELD_ALIGN_LEFT)
                       
        if(stylemap.has_key('stroke')):
            stroke_color = parsepaint(stylemap['stroke'])
            #FIXME:  This was copied from SWFShape's setfillandstroke
            #if (stroke_color == 'none'):
            #    self.setLine(0, 0, 0, 0, 0)
            #elif(stylemap.has_key('stroke-width')):
            #    self.setLine(float(stylemap['stroke-width']),
            #                 stroke_color[0],
            #                 stroke_color[1],
            #                 stroke_color[2])
            #else:
            #    self.setLine(1,
            #                 stroke_color[0],
            #                 stroke_color[1],
            #                 stroke_color[2])

        return
    
# input functioN?
    def handledata(self, data):
        self.data=self.data+data
        return

		# AST node type
class SvgGObject:
    def __init__(self):
        self.data=""
        return

    def handledata(self, data):
        self.data=self.data+data
        return

		# AST node type
class SvgAObject:
    def __init__(self):
        self.data=""
        return

    def handledata(self, data):
        self.data=self.data+data
        return

		#accepts a self and returns a swfshape
		# self.this is a SWFShape object
		#self.cp {x,y} = the current pen point
		# self.orig{x,y} = origin
		
class Svg2SwfShape(ming.SWFShape):

    def __init__(self):
        self.this = ming.SWFShape()
        self.cpx = 0
        self.cpy = 0
        self.origx = 0
        self.origy = 0
        
    def __del__(self):
        self.__del__

		#instruction to the swfshape. Moves the pen to a specified point
    def movePenTo(self,x,y):
        printout("SWFShape", "movePenTo(%d, %d)" % (x,y))
        self.this.movePenTo(x,y)
        self.cpx = x
        self.cpy = y

		#instruction to the swfshape. Moves the pen by offset
    def movePen(self,x,y):
        printout("SWFShape", "movePen(%d, %d)" % (x,y))
        self.this.movePen(x,y)
        self.cpx = self.cpx + x
        self.cpy = self.cpy + y

		#instruction to the swfshape. Draws from current position to new (global) position
    def drawLineTo(self,x,y):
        printout("SWFShape", "drawLineTo(%d, %d) from (%d,%d)" % (x,y,self.cpx,self.cpy))
        self.this.drawLineTo(x,y)
        self.cpx = x
        self.cpy = y
        
		#instruction to the swfshape. Draws from current position to offset
    def drawLine(self,x,y):
        printout("SWFShape", "drawLine(%d, %d) from (%d,%d)" % (x,y,self.cpx,self.cpy))
        self.this.drawLine(x,y)
        self.cpx = self.cpx + x
        self.cpy = self.cpy + y
        
		#instruction to the swfshape. Draws to new global position
		# not sure of the intricacies of this
    def drawCurveTo(self, bx, by, cx, cy, dx=None, dy=None):
        #self.this.drawLineTo(cx,cy)
        cpx = self.cpx
        cpy = self.cpy
        #XXX: Possible bug in ming: should I need to check whether cpx==bx and cpy==by,
        #     or whether cx==dx and cy==dy?  It won't work without these checks
        if(cpx==bx and cpy==by):
            self.this.drawCurveTo(cx,cy,dx,dy)
            self.cpx = dx
            self.cpy = dy
        elif(cx==dx and cy==dy) or (dx==None and dy==None):
            self.this.drawCurveTo(bx,by,cx,cy)
            self.cpx = cx
            self.cpy = cy
        elif(by==dy and cy==dy and cpy==dy):
            self.this.drawLineTo(dx,dy)
            self.cpx = dx
            self.cpy = dy
        else:
            printout("SWFShape", "drawCurveTo(%d, %d, %d, %d, %d, %d) from (%d,%d)" % (bx,by,cx,cy,dx,dy,cpx,cpy))
            self.this.drawCurveTo(bx,by,cx,cy,dx,dy)
            self.cpx = dx
            self.cpy = dy

#instruction to the swfshape. Draws to new offset position
    def drawCurve(self, bx, by, cx, cy, dx=None, dy=None):
        cpx=self.cpx
        cpy=self.cpy
        if(dx==None and dy==None):
            self.drawCurveTo(cpx+bx,cpy+by,cpx+cx,cpy+cy)
        else:
            printout("SWFShape", "drawCurve(%d, %d, %d, %d, %d, %d) from (%d,%d)" % (bx,by,cx,cy,dx,dy,cpx,cpy))
            self.drawCurveTo(cpx+bx,cpy+by,cpx+cx,cpy+cy,cpx+dx,cpy+dy)

			#instruction to the swfshape. Draws circle around current pen position of radius r
    def drawCircle(self, r):
        #  This needs to be replaced by a fixed version of drawCircle in ming
        x = self.cpx
        y = self.cpy
        x1 = x - math.sqrt(r**2/2.0)
        x2 = x + math.sqrt(r**2/2.0)
        y1 = y - math.sqrt(r**2/2.0)
        y2 = y + math.sqrt(r**2/2.0)
        
        self.movePenTo(x-r,y)
        self.path_arc(r,r,0,0,1,x1,y1)
        self.path_arc(r,r,0,0,1,x,y-r)
        self.path_arc(r,r,0,0,1,x2,y1)
        self.path_arc(r,r,0,0,1,x+r,y)
        self.path_arc(r,r,0,0,1,x2,y2)
        self.path_arc(r,r,0,0,1,x,y+r)
        self.path_arc(r,r,0,0,1,x1,y2)
        self.path_arc(r,r,0,0,1,x-r,y)
        self.this.movePenTo(x,y)
        self.cpx = x
        self.cpy = y

    #  pulled from librsvg/rsvg-path.c (Raph Levien <raph@acm.org>, http://www.levien.com)

	#instruction to the swfshape. 
	# not sure what this does
    def path_arc_segment (self, xc, yc, th0, th1, rx, ry, x_axis_rotation):
        # local variables
        # sin_th, cos_th
        # a00, a01, a10, a11
        # x1, y1, x2, y2, x3, y3
        # t
        # th_half

        sin_th = math.sin (x_axis_rotation * (math.pi / 180.0))
        cos_th = math.cos (x_axis_rotation * (math.pi / 180.0)) 
        # inverse transform compared with rsvg_path_arc
        a00 = cos_th * rx
        a01 = -sin_th * ry
        a10 = sin_th * rx
        a11 = cos_th * ry
        
        th_half = 0.5 * (th1 - th0)
        t = (8.0 / 3.0) * math.sin (th_half * 0.5) * math.sin (th_half * 0.5) / math.sin (th_half)
        x1 = xc + math.cos (th0) - t * math.sin (th0)
        y1 = yc + math.sin (th0) + t * math.cos (th0)
        x3 = xc + math.cos (th1)
        y3 = yc + math.sin (th1)
        x2 = x3 + t * math.sin (th1)
        y2 = y3 - t * math.cos (th1)
        self.drawCurveTo (a00 * x1 + a01 * y1, a10 * x1 + a11 * y1,
                          a00 * x2 + a01 * y2, a10 * x2 + a11 * y2,
                          a00 * x3 + a01 * y3, a10 * x3 + a11 * y3)


    #  pulled from librsvg/rsvg-path.c (Raph Levien <raph@acm.org>)

    # path_arc: Add an elliptical arc to the swfshape
    # @ctx: Path context.
    # @rx: Radius in x direction (before rotation).
    # @ry: Radius in y direction (before rotation).
    # @x_axis_rotation: Rotation angle for axes.
    # @large_arc_flag: 0 for arc length <= 180, 1 for arc >= 180.
    # @sweep: 0 for "negative angle", 1 for "positive angle".
    # @x: New x coordinate.
    # @y: New y coordinate.

#instruction to the swfshape
# not sure what this does
    def path_arc (self, rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y):
        # local variables
        # sin_th, cos_th
        # a00, a01, a10, a11
        # x0, y0, x1, y1, xc, yc
        # d, sfactor, sfactor_sq
        # th0, th1, th_arc
        #  int i, n_segs

        distance=math.sqrt((x-self.cpx)**2 + (y-self.cpy)**2)

        if(rx==0 or ry==0):
            return
        # ensure arc as defined can reach destination
        # FIXME: this method only really works when rx==ry
        if(max(rx,ry)*2<distance):
            rx=distance/2
            ry=rx
        sin_th = math.sin (x_axis_rotation * (math.pi / 180.0))
        cos_th = math.cos (x_axis_rotation * (math.pi / 180.0))
        a00 = cos_th / rx
        a01 = sin_th / rx
        a10 = -sin_th / ry
        a11 = cos_th / ry
        x0 = a00 * self.cpx + a01 * self.cpy
        y0 = a10 * self.cpx + a11 * self.cpy
        x1 = a00 * x + a01 * y
        y1 = a10 * x + a11 * y
        # (x0, y0) is current point in transformed coordinate space.
        # (x1, y1) is new point in transformed coordinate space.
        #
        # The arc fits a unit-radius circle in this space.
        d = (x1 - x0) * (x1 - x0) + (y1 - y0) * (y1 - y0)
        sfactor_sq = 1.0 / d - 0.25
        if (sfactor_sq < 0):
            sfactor_sq = 0
        sfactor = math.sqrt (sfactor_sq)
        if (sweep_flag == large_arc_flag):
            sfactor = -sfactor
        xc = 0.5 * (x0 + x1) - sfactor * (y1 - y0)
        yc = 0.5 * (y0 + y1) + sfactor * (x1 - x0)
        # (xc, yc) is center of the circle.

        th0 = math.atan2 (y0 - yc, x0 - xc)
        th1 = math.atan2 (y1 - yc, x1 - xc)

        th_arc = th1 - th0
        if (th_arc < 0 and sweep_flag):
            th_arc = th_arc + 2 * math.pi
        elif (th_arc > 0 and not sweep_flag):
            th_arc = th_arc - 2 * math.pi

        n_segs = math.ceil (math.fabs (th_arc / (math.pi * 0.5 + 0.001)))

        for i in range(n_segs):
            self.path_arc_segment(xc, yc,
                                  th0 + i * th_arc / n_segs,
                                  th0 + (i + 1) * th_arc / n_segs,
                                  rx, ry, x_axis_rotation)
        self.cpx = x
        self.cpy = y

		#instruction to the swfshape
		# this modifies the current pen
    def setfillandstroke(self, stylemap):
        if(stylemap.has_key('fill')):
            fill_color = parsepaint(stylemap['fill'])

            if (fill_color != 'none'):
                self.setRightFill(self.addFill(fill_color[0],
                                               fill_color[1],
                                               fill_color[2]))
                        
        if(stylemap.has_key('stroke')):
            stroke_color = parsepaint(stylemap['stroke'])
            if (stroke_color == 'none'):
                printout("style", "stroke=none; setLine(0,0,0,0,0)")
                self.setLine(0, 0, 0, 0, 0)
            elif(stylemap.has_key('stroke-width')):
                sw=(float(stylemap['stroke-width']))
                s0=stroke_color[0]
                s1=stroke_color[1]
                s2=stroke_color[2]
                printout("style", "setLine(%f,%f,%f,%f)" % (sw,s0,s1,s2))
                self.setLine(sw,s0,s1,s2)
                
            else:
                sw=1
                s0=stroke_color[0]
                s1=stroke_color[1]
                s2=stroke_color[2]
                printout("style", "setLine(%f,%f,%f,%f)" % (sw,s0,s1,s2))
                self.setLine(sw,s0,s1,s2)

        return
    
	#instruction to the swfshape
	# resets the origin to be the current pen position. e.g. creates a new coordinate system, as with a nested sprite
    def resetorig(self):
        self.origx = self.cpx
        self.origy = self.cpy

		#instruction to the swfshape
		# closes a shape by drawing a line to the origin
    def closepath(self,stylemap,returntosender):
        cpx=self.cpx
        cpy=self.cpy
        printout("path", "Closing path:")
        printout("path", "-- origx: %d origy: %d cpx: %d cpy: %d " % (self.origx, self.origy, cpx, cpy))
        if returntosender:
            printout("path", "-- transparent line")
            self.setLine(0,0,0,0,0)
        self.drawLineTo(self.origx, self.origy)
        self.setfillandstroke(stylemap)
        if returntosender:
            self.movePenTo(cpx,cpy)
        return

		# main routine. accepts a self and the filename for eventual writing
class SwfWriter(ming.SWFMovie):
    def __init__(self, filename):
        ming.Ming_setScale(1.0)
        ming.Ming_setCubicThreshold(100)

        self.this = ming.SWFMovie()
        self.blocks = []
        self.filename = filename
        self.contenthandler = SvgNullObject()
        self.chstack = []
        self.stylestack = []
        self.href = None
        
    def __del__(self):
        self.__del__

		# builds the style environment (stack).  Parses the string style
    def getstyle(self, style=None):
        # parse the CSS style string
        if(len(self.stylestack) == 0):
            stylemap = {}
        else:
            stylemap = self.stylestack[0].copy()

        printout("style", "stylestack     : " + `self.stylestack`);
        if(style==None):
            return stylemap
        
        printout("style", "handling style: " + style);
        cssprops = string.split(style, ';')
        p = re.compile(r'\s*(\S+)\s*:\s*(.*\S)\s*')
        for prop in cssprops:
            m = p.match(prop)
            if(m):
                stylemap[m.group(1)] = m.group(2)

        printout("style", "stylestackafter: " + `self.stylestack`);
        printout("style", "stylemap: " + `stylemap`);
        return stylemap

    # attrs is the attributes of the <svg> tag
    def handle_svg_start(self, attrs):
        if(attrs.has_key('height') and attrs.has_key('width')):
            self.setDimension(float(attrs['height']), float(attrs['width']))
            self.explicitheight=float(attrs['height'])
        elif(attrs.has_key('height')):
            self.explicitheight=float(attrs['height'])
            self.explicitwidth=None
        elif(attrs.has_key('width')):
            self.explicitwidth=float(attrs['width'])
            self.explicitheight=None
        else:
            self.explicitheight=None
            self.explicitwidth=None
            #XXX: need to actually compute bounding box rather than just
            #     setting to arbitrary value here...this value works with tiger.svg
			# charles: this shouldn't present a problem
            self.setDimension(524, 517)

        self.setRate(12.0)

		# tag <a> and its attributes attrs
		# what happens when you click on the button. It's like an  image map.
		# self.chstack contains the current link
		#there isn't much purpose to SvgAObject,
    def handle_a_start(self, attrs):
        self.chstack[:0] = [self.contenthandler]
        self.contenthandler = SvgAObject()
        #FIXME: this won't allow for nesting
        if(attrs.has_key('xlink:href')):
            actionscript='getURL("'+attrs["xlink:href"]+'","_self");'
            printout("a", "actionscript: "+actionscript)
            hrefaction = ming.SWFAction(actionscript)
            self.href = ming.SWFButton()
            self.href.addAction(hrefaction, ming.SWFBUTTON_MOUSEUP)
        return
    
	
    def handle_a_end(self):
        printout("a", "a end")
        self.href = None
        # pop the last content handler off the stack
        self.contenthandler = self.chstack[0]
        self.chstack[0:1]=[]
        return
    
	# handles the <g> tag. 
	# G is an affine transform -- like a Sprite
	# also goes onto the stack.
	# there's no good reason that these are the same stack, really...
    def handle_g_start(self, attrs):
        # push self.contenthandler onto chstack
        self.chstack[:0] = [self.contenthandler]
        self.contenthandler = SvgGObject()
        g=self.contenthandler

        printout("g", "Handling g start")
        printout("g", "-- before: " + `self.stylestack`)
        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()

        self.stylestack[:0] = [stylemap.copy()]
        printout("g", "--  after: " + `self.stylestack`)

		# pop the affine transform off the stack
    def handle_g_end(self):
        g=self.contenthandler
        printout("g", "Handling g end")
        printout("g", "-- before: " + `self.stylestack`)
        self.stylestack[0:1]=[]
        printout("g", "--  after: " + `self.stylestack`)

        # pop the last content handler off the stack
        self.contenthandler = self.chstack[0]
        self.chstack[0:1]=[]

		# not really sure. it's a text field but it's on the stack
    def handle_text_start(self, attrs):
        # set up the data gathering process for handle_text_end to use
        # push self.contenthandler onto chstack
        self.chstack[:0] = [self.contenthandler]
        self.contenthandler = SvgTextObject()
        txt=self.contenthandler
        txt.x = float(attrs['x'])
        txt.y = float(attrs['y'])
        
        if(attrs.has_key('style')):
            txt.stylemap = self.getstyle(attrs['style'])
        else:
            txt.stylemap = self.getstyle()

        txt.swftext = ming.SWFTextField()

        txt.setstyle(txt.stylemap)

		# prints out the text. Not sure why this couldn't be done before.
		# maybe because of z-order.
    def handle_text_end(self):
        printout ("text", self.contenthandler.data)
        txt=self.contenthandler
        
        txt.swftext.addString(self.contenthandler.data)

        i = self.add(txt.swftext)
        i.moveTo(txt.x,txt.y-10)
        if(self.href==None):
            printout("text", "Adding plain text")
            i = self.add(txt.swftext)
            i.moveTo(txt.x,txt.y-10)
        else:
            printout("text", "self.href: "+`self.href`)
            #FIXME: this may need to use a copy operation
            button = self.href
            button.addShape(txt.swftext, ming.SWFBUTTON_UP |
                                         ming.SWFBUTTON_HIT |
                                         ming.SWFBUTTON_OVER |
                                         ming.SWFBUTTON_DOWN)
            i = self.add(button)
            i.moveTo(txt.x,txt.y-10)

        # pop the last content handler off the stack
        self.chstack[0:1]=[]
        if(len(self.chstack)>0):
            self.contenthandler = self.chstack[0]
        else:
            self.contenthandler = []

			# draws a line from <line> tag
			# leaf node
    def handle_line(self, attrs):
        # Handle the <line> tag

        printout("line", "handle_line")

        x1 = float(attrs['x1'])
        y1 = float(attrs['y1'])
        x2 = float(attrs['x2'])
        y2 = float(attrs['y2'])

        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()
    
        # initialize the swf object
        s = Svg2SwfShape()
        
        printout("line", "setfillandstroke(%s)" % (stylemap))
        s.setfillandstroke(stylemap)

        s.movePenTo(x1,y1)
        s.drawLineTo(x2,y2)

        i = self.add(s)

		# draws a circle from <circle> tag
		# leaf node
    def handle_circle(self, attrs):
        # Handle the <circle> tag

        printout("circle", "handle_circle")
        # parse the easy attributes
        cx = float(attrs['cx'])
        cy = float(attrs['cy'])
        r = float(attrs['r'])

        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()
    
        # initialize the swf object
        s = Svg2SwfShape()
        
        printout("circle", "setfillandstroke(%s)" % (stylemap))
        s.setfillandstroke(stylemap)

        s.drawCircle(r)

        printout("circle", "moveTo(%d,%d)" % (cx, cy))
        i = self.add(s)
        i.moveTo(cx,cy)

    # draws a rectangle from <rect> tag
	# leaf node
    def handle_rect(self, attrs):
        # Handle the <rect> tag
        printout("rect", "Starting handle_rect")

        # parse the easy attributes
        x = float(attrs['x'])
        y = float(attrs['y'])
        height = float(attrs['height'])
        width = float(attrs['width'])

        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()

        printout("rect", stylemap)
        
        # initial math for rx and ry

        if(attrs.has_key('rx')):
            rx = float(attrs['rx'])
            if not attrs.has_key('ry'):
                ry = rx

        if(attrs.has_key('ry')):
            ry = float(attrs['ry'])
            if not attrs.has_key('rx'):
                rx = ry

        if not attrs.has_key('rx') and not attrs.has_key('ry'):
            rx = 0
            ry = 0

        x0=0
        x1=rx
        x2=width-rx
        x3=width
        fudgex=0

        y0=0
        y1=ry
        y2=height-ry
        y3=height
        fudgey=0
        
        if(x1>x2):
            fudgex = rx - (x1+x2)/2
            x1=width-rx
            x2=rx
            y0=max(float(ry-math.sqrt(ry**2 - fudgex**2)), 2)
            y3=height-y0
        
        if(y1>y2):
            fudgey = ry - (y1+y2)/2
            y1=height-ry
            y2=ry
            x0=max(float(rx-math.sqrt(rx**2 - fudgey**2)), 2)
            x3=height-x0

        # initialize the swf object
        s = Svg2SwfShape()
        
        s.setfillandstroke(stylemap)

        s.movePenTo(x2,y0)
        # path_arc (self, rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y):
        s.path_arc (rx, ry, 0, 0, 1, x3, y1)
        #s.drawCurveTo(x3,y0,x3,y1)
        s.drawLineTo(x3,y2)
        s.path_arc (rx, ry, 0, 0, 1, x2, y3)
        #s.drawCurveTo(x3, y3, x2, y3)
        if fudgex == 0:
            s.drawLineTo(x1,y3)
        else:
            s.drawCurveTo((x1+x2)/2,height,x1,y3)
        s.path_arc (rx, ry, 0, 0, 1, x0, y2)
        #s.drawCurveTo(0,y3,0,y2)
        s.drawLineTo(x0,y1)
        s.path_arc (rx, ry, 0, 0, 1, x1, y0)
        #s.drawCurveTo(0,0,x1,0)
        if fudgex == 0:
            s.drawLineTo(x2,y0)
        else:
            s.drawCurveTo((x1+x2)/2,0,x2,y0)
        
        i = self.add(s)
        i.moveTo(x,y)
        printout("rect", "Finishing handle_rect")

		# draws a path from <path> tag
		# leaf node
		# I really need to copy the d attribute handling code!!!
    def handle_path(self, attrs):
        # Handle the <path> tag
        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()

        # initialize the swf object
        s = Svg2SwfShape()

        self.origx = s.cpx
        self.origy = s.cpy
        
        s.setfillandstroke(stylemap)

        # Handle the dreaded "d" attribute
        # It'll look something like this
        # M10 405 h275 M205 405 v35 M10 426 h195 M205 422 h80
        # M=absolute moveto
        # m=relative moveto
        # H=absolute hortizontal (cpx, cpy) to (x, cpy)
        # h=relative horizontal 
        # V=absolute vertical (cpx, cpy) to (cpx, y)
        # v=relative vertical

        if(attrs.has_key('d')):
            path = attrs['d']
            printout("path", "Starting to handle path: %s" % (path))
            Mre = re.compile(r'\s*M\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            mre = re.compile(r'\s*m\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Lre = re.compile(r'\s*L\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            lre = re.compile(r'\s*l\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Vre = re.compile(r'\s*V\s*(-?\d+(\.\d+)?)\s*')
            vre = re.compile(r'\s*v\s*(-?\d+(\.\d+)?)\s*')
            Hre = re.compile(r'\s*H\s*(-?\d+(\.\d+)?)\s*')
            hre = re.compile(r'\s*h\s*(-?\d+(\.\d+)?)\s*')
            Tre = re.compile(r'\s*T\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            tre = re.compile(r'\s*t\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Qre = re.compile(r'\s*Q\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            qre = re.compile(r'\s*q\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Cre = re.compile(r'\s*C\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            cre = re.compile(r'\s*c\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Sre = re.compile(r'\s*S\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            sre = re.compile(r'\s*s\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            Are = re.compile(r'\s*A\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            are = re.compile(r'\s*a\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*(-?\d+(\.\d+)?)\s*')
            zre = re.compile(r'\s*[Zz]\s*')
            
            while 1:
                m = Mre.match(path)
                if(m):
                    s.closepath(stylemap,1)
                    s.movePenTo(float(m.group(1)), float(m.group(3)))
                    path = Mre.sub("", path, 1)
                    s.resetorig()
                    continue
                m = mre.match(path)
                if(m):
                    s.closepath(stylemap,1)
                    s.movePen(float(m.group(1)), float(m.group(3)))
                    path = mre.sub("", path, 1)
                    s.resetorig()
                    continue
                m = Lre.match(path)
                if(m):
                    s.drawLineTo(float(m.group(1)), float(m.group(3)))
                    path = Lre.sub("", path, 1)
                    continue
                m = lre.match(path)
                if(m):
                    s.drawLine(float(m.group(1)), float(m.group(3)))
                    path = lre.sub("", path, 1)
                    continue
                m = Vre.match(path)
                if(m):
                    s.drawLineTo(s.cpx,float(m.group(1)))
                    path = Vre.sub("", path, 1)
                    continue
                m = vre.match(path)
                if(m):
                    s.drawLine(0,float(m.group(1)))
                    path = vre.sub("", path, 1)
                    continue
                m = Hre.match(path)
                if(m):
                    s.drawLineTo(float(m.group(1)),s.cpy)
                    path = Hre.sub("", path, 1)
                    continue
                m = hre.match(path)
                if(m):
                    s.drawLine(float(m.group(1)),0)
                    path = hre.sub("", path, 1)
                    continue
                m = Tre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    bx=qcx+(qcx-qbx)
                    by=qcy+(qcy-qby)
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    qbx=bx
                    qby=by
                    qcx=cx
                    qcy=cy
                    s.drawCurveTo(bx,by,cx,cy)
                    path = Tre.sub("", path, 1)
                    continue
                m = tre.match(path)
                if(m):
                    bx=qcx+(qcx-qbx)-s.cpx
                    by=qcy+(qcy-qby)-s.cpy
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    qbx=bx+s.cpx
                    qby=by+s.cpy
                    qcx=cx+s.cpx
                    qcy=cy+s.cpy
                    s.drawCurve(bx,by,cx,cy)
                    path = tre.sub("", path, 1)
                    continue
                m = Qre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    qbx=bx
                    qby=by
                    qcx=cx
                    qcy=cy
                    s.drawCurveTo(bx,by,cx,cy)
                    path = Qre.sub("", path, 1)
                    continue
                m = qre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    qbx=bx+s.cpx
                    qby=by+s.cpy
                    qcx=cx+s.cpx
                    qcy=cy+s.cpy
                    s.drawCurve(bx,by,cx,cy)
                    path = qre.sub("", path, 1)
                    continue
                m = Cre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    dx=float(m.group(9))
                    dy=float(m.group(11))
                    acx=cx
                    acy=cy
                    adx=dx
                    ady=dy
                    s.drawCurveTo(bx,by,cx,cy,dx,dy)
                    path = Cre.sub("", path, 1)
                    continue
                m = cre.match(path)
                if(m):
                    bx=float(m.group(1))
                    by=float(m.group(3))
                    cx=float(m.group(5))
                    cy=float(m.group(7))
                    dx=float(m.group(9))
                    dy=float(m.group(11))
                    acx=cx+s.cpx
                    acy=cy+s.cpy
                    adx=dx+s.cpx
                    ady=dy+s.cpy
                    s.drawCurve(bx,by,cx,cy,dx,dy)
                    path = cre.sub("", path, 1)

                    continue
                m = Sre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    bx=adx+(adx-acx)
                    by=ady+(ady-acy)
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    dx=float(m.group(5))
                    dy=float(m.group(7))
                    acx=cx
                    acy=cy
                    adx=dx
                    ady=dy
                    s.drawCurveTo(bx,by,cx,cy,dx,dy)
                    path = Sre.sub("", path, 1)
                    continue
                m = sre.match(path)
                if(m):
                    printout("path", " -- " + m.group(0))
                    printout("path", " --  cpx: %d cpy: %d acx: %d acy: %d" % (s.cpx, s.cpy, acx, acy))
                    bx=adx+(adx-acx)-s.cpx
                    by=ady+(ady-acy)-s.cpy
                    cx=float(m.group(1))
                    cy=float(m.group(3))
                    dx=float(m.group(5))
                    dy=float(m.group(7))
                    acx=cx+s.cpx
                    acy=cy+s.cpy
                    adx=dx+s.cpx
                    ady=dy+s.cpy
                    s.drawCurve(bx,by,cx,cy,dx,dy)
                    path = sre.sub("", path, 1)
                    continue
                m = Are.match(path)
                if(m):
                    rx=float(m.group(1))
                    ry=float(m.group(3))
                    x_axis_rotation=float(m.group(5))
                    large_arc_flag=float(m.group(7))
                    sweep_flag=float(m.group(9))
                    x=float(m.group(11))
                    y=float(m.group(13))
                    s.path_arc(rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)
                    path = Are.sub("", path, 1)
                    continue
                m = are.match(path)
                if(m):
                    rx=float(m.group(1))
                    ry=float(m.group(3))
                    x_axis_rotation=float(m.group(5))
                    large_arc_flag=float(m.group(7))
                    sweep_flag=float(m.group(9))
                    x=float(m.group(11))+s.cpx
                    y=float(m.group(13))+s.cpy
                    printout("path", "(rx=%d, ry=%d, x_axis_rotation=%d, large_arc_flag=%d, sweep_flag=%d, x=%d, y=%d)" % (rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y))
                    s.path_arc(rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)
                    printout("path", "After path_arc x: %d, y: %d" % (s.cpx, s.cpy))
                    path = are.sub("", path, 1)
                    continue
                m = zre.match(path)
                if(m):
                    s.closepath(stylemap, 0)
                    path = zre.sub("", path, 1)
                    continue
                if(path==""):
                    break
                raise AttributeError, "Unrecogized gunk in path attribute: " + path

        s.closepath(stylemap, 1)

        printout("path", "Adding shape")
        i = self.add(s)
        #tiger hack
        #i.moveTo(200,150)
        return

		# draws polygon and polyline from <polygon> and <polyline> tags
		# just draws a bunch of line segments
		# leaf node
    def handle_polywhatever(self, attrs, tagname):
        # Handle the <polygon> and <polyline> tags

        printout(tagname, "handle_polywhatever")

        if(attrs.has_key('style')):
            stylemap = self.getstyle(attrs['style'])
        else:
            stylemap = self.getstyle()
    
        # initialize the swf object
        s = Svg2SwfShape()
        
        printout(tagname, "setfillandstroke(%s)" % (stylemap))
        s.setfillandstroke(stylemap)

        if(not attrs.has_key('points')):
            raise AttributeError, tagname + " element missing point attribute"
        else:
            points = attrs['points']
            printout(tagname, "Starting to handle points: %s" % (points))
            MoveToRe = re.compile(r'\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)')
            PointsRe = re.compile(r'[,\s]\s*(-?\d+(\.\d+)?)\s*,\s*(-?\d+(\.\d+)?)')
            WhitespaceRe = re.compile(r's*')

            m = MoveToRe.match(points)
            if(not m):
                raise AttributeError, "Invalid first point: " + point
            else:
                firstx=float(m.group(1))
                firsty=float(m.group(3))
                s.movePenTo(firstx, firsty)
                s.resetorig()
                points = MoveToRe.sub("", points, 1)
            while 1:
                m = PointsRe.match(points)
                if(m):
                    s.drawLineTo(float(m.group(1)), float(m.group(3)))
                    points = PointsRe.sub("", points, 1)
                    continue
                points = WhitespaceRe.sub("", points, 1)
                if(points==""):
                    if(tagname=="polygon"):
                        s.closepath(stylemap,0)
                    else:
                        s.closepath(stylemap,1)
                    break
                raise AttributeError, "Unrecogized gunk in points attribute: " + points

        i = self.add(s)

		# draw a polyline from <polyline> tag
		# leaf node
    def handle_polyline(self, attrs):
        # Handle the <polygon> tag
        self.handle_polywhatever(attrs, "polyline")

		# draw a polygon from <polygon> tag
		# leaf node
    def handle_polygon(self, attrs):
        # Handle the <polygon> tag
        self.handle_polywhatever(attrs, "polygon")

		# saves to file
    def finish(self):
        self.nextFrame()
        self.save("%s.swf" % self.filename)

class DocumentHandler(saxlib.DocumentHandler):
    """Handle general document events. This is the main client
    interface for SAX: it contains callbacks for the most important
    document events, such as the start and end of elements. """

    def __init__(self):
        self.start_tag = {'name' : [], 'indent': '', 'line' : ''}
        
    def setDocumentLocator(self, locator):
        "Receive an object for locating the origin of SAX document events."
        self.locator = locator

    def startDocument(self):
        "Handle an event for the beginning of a document."
        self.level = -1 # we are still below the root element
        #initialize the SWF object
        self.swfdoc = SwfWriter(os.path.splitext(self.locator.getSystemId())[0])
        print "Document: %s" % (self.locator.getSystemId())
        
    def startElement(self, name, attrs):
        "Handle an event for the beginning of an element."
        printout("parser", "startElement: starting " + name)
        self.output_start_tag('start') # output start element of parent
        self.level = self.level + 1
        self.start_tag['indent'] = " " * self.level
        self.start_tag['name'] = [name]
        if name == 'svg':
            self.swfdoc.handle_svg_start(attrs)
        if name == 'text':
            self.swfdoc.handle_text_start(attrs)
        if name == 'rect':
            self.swfdoc.handle_rect(attrs)
        if name == 'path':
            self.swfdoc.handle_path(attrs)
        if name == 'polygon':
            self.swfdoc.handle_polygon(attrs)
        if name == 'polyline':
            self.swfdoc.handle_polyline(attrs)
        if name == 'line':
            self.swfdoc.handle_line(attrs)
        if name == 'circle':
            self.swfdoc.handle_circle(attrs)
            #self.swfdoc.simplecircle(attrs)
        if name == 'g':
            self.swfdoc.handle_g_start(attrs)
        if name == 'a':
            self.swfdoc.handle_a_start(attrs)
            
        # attrs is an AttributeMap object
        # that implements the AttributeList methods.
        for i in range(attrs.getLength()):
            self.start_tag['name'].append("%s=\"%s\"" % (attrs.getName(i),attrs.getValue(i)))

        try:
            self.start_tag['line'] = self.locator.getLineNumber()
        except AttributeError:
            self.start_tag['line'] = None

        printout("parser", "startElement: finishing " + name)


    def endElement(self, name):
        printout("parser", "endElement: starting " + name)
        "Handle an event for the end of an element."
        if name == 'text':
            self.swfdoc.handle_text_end()
        if name == 'g':
            self.swfdoc.handle_g_end()
        if name == 'a':
            self.swfdoc.handle_a_end()
        # output start tag (empty element) or print end tag
        if not self.output_start_tag('end'):
            printout (name, "%s</%s>" % (" " * self.level, name))
        self.level = self.level - 1
        printout("parser", "endElement: finishing " + name)

# where is this used??? 
    def characters(self, all_data, start, length):
        "Handle a character data event."
        # all_data contains the whole file;
        # start:start+length is this part's slice
        data = all_data[start:start+length]
        if data:
            self.swfdoc.contenthandler.handledata(data)
            self.output_start_tag('data') # output start element of parent
            printout ("", "%s%s" % (" " * (self.level + 1), data))

    def output_start_tag (self, where):
        """startElement puts its data in self.start_tag;
        startElement, characters, and endElement call output_start_tag;

        when called by startElement or characters
        and the start tag (of the parent) is still unprinted:
        print start tag, return 1;
        else return None;

        when called by endElement
        and the start tag is still unprinted:
        print empty element tag, return 1;
        else return None"""

        if self.start_tag['name']: # if still unprinted
            if where in ['start', 'data']:
                STAGC = ">"
            elif where in ['end']:
                STAGC = "/>"
            else:
                raise ValueError, 'output_start_tag("start"|"data"|"end")'
            output = "%s<%s%s" % \
                     (self.start_tag['indent'],
                      string.join(self.start_tag['name']), STAGC)
            if self.start_tag['line']:
                output = "%s (line %s)" % (output, self.start_tag['line'])
            printout (self.start_tag['name'][0], output)
            self.start_tag = {'name' : [], 'indent': '', 'line' : ''}
            return 1
        else:
            return None

    def endDocument (self):
        #write the SWF file to disk
        print "Writing to disk"
        self.swfdoc.finish()
        print "Done writing to disk"

class ErrorHandler:
    """Basic interface for SAX error handlers. If you create an object
    that implements this interface, then register the object with your
    Parser, the parser will call the methods in your object to report
    all warnings and errors. There are three levels of errors
    available: warnings, (possibly) recoverable errors, and
    unrecoverable errors. All methods take a SAXParseException as the
    only parameter."""

    global SGMLSyntaxError
    SGMLSyntaxError = "SGML syntax error"

    def error(self, exception):
        "Handle a recoverable error."
        sys.stderr.write ("Error: %s\n" % exception)

    def fatalError(self, exception):
        "Handle a non-recoverable error."
        sys.stderr.write ("Fatal error: %s\n" % exception)
        raise SGMLSyntaxError

    def warning(self, exception):
        "Handle a warning."
        sys.stderr.write ("Warning: %s\n" % exception)

# pick a specific parser
from xml.sax.drivers import drv_xmlproc
SAXparser=drv_xmlproc.SAX_XPParser()

# ask a specific parser from the parser factory
# SAXparser=saxexts.make_parser("xml.sax.drivers.drv_xmlproc")
# in some versions of the saxexts module this is the correct form:
# SAXparser=saxexts.make_parser("xmlproc")

# ask any parser from the parser factory
# SAXparser=saxexts.make_parser()

# ask any validating parser from the XML validating parser factory
# SAXparser=saxexts.XMLValParserFactory.make_parser()

SAXparser.setDocumentHandler(DocumentHandler())

# three options for error handling:
# 1. use our own ErrorHandler
SAXparser.setErrorHandler(ErrorHandler())
# 2. use the ErrorRaiser from saxutils
# SAXparser.setErrorHandler(saxutils.ErrorRaiser())
# 3. use the ErrorPrinter from saxutils
# SAXparser.setErrorHandler(saxutils.ErrorPrinter())

if __name__ == '__main__':
    try:
        SAXparser.parse(sys.argv[1])
    # catch the 'SGMLSyntaxError's raised by our own ErrorHandler
    except SGMLSyntaxError:
        sys.stderr.write("%s; processing aborted\n" % (SGMLSyntaxError))
        sys.exit(1)
    # catch the SAXParseException errors raised by the SAX parser
    # and passed on by ErrorRaiser
    except saxlib.SAXParseException:
        sys.stderr.write("%s; processing aborted\n"
                         % (saxlib.SAXParseException))
        sys.exit(1)
		