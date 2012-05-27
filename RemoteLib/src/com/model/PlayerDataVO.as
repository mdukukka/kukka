package com.model
{
	import com.utils.StringParser;

	public final class PlayerDataVO
	{
		public var unm:String = "";
		public var speed:Number = 500;
		public var directon:String = "";
		public var score:String = "";
		public var col:int;
		public var rawData:String = "";
		public var xx:Number = 50;
		public var yy:Number = 50;
		public var childrens:XML;
		
		
		public function getStr():String{
			return "unm="+unm+";directon="+directon+";score="+score+";col="+col+";xx="+xx+";yy="+yy+";speed="+speed;
		}
		
		public function setStr(str:String):void{
			unm = StringParser.parseValuesAt(str,"unm");
			directon = StringParser.parseValuesAt(str,"directon");
			score = StringParser.parseValuesAt(str,"score");
			col = int(StringParser.parseValuesAt(str,"col"));
			xx = Number(StringParser.parseValuesAt(str,"xx"));
			yy = Number(StringParser.parseValuesAt(str,"yy"));
			rawData = str;
		}
	}
}