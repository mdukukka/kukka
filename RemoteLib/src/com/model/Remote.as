/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.model
{
	import com.events.CustomEvent;
	import com.utils.StringParser;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import net.user1.reactor.Attribute;
	import net.user1.reactor.Client;
	import net.user1.reactor.IClient;
	import net.user1.reactor.MessageManager;
	import net.user1.reactor.Messages;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomEvent;
	import net.user1.reactor.RoomManager;
	import net.user1.reactor.RoomSettings;
	import net.user1.reactor.SynchronizationState;
	
	public class Remote extends EventDispatcher
	{
		public static var thisObj:Remote;
		public static const IJOINED_ADDMYSNAKE:String = "ijoinedaddsnake";
		public static const SUMBODY_LEFT:String = "someBodyleft";
		public static const UPDATEUSERLIST:String = "updateuserlist";
		public static const SERVERREADY:String = "reactorReday";
		
		public static var MANAGER:RoomManager;
		public static var MESSAGE_MANAGER:MessageManager;
		
		public var reactor:Reactor;
		public  var chatRoom:Room; //bala for board;
		private var strP:StringParser;
		private var _foodData:FoodDataVo = new FoodDataVo();
		public static var playerData:PlayerDataVO = new PlayerDataVO();
		
		public function Remote(p_key:SingletonBlocker){
			if (p_key == null) {
				throw new Error("Error:Use MoveController.getInstance() instead of new.");
			}
			
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY,readyListener);
			// Connect to the server
			reactor.connect("tryunion.com", 80);
		}
		
		protected function justUpdateuserList(fromClient:IClient,messageText:String):void {
			dispatchEvent(new CustomEvent(Remote.UPDATEUSERLIST,true));
		}
		
		public static function getInstance():Remote{
			if(thisObj == null){
				thisObj = new Remote(new SingletonBlocker());
			}
			
			return thisObj;
		}
		
		// Method invoked when the connection is ready
		protected function readyListener (e:ReactorEvent):void {
			dispatchEvent(new Event(Remote.SERVERREADY));
		}
		
		//MsgController
		public function joinRoom(roomName:String):void{
			// Create a room that doesn't go away when no one is in it
			//var roomSettings:RoomSettings = new RoomSettings();
			//roomSettings.removeOnEmpty = false;  //roomSettings.dieOnEmpty = false;
			
			MANAGER = reactor.getRoomManager();
			chatRoom = MANAGER.createRoom(roomName);
			//chatRoom.addEventListener(RoomEvent.JOIN,joinRoomListener);
			chatRoom.addEventListener(RoomEvent.ADD_OCCUPANT,addClientListener);
			chatRoom.addEventListener(RoomEvent.REMOVE_OCCUPANT,removeClientListener);
			chatRoom.addMessageListener("justUpdate",justUpdateuserList);
			chatRoom.join();
		}
		
		// Method invoked when the current client joins the room
		/*protected function joinRoomListener (e:RoomEvent):void {
			trace("ddd6 joinRoomListener_____________________");
			//updateUserList();
		}*/
		
		// Method invoked when a client joins the room
		protected function addClientListener (e:RoomEvent):void {
			trace("ddd6 addClientListener_______________");
			if (e.getClient().isSelf()) {
				trace("fll You joined the chat.");
				playerData.directon = "RR";
				playerData.score = "0";
				dispatchEvent(new CustomEvent(Remote.IJOINED_ADDMYSNAKE,playerData));
			} else {
				if (chatRoom.getSyncState() != SynchronizationState.SYNCHRONIZING) {
					//dispatchEvent(new CustomEvent(Remote.IJOINED_ADDMYSNAKE,e));
					// Show a "guest joined" message only when the room isn't performing
					// its initial occupant-list synchronization.
				}
			}
		}
		
		// Method invoked when a client leave the room
		protected function removeClientListener (e:RoomEvent):void {
			trace("ddd removeClientListener_____________________");
			dispatchEvent(new CustomEvent(Remote.SUMBODY_LEFT,e));
			dispatchEvent(new CustomEvent(Remote.UPDATEUSERLIST,true));
		}
		
		// Helper method to retrieve a client's user name.
		//return "Guest" + client.getClientID();
		
		// Keyboard listener for nameInput
		public function setMyFBData(faceBookName:String,faceBookId:String,faceBookIMG:String):void {
			var self:IClient  = reactor.self();
			trace("dd6 setting setMyFBData Remote",faceBookName);
			self.setAttribute("unm",faceBookName);
			self.setAttribute("uid",faceBookId);
			self.setAttribute("uimg",faceBookIMG);
		}
		
		public function disconnectMe():void{
			// You don't need to call the leave() function since
			// the disconnect will remove the client when the
			// connection is closed but it is a good practice in
			// case something goes wrong in the disconnect and
			// the user appears as a ghost (ghosts are eventually
			// removed by the server when they cannot be reached).
			if(chatRoom != null)
				chatRoom.leave();
			
			//reactor.close();
		}
		
		public function get foodData():FoodDataVo{
			return _foodData;
		}
		
		public function set foodData(value:FoodDataVo):void{
			_foodData = value;
			chatRoom.setAttribute("ff",_foodData.fname);
			trace("dd5 setAttribute=",chatRoom.getAttribute("ff"));
		}
		
	}
}


//blocker
internal class SingletonBlocker {}