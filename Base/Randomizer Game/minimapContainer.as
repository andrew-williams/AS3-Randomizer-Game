package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class minimapContainer extends MovieClip {
		private static const startroomID:int = 1;
		private var westEnabled:Boolean = false;
		private var eastEnabled:Boolean = false;
		private var northEnabled:Boolean = false;
		private var southEnabled:Boolean = false;
		private var xPos:int = -1;
		private var yPos:int = -1;
		private var maxDoors:int = 4;
		
		private var roomWidthStart:int = 0;
		private var roomHeightStart:int = 0;
		private var roomWidth:int;
		private var roomHeight:int;
		
		private static const doorFrequency:int = 2; //lower number = higher chance of door
		private static const gridWidth:int = 11;
		private static const gridHeight:int = 11;
		private	var startRoom:Boolean = false;
		private var exitroom:Boolean = false;
		
		public function addWallOnDisabledDoor(): void{
			/*
			if (!eastEnabled){
				tilegeneration.disableDoor("East",wall,wallArray);
			}
			if (!westEnabled){
				tilegeneration.disableDoor("West",wall,wallArray);
			}
			if (!northEnabled){
				tilegeneration.disableDoor("North",wall,wallArray);
			}
			if (!southEnabled){
				tilegeneration.disableDoor("South",wall,wallArray);
			}
			*/
		}
		
		public function minimapContainer(xLoc:int, yLoc:int, entranceDoor:String = "None", startRoom:Boolean = false, exitroom:Boolean = false) : void{
			// constructor code
			
			nDoor.height = 40
			sDoor.height = 40;
			eDoor.width = 40;
			wDoor.width = 40;
			if (!startRoom){
				this.visible = false;
				this.playerLoc.visible = false;
			}
			else{
				this.visible = true;
				this.playerLoc.visible = true;
			}
			
			
			this.startRoom = startRoom;
			this.exitroom = exitroom;
			//trace(startRoom);
			if (startRoom){
				this.txtDisplay.text = "start";
			}
			else if (exitroom){
				this.txtDisplay.text = "exit";
			}
			else{
				this.txtDisplay.text = " ";
			}
			
			xPos = xLoc;
			yPos = yLoc;
			roomHeight = height;
			//trace (height);
			roomWidth = width;
			//POPULATE GRID
			//tilegeneration = new tileGeneration(this,wall,item);
			//removeentity = new removeEntity(this);
			
			
			
			
			switch (entranceDoor){
				case "South":
					northEnabled = true;
					break;
				case "West":
					eastEnabled = true;	
					break;
				case "East":
					westEnabled = true;
					break;
				case "North":
					southEnabled = true;
					break;
			}
			setDoorVisibility();
			
			//shrunk to fit entire map
			
			shrinkmap();
		}
		
		public function shrinkmap(): void{
			this.scaleX =1/gridWidth;//0.04761904761904761904761904761905;//0.09;//0.09 = 11; //0.04761904761904761904761904761905 = 21;
			this.scaleY =1/gridHeight;//0.04761904761904761904761904761905;//0.09; //0.04761904761904761904761904761905;
			this.x = 13 + xPos * (672 / gridWidth);//((roomWidth / gridWidth) - 7);//168;//32;//61.090909090909090909090909090909;// = 11;//32 = 21
			this.y = 13 + yPos * (672 / gridHeight);//61.090909090909090909090909090909;//((roomWidth / gridHeight) - 7);//168;//4x4 = 168 32;//61.090909090909090909090909090909;
		}
		
		public function growmap(): void{
			this.scaleX = 1;
			this.scaleY = 1;
			this.x = 13 + xPos * 672;
			this.y = 13 + yPos * 672;
		}
		
		public function setDoorVisibility(): void{
			if (northEnabled){
				nDoor.visible = true;
			}
			else{
				nDoor.visible = false;
			}
			if (eastEnabled){
				eDoor.visible = true;
			}
			else{
				eDoor.visible = false;
			}
			if (westEnabled){
				wDoor.visible = true;
			}
			else{
				wDoor.visible = false;
			}
			if (southEnabled){
				sDoor.visible = true;
			}
			else{
				sDoor.visible = false;
			}
		}
		
		public function getRoomWidth(): int{
			return roomWidth;
		}
		
		public function getRoomHeight(): int{
			return roomHeight;
		}
		
		public function removeWestDoor(): void{
			westEnabled = false;
			setDoorVisibility();
		}
		public function removeEastDoor(): void{
			eastEnabled = false;
			setDoorVisibility();
		}
		public function removeNorthDoor(): void{
			northEnabled = false;
			setDoorVisibility();
		}
		public function removeSouthDoor(): void{
			southEnabled = false;
			setDoorVisibility();
		}
		
		public function addWestDoor(r:roomContainer): void{
			if (r.getWestDoor()){
				westEnabled = true;
			}
			setDoorVisibility();
		}
		public function addEastDoor(r:roomContainer): void{
			if (r.getEastDoor()){
				eastEnabled = true;
			}
			setDoorVisibility();
		}
		public function addNorthDoor(r:roomContainer): void{
			if (r.getNorthDoor()){
				northEnabled = true;
			}
			setDoorVisibility();
		}
		public function addSouthDoor(r:roomContainer): void{
			if (r.getSouthDoor()){
				southEnabled = true;
			}
			setDoorVisibility();
		}
		
		public function getWestDoor():Boolean{
			return westEnabled;
		}
		
		public function getEastDoor():Boolean{
			return eastEnabled;
		}
		
		public function getSouthDoor():Boolean{
			return southEnabled;
		}
		
		public function getNorthDoor():Boolean{
			return northEnabled;
		}
		/*
		public function debugRoom(){
			trace("This Room Is ("+xPos+","+yPos+"). Room Variation #"+chosenRoom+". Walls In Array:" + getArray().length);
			trace("North = " + northEnabled + " East = " + eastEnabled + " West = " + westEnabled + " South = " + southEnabled);
		}
		*/
		
	}
	
}
