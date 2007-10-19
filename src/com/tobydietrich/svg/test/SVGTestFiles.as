package com.tobydietrich.svg.test
{
	import com.tobydietrich.soundeditor.model.XMLLoaderModel;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class SVGTestFiles extends EventDispatcher
	{
		private var baseURL:String;
		private var fileName:String;
		public var shapes:XML = <shapes />;
		private var shapeObj:Object = {};
		private var isLoaded:Object = {};

		public function SVGTestFiles(baseURL:String, fileName:String)  {
			this.baseURL = baseURL;
			this.fileName = fileName;
			var indexURL:String = baseURL + fileName;
			var indexLoaderModel:XMLLoaderModel = new XMLLoaderModel('index', indexURL);
			 indexLoaderModel.addEventListener(Event.COMPLETE, indexXMLLoaded);
		}
		
	
		private function indexXMLLoaded(event:Event):void {
			for each(var elt:XML in event.target.xml.shape) {
				var svgURL:String = baseURL + elt.@href;
				var svgLoaderModel:XMLLoaderModel = new XMLLoaderModel(elt.@name, svgURL);
				svgLoaderModel.metadata = elt;
				isLoaded[svgURL] = false;
				svgLoaderModel.addEventListener(Event.COMPLETE, svgXMLLoaded);
			}
		}
		private function svgXMLLoaded(event:Event):void {
			var loaderModel:XMLLoaderModel = event.target as XMLLoaderModel;
			isLoaded[loaderModel.url] = true;
			var shape:XML = loaderModel.metadata;
			shape.@url = loaderModel.url;
			shape.appendChild("<![CDATA[\n" + loaderModel.xml.toXMLString() + "\n]]>");
			shapes.appendChild(shape);
			check();
		}
		public function get xml():XML {
			return shapes;
		}
		private function check():void {
			for each(var b:Boolean in isLoaded) {
				if (b==false) {
					return;
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		// FIXME - return only exact matches
		public function getSVG(query:XML):XML {
			var candidates:XMLList = shapes.shape.(@name == query.@name && @type == query.@type);
			switch(candidates.length()) {
				case 0:
					throw new Error("no svg found");
				case 1:
					return new XML(candidates[0].toString().replace("<![CDATA[","").replace("]]>",""));
				default:
					throw new Error("ambigous match");
			}
		}
	}
}