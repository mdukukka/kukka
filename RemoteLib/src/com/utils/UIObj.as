package com.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class UIObj{
		
		// Create textField and add to ref
		public static function creatTxt (ref:DisplayObjectContainer,ww:Number = 10,hh:Number = 10,xx:Number=10,yy:Number=10,border:Boolean = true,bg:Boolean= true,col:int = 0xfffffc):TextField {
			var tempTxt:TextField = new TextField;
			tempTxt.type = TextFieldType.INPUT;
			tempTxt.border = border;
			tempTxt.background = bg;
			tempTxt.backgroundColor = col;
			tempTxt.width = ww;
			tempTxt.height = hh;
			tempTxt.x = xx;
			tempTxt.y = yy;
			ref.addChild(tempTxt);
			return tempTxt;
		}
	}
}