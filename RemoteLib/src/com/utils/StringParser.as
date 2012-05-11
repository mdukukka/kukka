package com.utils {
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Balakrishna vamsibalu@gmail.com
	 */
	public class StringParser {
		//public static var _pairDict:Dictionary;
		
		public static function parseValues(str:String):Dictionary {
			var _pairs:Array = str.split(";");
			var _pairDict:Dictionary = new Dictionary(true);
			var pairName:String;
			var pairValue:String;
			
			for (var i:int = 0; i <_pairs.length; i++) {
				pairName = _pairs[i].split("=")[0];
				pairValue = _pairs[i].split("=")[1];
				_pairDict[pairName] = pairValue;
			}
			
			return _pairDict;
		}
		
		public static function getValue(_mypairDict:Dictionary,$val:String):String {
			if (_mypairDict[$val] == null) {
				return "#";
			} else {
				return _mypairDict[$val];
			}
		}
		
		public static function parseValuesAt(str:String,pairName:String):String {
			var _pairs:Array = str.split(";");
			var pairValue:String = "";
			
			for (var i:int = 0; i <_pairs.length; i++) {
				if(pairName == _pairs[i].split("=")[0]){
					pairValue = _pairs[i].split("=")[1];
					break;
				}
			}
			return pairValue;
		}
		
	}
	
}