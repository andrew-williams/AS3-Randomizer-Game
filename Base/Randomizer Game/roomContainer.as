package  {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class roomContainer extends MovieClip{
		private var ed:entityDefinitions;
		private static const startroomID:int = 1;
		private var roomArray:Array;
		private var roomVariation:int = 15;//Different variations of rooms avaiable = TOTAL CASE IN TILE GEN - 2. 1 = start room, 2 = test blank room.
		
		private var westEnabled:Boolean = false;
		private var eastEnabled:Boolean = false;
		private var northEnabled:Boolean = false;
		private var southEnabled:Boolean = false;
		private var xPos:int = -1;
		private var yPos:int = -1;
		private var maxDoors:int = 4;
		private var chosenRoom:int; //Chosen variation
		
		private var roomWidthStart:int = 0;
		private var roomHeightStart:int = 0;
		private var roomWidth:int;
		private var roomHeight:int;
		
		private static const doorFrequency:int = 2; //lower number = higher chance of door
		private static const gridWidth:int = 10;
		private static const gridHeight:int = 10;
		private var itemArray:Array = new Array(); //THIS HOLDS ALL THE ITEM ENTITIES
		private var item:itemContainer;
		private var enemyArray:Array = new Array(); // THIS HOLDS ALL THE ENEMY ENTITIES
		private var enemy:enemyContainer;
		private var wallArray:Array = new Array(); // THIS HOLDS ALL THE WALL ENTITIES, NOT THE FLOOR...
		private var wall:wallContainer;
		private var projectileArray:Array = new Array(); // THIS HOLDS ALL THE BULLETS from player
		private var projectile:projectileContainer;
		private var floorArray:Array = new Array();
		private var floor:floorContainer;
		private var pushArray:Array = new Array();
		private var pushblock:pushContainer;
		private	var startRoom:Boolean = false;
		private var exitroom:Boolean = false;
		private var removeentity:removeEntity;
		private var tilegeneration:tileGeneration;
		private var addentity:addEntity = new addEntity(this);
		
		private var playerholder;
		//gets
		public function getWallArray():Array{return wallArray;}
		public function getFloorArray():Array{return floorArray;}
		public function getPushArray():Array{return pushArray;}
		public function exit(): void{
			var i:int = 0;
			for (i = 0; i < enemyArray.length; i++){
				this.removeChild(enemyArray[i]);
				enemyArray[i] = null;
			}
			enemyArray = null;
			for (i = 0; i < wallArray.length; i++){
				this.removeChild(wallArray[i]);
				wallArray[i] = null;
			}
			wallArray = null;
			for (i = 0; i < itemArray.length; i++){
				this.removeChild(itemArray[i]);
				itemArray[i] = null;
			}
			itemArray = null;
			for (i = 0; i < projectileArray.length; i++){
				projectileArray[i].exit();
				this.removeChild(projectileArray[i]);
				projectileArray[i] = null;
			}
			projectileArray = null;
			for (i = 0; i < floorArray.length; i++){
				this.removeChild(floorArray[i]);
				floorArray[i] = null;
			}
			floorArray = null;
			for (i = 0; i < pushArray.length; i++){
				this.removeChild(pushArray[i]);
				pushArray[i] = null;
			}
			pushArray = null;
			
		}
		public function resetPushBlocks(): void{
			for (var i:int = 0; i < pushArray.length; i++){
				pushArray[i].resetBlock();
			}
		}
		/*
		
		private function initializeRoomID(){
			
			roomArray = r.getArray();
		}
		*/
		public function setplayer(playerObj): void{
			playerholder = playerObj;
		}
		/*
		public function debugMe(){
			trace("Projectiles: " + projectileArray.length);
		}
		
		*/
		
		public function update(e:Event): void{
			
			//trace(projectileArray.length);
			
			if (playerholder != null){
				for (var i:int = 0; i < enemyArray.length; i++){
					if (enemyArray[i] != null){
						enemyArray[i].setTarget("X",playerholder.x);
						enemyArray[i].setTarget("Y",playerholder.y);
						//enemyArray[i].setTarget("Enemy Array",enemyArray);
						if (enemyArray[i].getState() == "Idle"){
							enemyArray[i].idleState(e);
						}
						else if (enemyArray[i].getState() == "Seek"){
							enemyArray[i].seekState(e);
						}
						else if (enemyArray[i].getState() == "Shot"){
							enemyArray[i].shotState(e);
						}
						
					}
				}
			}

			checkEnemyCollision(projectileArray,enemyArray);
			checkCollision(projectileArray,"Projectile");
		}

		public function stopEnemyUpdate(): void{
			tilegeneration.activateSpawner(false);
		}
		public function startEnemyUpdate(): void{
			tilegeneration.activateSpawner(true);
		}
	

		public function checkEnemyCollision(array,target): void{
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < target.length;i++){
				for (j = 0; j < array.length; j++){
					if (target[i] != undefined){
						if ((array[j].hitTestObject(target[i])) && (array[j].currentFrame != 8) && (array[j].currentFrame != 7))
						{
							switch (array[j].currentFrame){
								case 2: // blaster shot
									target[i].modifyHealth(-20);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
								case 3: // plasma rifle
									target[i].modifyHealth(-20);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
								case 6: // ROCKET LAUNCHER
									target[i].modifyHealth(-120);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
								case 5: //plasma cannon
									target[i].modifyHealth(-100);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
								case 9: //fist
									target[i].modifyHealth(-2);
									target[i].checkPlayer("Shot");
									break;
								case 10: //combat knife
									target[i].modifyHealth(-6);
									target[i].checkPlayer("Shot");
									break;
								case 11: //shotgun pellet
									target[i].modifyHealth(-10);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
								default:
									target[i].modifyHealth(-5);
									target[i].checkPlayer("Shot");
									array[j].exit();
									break;
							}
						
							if (target[i].getHealth() <= 0){
								target[i].x = 9999;
								deleteEntity(target[i],target);
							}
						//deleteEntity(array[j],array);
						}
						else if (array[j].currentFrame == 8){
							for (var k:int = 0; k < array[j].getChildAt(0).numChildren; k++){
								if (target[i].hitTestObject(array[j].getChildAt(0).getChildAt(k))){
									target[i].modifyHealth(-9999);
								}
								
								//trace(array[j].getChildAt(0).getChildAt(k));
							}
							if (target[i].getHealth() <= 0){
								target[i].x = 9999;
								deleteEntity(target[i],target);
							}
							//target[i].modifyHealth(-9999);
								
						}
						
					}
				}
				
			}
		}
	
		public function checkCollision(array,identifier:String): void{
			var j:int = 0;
			var i:int = 0;
			if (identifier == "Projectile")
			{		
				for (i = 0; i < array.length; i++)
				{
					if (array[i].currentFrame == 7){
						if (array[i].getEndAnim("Railgun") == 1) {
							//trace("Boom");
							deleteEntity(array[i],array);
						}
					}
					else
					{
						if (array[i].isdead())
						{
							deleteEntity(array[i],array);
						}
						
					}
				}
			}
		}
		
		public function addEnemyObject(objectX,objectY,ID:int = 0): void{
				tilegeneration.summonEntity(objectX,objectY,enemyArray,wallArray,ID);
		}
		
		public function addItemObject(objectX,objectY,ID:int = 0): void{
				tilegeneration.generateEntity(objectX,objectY,itemArray,ID);
		}
		
		public function shootProjectile(xValue,yValue,destX,destY,projectiletype:String): void{
			var frame:int;
			switch (projectiletype){
				case "TEST":
					frame = 1;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.BLASTER:
					frame = 2;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.PLASMA_RIFLE:
					frame = 3;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.MACHINEGUN:
					frame = 4;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.PLASMA_CANNON:
					frame = 5;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.ROCKET_LAUNCHER:
					frame = 6;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.RAILGUN:
					addentity.createProjectile(xValue,yValue,8,projectileContainer,projectileArray,destX,destY); // rail anim
					frame = 7;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.FIST:
					frame = 9;
					addentity.createProjectile(((Math.floor(Math.random() * 24)) - 12) + xValue,((Math.floor(Math.random() * 24)) - 12) + yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.COMBAT_KNIFE:
					frame = 10;
					addentity.createProjectile(((Math.floor(Math.random() * 24)) - 12) + xValue,((Math.floor(Math.random() * 24)) - 12) + yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.SHOTGUN:
					frame = 11;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
				case ed.CHAINGUN:
					frame = 12;
					addentity.createProjectile(xValue,yValue,frame,projectileContainer,projectileArray,destX,destY);
					break;
			}
		}
		public function getItemArray():Array{
			return itemArray;
		}
		
		public function deleteEntity(object,array): void{
			removeentity.callFunction(object,array);
		}
		
		public function populateGrid(): void{
			//wallArray = new Array();
			tilegeneration = new tileGeneration(this,wall,item,enemy,projectile,floor,pushblock,ed);
			tilegeneration.generateBorders(wallArray);
			if (startRoom){
				tilegeneration.generateRoom(startroomID,floorArray,"Floor");
				tilegeneration.generateRoom(startroomID,wallArray,"Wall");
				tilegeneration.generateRoom(startroomID,itemArray,"Item");
				tilegeneration.generateRoom(startroomID,pushArray,"Push");
				tilegeneration.generateRoom(startroomID,enemyArray,"Enemy");
			}
			else if (exitroom){
				tilegeneration.generateRoom(ed.R_EXIT,floorArray,"Floor");
				tilegeneration.generateRoom(ed.R_EXIT,wallArray,"Wall");
				tilegeneration.generateRoom(ed.R_EXIT,itemArray,"Item");
				tilegeneration.generateRoom(ed.R_EXIT,pushArray,"Push");
				tilegeneration.generateRoom(2,enemyArray,"Enemy");
			}
			else{
				tilegeneration.generateRoom(chosenRoom,floorArray,"Floor");
				tilegeneration.generateRoom(chosenRoom,wallArray,"Wall");
				tilegeneration.generateRoom(chosenRoom,itemArray,"Item");
				tilegeneration.generateRoom(chosenRoom,pushArray,"Push");
				tilegeneration.generateRoom(chosenRoom,enemyArray,"Enemy");
			}

		}
		
		public function roomContainer(ed:entityDefinitions,xLoc:int, yLoc:int, entranceDoor:String = "None",startRoom:Boolean = false, exitroom:Boolean = false) : void{
			this.ed = ed;
			// constructor code
			this.visible = false;
			this.startRoom = startRoom;
			this.exitroom = exitroom;
			xPos = xLoc;
			yPos = yLoc;
			roomHeight = height;
			roomWidth = width;
			chosenRoom = Math.ceil(Math.random() * roomVariation + 2);
			//POPULATE GRID
			//trace("X: "+player.x+" Y: " + player.y);
			removeentity = new removeEntity(this);
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
			
			//shrinkmap();
			
			//full size
			growmap();
			
			//randomRoom();
			//addRandomDoors();
			//debugRoom();
						
		}
		
		public function shrinkmap(): void{
			this.scaleX =0.09;//0.09 = 11; //0.04761904761904761904761904761905 = 21;
			this.scaleY =0.09; //0.04761904761904761904761904761905;
			this.x = 13 + xPos * 61.090909090909090909090909090909;// = 11;//32 = 21
			this.y = 13 + yPos * 61.090909090909090909090909090909;
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
		
		public function putWallOnDisabledDoor(): void{
			if (!northEnabled){
				tilegeneration.generateDoor(wallArray,"North");
			}
			if (!southEnabled){
				tilegeneration.generateDoor(wallArray,"South");
			}
			if (!eastEnabled){
				tilegeneration.generateDoor(wallArray,"East");
			}
			if (!westEnabled){
				tilegeneration.generateDoor(wallArray,"West");
			}
		}
		
		public function getRoomWidth():int{
			return roomWidth;
		}
		
		public function getRoomHeight():int{
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
		/*
		private function randomRoom(){
			//initializeRoomID();
			//this.gotoAndStop(chosenRoom);
			if (startRoom){
				this.gotoAndStop(startroomID);
			}
			else if (exitroom){
				this.gotoAndStop(ed.R_EXIT);
			}
			else{
				var temp = Math.floor(Math.random() * roomArray.length);
				chosenRoom = roomArray[temp];
				this.gotoAndStop(chosenRoom);
			}
		}
		*/
		public function addWestDoor(): void{
			var truefalse:int = 0;
			if (xPos != 0){
				truefalse = Math.floor(Math.random() * doorFrequency);
				if (exitroom){
					truefalse = 1;
				}
				if (truefalse == 1){
					westEnabled = true;
				}
			}
			setDoorVisibility();
		}
		public function addEastDoor(): void{
			var truefalse:int = 0;
			if (xPos != gridWidth){
				truefalse = Math.floor(Math.random() * doorFrequency);
				if (exitroom){
					truefalse = 1;
				}
				if (truefalse == 1){
					eastEnabled = true;
				}
				
			}
			setDoorVisibility();
		}
		public function addNorthDoor(): void{
			var truefalse:int = 0;
			if (yPos != 0){
				if (!startRoom){
					truefalse = Math.floor(Math.random() * doorFrequency);
				}
				else{
					truefalse = 1;
				}
				if (exitroom){
					truefalse = 1;
				}
				if (truefalse == 1){
					northEnabled = true;
				}
			}
			setDoorVisibility();
		}
		public function addSouthDoor(): void{
			var truefalse:int = 0;
			if (yPos != gridHeight){
				if (!startRoom){
					truefalse = Math.floor(Math.random() * doorFrequency);
				}
				else{
					truefalse = 1;
				}
				if (exitroom){
					truefalse = 1;
				}
				if (truefalse == 1){//1
					southEnabled = true;
				}
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
		
	}
	
}
