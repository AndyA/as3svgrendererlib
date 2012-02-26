﻿package com.lorentz.SVG.display {
	import com.lorentz.SVG.data.style.StyleDeclaration;
	import com.lorentz.SVG.display.base.SVGElement;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.SVG.parser.AsyncSVGParser;
	import com.lorentz.SVG.svg_internal;
	import com.lorentz.SVG.text.FTESVGTextDrawer;
	import com.lorentz.SVG.utils.SVGUtil;
	import com.lorentz.SVG.utils.StringUtil;
	
	import flash.events.Event;
	
	[Event(name="parseStart", type="com.lorentz.SVG.events.SVGEvent")]
	[Event(name="parseComplete", type="com.lorentz.SVG.events.SVGEvent")]
	[Event(name="rendered", type="com.lorentz.SVG.events.SVGEvent")]
	[Event(name="elementAdded", type="com.lorentz.SVG.events.SVGEvent")]
	[Event(name="elementRemoved", type="com.lorentz.SVG.events.SVGEvent")]
	
	public class SVGDocument extends SVG {		
		private var _parser:AsyncSVGParser;
		private var _parsing:Boolean = false;
						
		private var _definitions:Object = {};
		private var _stylesDeclarations:Object = {};
		private var _firstValidationAfterParse:Boolean = false;
		
		public var gradients:Object = {};
		
		/**
		 * Url used as a base url to search referenced files on svg. 
		 */		
		public var baseURL:String;
		
		/**
		 * Determines that the document should validate rendering during parse.
		 * Set to true if you want to progressively show the SVG while it is parsing.
		 * Set to false to improve speed and show it only after parse is complete.
		 */		
		public var validateWhileParsing:Boolean = true;

		/**
		 * Determines if the document should force validation after parse, or should wait the document be on stage.  
		 */		
		public var validateAfterParse:Boolean = true;
		
		/**
		 * Default value for attribute fontStyle on SVGDocuments, and also is used an embedded font is missing, and missingFontAction on svgDocument is USE_DEFAULT.
		 */		
		public var defaultFontName:String = "Verdana";
		
		/**
		 * Determines if the document should use embedded 
		 */		
		public var useEmbeddedFonts:Boolean = true;
		
		/**
		 * Function that is called before sending svgTextFormat to TextDrawer, allowing you to change texts formats with your own rule.
		 * The function can alter any property on textFormat
		 * Function parameters: function(textFormat:SVGTextFormat):void
		 * Example: Change all texts inside an svg to a specific embedded font
		 */		
		public var changeTextFormatFunction:Function;
		
		/**
		 * Class used to draw texts 
		 */		
		public var textDrawerClass:Class = FTESVGTextDrawer;
		
		public function SVGDocument(){			
			super();
			addEventListener(SVGEvent.VALIDATED, validatedHandler, false, 0, true);
		}
		
		override public function get document():SVGDocument {
			return this;
		}
		
		override public function setSVGDocument(value:SVGDocument):void {
		}
		
		public function parse(xmlOrXmlString:Object):void {
			var xml:XML;
			
			if(xmlOrXmlString is String)
			{
				var xmlString:String = SVGUtil.processXMLEntities(String(xmlOrXmlString));
				
				var oldXMLIgnoreWhitespace:Boolean = XML.ignoreWhitespace;
				XML.ignoreWhitespace = false;
				xml = new XML(xmlString);
				XML.ignoreWhitespace = oldXMLIgnoreWhitespace; 
			}
			else if(xmlOrXmlString is XML)
				xml = xmlOrXmlString as XML;
			else
				throw new Error("Invalid param 'xmlOrXmlString'.");	
			
			parseXML(xml);
		}
						
		private function parseXML(svg:XML):void {			
			clear();
						
			if(_parsing)
				_parser.cancel();
						
			_parsing = true;
			
			dispatchEvent( new SVGEvent( SVGEvent.PARSE_START ) );
			
			_parser = new AsyncSVGParser(this, svg);
			_parser.addEventListener(Event.COMPLETE, parser_completeHandler);
			_parser.parse();
		}

		
		protected function parser_completeHandler(e:Event):void {
			_parsing = false;
			_parser = null;
			dispatchEvent( new SVGEvent( SVGEvent.PARSE_COMPLETE ) );
			
			_firstValidationAfterParse = true;
			
			if(validateAfterParse)
				validate();
		}
		
		protected function validatedHandler(e:Event):void {
			if(_firstValidationAfterParse)
			{
				_firstValidationAfterParse = false;
				dispatchEvent( new SVGEvent( SVGEvent.RENDERED ) );
			}
		}
		
		public function clear():void {
			id = null;
			svgClass = null;
			svgClipPath = null;
			
			svgViewBox = null;
			svgX = null;
			svgY = null;
			svgWidth = null;
			svgHeight = null;
			
			_stylesDeclarations = {};
			gradients = {};
			
			style.clear();
			
			for(var id:String in _definitions)
				removeDefinition(id);

			while(numElements > 0)
				removeElementAt(0);
			
			while(_content.numChildren > 0)
				_content.removeChildAt(0);
				
			_content.scaleX = 1;
			_content.scaleY = 1;
		}
		
		public function listStyleDeclarations():Vector.<String> {
			var selectorsList:Vector.<String> = new Vector.<String>();
			for(var id:String in _stylesDeclarations)
				selectorsList.push(id);
			return selectorsList;
		}
		
		public function addStyleDeclaration(selector:String, styleDeclaration:StyleDeclaration):void {
			_stylesDeclarations[selector] = styleDeclaration;
		}
		
		public function getStyleDeclaration(selector:String):StyleDeclaration {
			return _stylesDeclarations[selector];
		}
		
		public function removeStyleDeclaration(selector:String):StyleDeclaration {
			var value:StyleDeclaration = _stylesDeclarations[selector];
			delete _stylesDeclarations[selector];
			return value;
		}
		
		public function listDefinitions():Vector.<String> {
			var definitionsList:Vector.<String> = new Vector.<String>();
			for(var id:String in _definitions)
				definitionsList.push(id);
			return definitionsList;
		}
		
		public function addDefinition(id:String, element:SVGElement):void {
			if(!_definitions[id]){
				_definitions[id] = element;
				element.setSVGDocument(this);
			}
		}
				
		public function getDefinitionClone(id:String):SVGElement {
			if(_definitions[id] == null)
				return null;
				
			return _definitions[id].clone(true);
		}
		
		public function removeDefinition(id:String):void {
			if(_definitions[id])
			{
				var element:SVGElement = _definitions[id] as SVGElement;
				element.setSVGDocument(null);
				_definitions[id] = null;
			}
		}
		
		svg_internal function onElementAdded(element:SVGElement):void {
			this.dispatchEvent( new SVGEvent( SVGEvent.ELEMENT_ADDED, element ));
		}
		
		svg_internal function onElementRemoved(element:SVGElement):void {
			this.dispatchEvent( new SVGEvent( SVGEvent.ELEMENT_REMOVED, element ));
		}

		public function resolveURL(url:String):String
		{
			if (url != null && !isHttpURL(url) && baseURL!=null)
			{
				if (url.indexOf("./") == 0)
					url = url.substring(2);

				if (isHttpURL(baseURL))
				{
					var slashPos:Number;
	
					if (url.charAt(0) == '/')
					{
						// non-relative path, "/dev/foo.bar".
						slashPos = baseURL.indexOf("/", 8);
						if (slashPos == -1)
							slashPos = baseURL.length;
					}
					else
					{
						// relative path, "dev/foo.bar".
						slashPos = baseURL.lastIndexOf("/") + 1;
						if (slashPos <= 8)
						{
							baseURL += "/";
							slashPos = baseURL.length;
						}
					}
	
					if (slashPos > 0)
						url = baseURL.substring(0, slashPos) + url;
				} else {
					url = StringUtil.rtrim(baseURL, "/") + "/" + url;
				}
			}
	
			return url;
		}
	
		public static function isHttpURL(url:String):Boolean
		{
			return url != null &&
				   (url.indexOf("http://") == 0 ||
					url.indexOf("https://") == 0);
		}
		
		override public function validate():void {
			super.validate();
			if(this.numInvalidElements > 0)
				queueValidation();
		}
		
		override protected function get numInvalidElements():int {
			return super.numInvalidElements;
		}

		override protected function set numInvalidElements(value:int):void {
			if(super.numInvalidElements == 0 && value > 0)
				queueValidation();

			super.numInvalidElements = value;
		}
		
		private var _validationQueued:Boolean
		protected function queueValidation():void {
			if(!_validationQueued){
				_validationQueued = false;
				
				if (stage != null) {
					stage.addEventListener(Event.ENTER_FRAME, validateCaller, false, 0, true);
					stage.addEventListener(Event.RENDER, validateCaller, false, 0, true);
					stage.invalidate();
				} else {
					addEventListener(Event.ADDED_TO_STAGE, validateCaller, false, 0, true);
				}
			}
		}
		
		protected function validateCaller(e:Event):void {
			_validationQueued = false;
			
			if(_parsing && !validateWhileParsing){
				queueValidation();
				return;
			}
			
			if (e.type == Event.ADDED_TO_STAGE) {
				removeEventListener(Event.ADDED_TO_STAGE, validateCaller);
			} else {
					e.target.removeEventListener(Event.ENTER_FRAME, validateCaller, false);
					e.target.removeEventListener(Event.RENDER, validateCaller, false);
					if (stage == null) {
						// received render, but the stage is not available, so we will listen for addedToStage again:
						addEventListener(Event.ADDED_TO_STAGE, validateCaller, false, 0, true);
						return;
					}
			}
			
			validate();
		}
	}
}