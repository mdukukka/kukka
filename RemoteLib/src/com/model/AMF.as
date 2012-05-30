package com.model{
	import com.events.AMFEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.*;
	
	public class AMF extends EventDispatcher{
		public var gw:NetConnection;
		private var res:Responder;
		public static const GetKey:String="Omshanti.getKey";
		public function AMF(gateway:String=""){
			// constructor code
			gw = new NetConnection();
			gw.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
			if(gateway ==""){
				gw.connect("http://vamsibalu.ueuo.com/amfphp/gateway.php");//http://localhost/amfphp%201.9/gateway.php
				trace("AMF connecting http://vamsibalu.ueuo.com/amfphp/gateway.php")
			}else{
				gw.connect(gateway);
			}
			res= new Responder(onResult,onFault);
		}
		
		
		
		private function netStatusHandler(event:NetStatusEvent):void {
			trace("NetStatusEvent")
			if (event.info.code == "NetConnection.Connect.Failed") {
				trace("AMF Connection failed: Try harder")
				
			} else if (event.info.code == "NetConnection.Connect.Rejected") {
				trace("AMF Connection rejected - not allowed to connect");
			} else if (event.info.code == "NetConnection.Connect.Success") {
				trace("AMF Connection has succeeded");
				getKey();
			} else if (event.info.code == "NetConnection.Connect.Closed") {
				trace("AMF Connection has closed");
			}
		}
		
		private function onResult(responds:Object):void{
			trace("AMF Connection respond for key=: dispatched",responds)
			dispatchEvent(new AMFEvent(AMFEvent.FORKEY,responds));
		}
		
		private function onFault(responds:Object):void{
			if (responds){
				for (var i:* in responds)
				{
					trace("Got AMF Error",responds[i]);
				}
			}
		}
		
		private function getKey():void{
			gw.call(GetKey,res);
		}
		
	}
	
}