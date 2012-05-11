package com.model
{
	import com.utils.StringParser;

	public final class PlayerDataVO
	{
		public var name:String = "";
		public var directon:String = "";
		public var score:String = "";
		public var col:String = "";
		public var rawData:String = "";
		public var xx:Number = 50;
		public var yy:Number = 50;
		public var childrens:XML;
		
		
		public function getStr():String{
			return "name="+name+";directon="+directon+";score="+score+";col="+col+";xx="+xx+";yy="+yy;
		}
		
		public function setStr(str:String):void{
			name = StringParser.parseValuesAt(str,"name");
			directon = StringParser.parseValuesAt(str,"directon");
			score = StringParser.parseValuesAt(str,"score");
			col = StringParser.parseValuesAt(str,"col");
			xx = Number(StringParser.parseValuesAt(str,"xx"));
			yy = Number(StringParser.parseValuesAt(str,"yy"));
			rawData = str;
		}
	}
}