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
	import net.user1.reactor.SynchronizationState;
	
	public class Remote extends EventDispatcher
	{
		private static var thisObj:Remote;
		public static const IJOINED_ADDMYSNAKE:String = "ijoinedaddsnake";
		public static const SNAKE_NAME_CHANGE:String = "snakenameChange";
		public static const UPDATE_SNAKES_QUANTITY:String = "updatequantity";
		public static const SUMBODY_BEFORE_YOU:String = "someBodybeforeyou";
		public static const SUMBODY_AFTER_YOU:String = "someBodyafteryou";
		public static const SUMBODY_LEFT:String = "someBodyleft";
		public static const UPDATEUSERLIST:String = "updateuserlist";
		
		public static var MANAGER:RoomManager;
		public static var MESSAGE_MANAGER:MessageManager;
		
		public var reactor:Reactor;
		public  var chatRoom:Room; //bala for board;
		private var strP:StringParser;
		public var foodData:FoodDataVo = new FoodDataVo();
		
		public function Remote(p_key:SingletonBlocker)
		{
			if (p_key == null) {
				throw new Error("Error:Use MoveController.getInstance() instead of new.");
			}
			
			reactor = new Reactor();
			reactor.addEventListener(ReactorEvent.READY,readyListener);
			// Connect to the server
			reactor.connect("tryunion.com", 80);
		}
		
		public static function getInstance():Remote{
			if(thisObj == null){
				thisObj = new Remote(new SingletonBlocker());
			}
			
			return thisObj;
		}
		
		// Method invoked when the connection is ready
		protected function readyListener (e:ReactorEvent):void {
			MANAGER = reactor.getRoomManager();
			chatRoom = MANAGER.createRoom("bala");
			//chatRoom.addMessageListener(CustomEvent.ABOUT_SNAKEDATA,gotMessageForSnake);
			//chatRoom.addMessageListener(CustomEvent.CHAT_MESSAGE,gotMessageForChat);
			//chatRoom.addMessageListener(CustomEvent.ABOUT_DIRECTION,gotMessageForDirections);
			chatRoom.addEventListener(RoomEvent.JOIN,joinRoomListener);
			chatRoom.addEventListener(RoomEvent.ADD_OCCUPANT,addClientListener);
			chatRoom.addEventListener(RoomEvent.REMOVE_OCCUPANT,removeClientListener);
			chatRoom.addEventListener(RoomEvent.UPDATE_CLIENT_ATTRIBUTE,updateClientAttributeListener);
			chatRoom.join();
		}
		/*protected function gotMessageForDirections(fromClient:IClient,messageText:String):void {
			mvController.tellToController_GotDirections(getUserName(fromClient),messageText);
		}*/
		// Method invoked when a chat messageText(message+score) is received
		/*protected function gotMessageForSnake(fromClient:IClient,messageText:String):void {
			trace("dd1 Remote got messageText1=",messageText)
			var tempPlayer:PlayerDataVO = new PlayerDataVO();
			tempPlayer.setStr(messageText);
			tempPlayer.name = getUserName(fromClient);
			trace("dd1 Remote got messageText2=",tempPlayer.getStr());
			MoveController.getInstance().tellToController_Snake(tempPlayer);
		}*/
		
		// Method invoked when a client joins the room
		protected function addClientListener (e:RoomEvent):void {
			trace("ddd addClientListener_______________");
			if (e.getClient().isSelf()) {
				trace("ddd You joined the chat.");
				var tempPlayer:PlayerDataVO = new PlayerDataVO();
				tempPlayer.name = getUserName(e.getClient());
				tempPlayer.directon = "RR";
				tempPlayer.score = "0";
				dispatchEvent(new CustomEvent(Remote.IJOINED_ADDMYSNAKE,tempPlayer));
			} else {
				if (chatRoom.getSyncState() != SynchronizationState.SYNCHRONIZING) {
					//trace("dd1 somebody joined the room",getUserName(e.getClient())," sentMessage=",Board.thisObj.currentSnakeStatus().getStr());
					// Show a "guest joined" message only when the room isn't performing
					// its initial occupant-list synchronization.
					//Board.thisObj.incomingMessages.appendText(getUserName(e.getClient())+ " joined the chat.\n");
					//e.getClient().sendMessage(MsgController.ABOUT_SNAKEDATA,Board.thisObj.currentSnakeStatus().getStr());
				}
			}
			
			//check the snake before you..
			updateUserList(true);
		}
		
		// Method invoked when the current client joins the room
		protected function joinRoomListener (e:RoomEvent):void {
			trace("ddd joinRoomListener_____________________");
			updateUserList();
		}
		// Method invoked when a client leave the room
		protected function removeClientListener (e:RoomEvent):void {
			trace("ddd removeClientListener_____________________");
			/*Board.thisObj.incomingMessages.appendText(getUserName(e.getClient())
				+ " left the chat.\n");
			Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;*/
			dispatchEvent(new CustomEvent(Remote.SUMBODY_LEFT,getUserName(e.getClient())));
			updateUserList();
		}
		
		// Helper method to display the room's
		// clients in the user list
		private var userList:int = 1;
		protected function updateUserList (checkBeforeYou:Boolean = false):void {
			var tempList:int = 0;
			dispatchEvent(new CustomEvent(Remote.UPDATEUSERLIST,true));
			//for new snakes add or remove..
			if(userList != tempList){
				userList = tempList;
				trace("ddd List Snakes Updating2...",userList)
				dispatchEvent(new CustomEvent(Remote.UPDATE_SNAKES_QUANTITY,chatRoom.getOccupants()));
			}
			
			//check snakes before you..
			if(checkBeforeYou == true){
				trace("dd1 check before me...",tempList)
				if(tempList>1){
					dispatchEvent(new CustomEvent(Remote.SUMBODY_BEFORE_YOU,true));
				}else{
					dispatchEvent(new CustomEvent(Remote.SUMBODY_BEFORE_YOU,false))
				}
			}
		}
		
		// Helper method to retrieve a client's user name.
		// If no user name is set for the specified client,
		// returns "Guestn" (where 'n' is the client's id).  
		public function getUserName (client:IClient):String {
			var username:String = client.getAttribute("username");
			if (username == null){
				return "Guest" + client.getClientID();
			} else {
				return username;
			}
		}
		
		// Method invoked when any client in the room
		// changes the value of a shared attribute
		protected function updateClientAttributeListener (e:RoomEvent):void {
			/*var changedAttr:Attribute = e.getChangedAttr();
			var objj:Object = new Object();
			//trace("dd1 atribute changed",changedAttr);
			if (changedAttr.name == "username") {
				if (changedAttr.oldValue == null) {
					Board.thisObj.incomingMessages.appendText("Guest" + e.getClientID());
					objj.oldN = "Guest" + e.getClientID();
				} else {
					Board.thisObj.incomingMessages.appendText(changedAttr.oldValue);
					objj.oldN = changedAttr.oldValue;
				}
				objj.newN =  getUserName(e.getClient());
				trace("ddd Remote dispatching name changed=",objj.oldN," TO ",objj.newN);
				dispatchEvent(new CustomEvent(Remote.SNAKE_NAME_CHANGE,objj));
				Board.thisObj.incomingMessages.appendText(" 's name changed to "+ getUserName(e.getClient())+ ".\n");
				Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
				updateUserList();
			}*/
		}
		
		// Keyboard listener for nameInput
		public function nameKeyUpListener (e:KeyboardEvent):void {
			var self:IClient;
			if (e.keyCode == Keyboard.ENTER) {
				self = reactor.self();
				self.setAttribute("username", e.target.text);
				e.target.text = "";
			}
		}
		
		/*protected function gotMessageForChat (fromClient:IClient,messageText:String):void {
			Board.thisObj.incomingMessages.appendText(getUserName(fromClient) + " says: " + messageText+ "\n");
			Board.thisObj.incomingMessages.scrollV = Board.thisObj.incomingMessages.maxScrollV;
		}
		
		public function tellToAllAboutFood():void{
			chatRoom.sendMessage(MsgController.ADDFOOD_AT,true,null,foodData.getString());
		}*/
	}
}


//blocker
internal class SingletonBlocker {}