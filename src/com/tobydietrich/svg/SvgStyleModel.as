package com.tobydietrich.svg
{
	public class SvgStyleModel
	{
		public static var FILL:String = "fill";
		public static var STROKE:String = "stroke";
		
		public static function setStyle(node:XML, property:String, value:uint):void {
			node.@style = node.@style + property + ":" + value + ";";
		}
		
		public static function CSStoXML(elt:XML):XML {
			var env:String = elt.@styleenv;
			var envElts:Array = env.split(/;\s*/);
			var retVal:XML = <styles />;
			var keyValueSplitter:Function =  function(element:*, index:int, arr:Array):void {
				var elt:String = element as String;
				if(elt.length == 0) {
					return;
				}
				var splitElt:Array = elt.split(/:/);
				if(splitElt.length != 2) {
					throw new SVGParseError("can't parse stylesheet");
				}
				this.@[splitElt[0]] = splitElt[1];
			};
			envElts.forEach(keyValueSplitter, retVal);
			return retVal;
		}
	}
}