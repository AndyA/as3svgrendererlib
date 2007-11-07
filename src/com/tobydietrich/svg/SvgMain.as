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
				var myContainer:Sprite = new Sprite();
				grid.addChild(myContainer);
				// put in the grid
				myContainer.x = ELT_WIDTH * (i%ROW_SIZE);
				myContainer.y = ELT_HEIGHT * Math.floor(i/ROW_SIZE);
				
				// draw the boundary around the container
				myContainer.graphics.lineStyle(5, 0x00FF00);
				myContainer.graphics.drawRect(0, 0, ELT_WIDTH - 40, ELT_WIDTH - 40);
				
				
				ViewWindowMinimizer.minimizeViewWindow(mySVG);
				// set the viewbox to occupy a spot in the grid
				ViewWindowMinimizer.fitInContainer(myContainer, mySVG);
		    
				myContainer.addChild(mySVG);
				
				
				
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
