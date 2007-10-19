package com.tobydietrich.svg
{

	public class ASListHandler 	{
		private var list:String = "";
		
		public function startList():void
		{
			list += "<list>";
		}
		
		public function item(item:XML):void
		{
			list += item.toXMLString();
		}
		
		public function endList():void
		{
			list += "</list>";
		}
		
	}
}