package com.tobydietrich.svg {
	
	import com.tobydietrich.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	
	public class SvgMain extends Sprite
	{
			
			private var svgFiles:SVGTestFiles;
			private var ROW_SIZE:int = 5;
			private var ELT_WIDTH:int = 1024;
			private var ELT_HEIGHT:int = 768;
			private var SCALE:Number = 1/5;
			private var foo:String ="http://localhost/audeto/data/shapes/";
			
		public function SvgMain(baseURL:String)
		{
			svgFiles = new SVGTestFiles(baseURL, "shapes.xml");
			svgFiles.addEventListener(Event.COMPLETE, svgLoaded);
		}
		
		private function renderAndRecord(svg:XML, printer:XML, name:String="", type:String=""):SVGRenderer {
			var query:XML = <shape name={name} type={type} />;
			printer.appendChild(query);
			
			// create some nodes
			var initialSVG:XML = <initialSVG />;
			query.appendChild(initialSVG);
			
			var parseOutput:XML = <parseOutput />;
			query.appendChild(parseOutput);
			
			var renderOutput:XML = <renderOutput />;
			query.appendChild(renderOutput);
			
			var transformInfo:XML = <transformInfo />;
			query.appendChild(transformInfo);
			
			// process SVG.
			initialSVG.appendChild(svg);
			var myAST:SVGParser = new SVGParser(svg);
			parseOutput.appendChild(myAST.xml);
			var mySVG:SVGRenderer = new SVGRenderer(myAST.xml);
			
			mySVG.name = "mySVG_" + name + "_" + type;
			renderOutput.appendChild(DisplayObjectTraceXML.traceXML(mySVG));
			return mySVG;
		}
		
		private function svgLoaded(event:Event):void {
			var collection:SVGTestFiles = event.target as SVGTestFiles;
			//trace(collection.xml);
			var printer:XML = <printer />;
			var grid:Sprite = new Sprite();
			addChild(grid);
			var i:int = 0;
			// determine height and width
			for each(var elt:XML in collection.shapes.shape) {
				var query:XML = <shape name={elt.@name} type={elt.@type} />;
				var svg:XML = collection.getSVG(query);
				var mySVG:SVGRenderer = renderAndRecord(svg, printer, elt.@name, elt.@type);
				grid.addChild(mySVG);
				
				// obtain some sprites from the SVG output
				var viewBox:Sprite = mySVG.getChildAt(0) as Sprite;
				var activeArea:Sprite = viewBox.getChildAt(0) as Sprite;
				
				// put in the grid
				mySVG.x = ELT_WIDTH * (i%ROW_SIZE);
				mySVG.y = ELT_HEIGHT * Math.floor(i/ROW_SIZE);
				
				// set the viewbox to occupy a spot in the grid
				mySVG.width = ELT_WIDTH -40;
				mySVG.height = ELT_HEIGHT - 40;
				
				// draw the boundary around the viewBox
				mySVG.graphics.lineStyle(5, 0x00FF00);
				mySVG.graphics.drawRect(0, 0, viewBox.width, viewBox.height);
				
				//ViewWindowMinimizer.scaleUp(mySVG);
				
			    
			    // find the minimum point in the active area.
			    var min:Point = new Point(viewBox.width,viewBox.height);
			    var r:Rectangle;
			    for (var j:int= 0; j < activeArea.numChildren; j++) {
						var c:DisplayObject = activeArea.getChildAt(j);
						r = c.getBounds(activeArea);
						min.x = Math.min(min.x, r.x);
						min.y = Math.min(min.y, r.y);
					}
			    
			    // reset the x, y coordinates to the negative of the scaling factor times the minimum point.
			    activeArea.x = -activeArea.scaleX * min.x;
			    activeArea.y = -activeArea.scaleY * min.y;
				//activeArea.x = activeArea.y = 0;
				
			
				
				// DEBUG: get the bounds of the content area
				/*
					r = activeArea.getBounds(viewBox);	
				transformInfo.appendChild(<rectangle x={r.x} y={r.y} width={r.width} height={r.height} />);
				
				if(r.width > 0 && r.width < 10000 && r.height > 0 && r.height < 10000) {	
					// DEBUG draw a bounding box
					var boundingBox:Sprite = new Sprite();
					//viewBox.addChild(boundingBox); // get the bounding box.
					boundingBox.name = "boundingBox";
					boundingBox.graphics.lineStyle(5, 0x00FFFF);
					boundingBox.graphics.drawRect(r.x, r.y, r.width, r.height);
					
					// numeric overflow in getBounds....
					if(r.width <= 0 || r.width > 10000 || r.height <= 0 || r.height > 10000) {
						throw new Error("insane numbers");
					}
				}
				*/
				
				i++;
			}
			var svgList:XML = <svgList />;
			//printer.appendChild(svgList);
			svgList.appendChild(DisplayObjectTraceXML.traceXML(grid));
			
			this.scaleX = SCALE;
			this.scaleY = SCALE;
			
			trace("-----------------------------------------------------------------------");
			trace(printer);
		}
	}
}
