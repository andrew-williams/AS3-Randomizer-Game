package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.TimerEvent;

	public class Game extends Screen
	{
		////////
		private var musichandler:musicHandler;
		//////
		private var enableShop:Boolean = false;
		private var upgradescreen:upgradeScreen;
		//definitions
		private var ed:entityDefinitions;
		//
		private var minimapSprite:Sprite; // minimap layer
		private var playerbase:playerBase;
		private var Crosshair:crosshair;
		private var hud:Hud;
		private var roomArray:Array;
		private var minimapArray:Array;
		private var minimapscreen:minimapScreen;
		private var mapHeight:int = 11;
		private var mapWidth:int = 11;
		private var startX:int;
		private var startY:int;
		private var pLocX:int;
		private var pLocY:int;
		private var endGame:Boolean = false;
		private var consoleEnabled:Boolean = false;
		private var cmd:consoleCommands;
		private var console:Console;
		public var player:Player;
		private var movemap:moveMap;
		private var angleplayer:anglePlayer;
		private var consoleDisplayTimer:int = 0;
		private var level:int =0;
		
		public function setConsoleDisplayTimer(val:int): void{
			if (val > 0){hud.txtDisplay.visible = true;hud.txtDisplay.txtLastInput.text = console.getLastOutput();consoleDisplayTimer = val;}
		}
		//gets
		
		public function getCurrentRoomArray(): roomContainer{return roomArray[pLocX][pLocY];}
		
		public function Game(): void{
			
		}
		public function onReturn(e:MouseEvent): void{
			hud.btnBack.removeEventListener(MouseEvent.CLICK,onReturn);
			endgame();
		}
		private function loadNewObjects(): void{
			//definitions
			musichandler = new musicHandler(musicHandler.LEVEL1);
			//////
			ed = new entityDefinitions();
			angleplayer = new anglePlayer();
			hud = new Hud();
			hud.txtDisplay.txtLastInput.text = " ";
			console = new Console();
			cmd = new consoleCommands(this,console,ed);
			playerbase = new playerBase();
			Crosshair = new crosshair();
			minimapSprite = new Sprite();
			minimapscreen = new minimapScreen();
			roomArray = new Array();
			minimapArray = new Array();
			player = new Player(cmd,ed);
			upgradescreen = new upgradeScreen(player,cmd);
		}
		private function removeObjects(): void{
			musichandler.stopMusic();
			musichandler = null;
			this.removeChild(upgradescreen);
			for (var i:int = 0; i < mapWidth; i++){
				for (var j:int = 0; j < mapHeight; j++){
					if (roomArray[i][j] != null){
						roomArray[i][j].exit();
					}
				}
			}
			angleplayer = null;
			roomArray[pLocX][pLocY].removeChild(player);
			player = null;
			this.removeChild(Crosshair);
			Crosshair = null;
			hud.removeChild(console);
			console = null;
			cmd = null;
			
			minimapSprite.removeChild(minimapscreen);
			minimapscreen = null;
			this.removeChild(minimapSprite);
			minimapSprite = null;
			this.removeChild(hud);
			hud = null;
			this.removeChild(playerbase);
			playerbase = null;
			var null2d:null2dArray = new null2dArray();
			roomArray = null2d.callFunction(roomArray,false,mapWidth,mapHeight);
			roomArray = null;
			minimapArray = null2d.callFunction(minimapArray,false,mapWidth,mapHeight);
			minimapArray = null;
			null2d = null;
			ed = null;
		}
		public function endgame(): void{
			endGame = true;
			removeObjects();
			dispatchEvent(new Event(Screen.END));
		}
		private function addNewObjects(): void{
			console.x = 12;
			console.y = 12;
			console.visible = false;
			hud.addChild(console);
			minimapSprite.addChild(minimapscreen);
			this.addChild(playerbase);
			minimapSprite.visible = false;
			this.addChild(minimapSprite);
			
			this.addChild(hud);
			this.addChild(Crosshair);
		}
		private function initializeObjects(): void{
			hud.healthIcon.gotoAndStop(6);
			hud.armorIcon.gotoAndStop(5);
			hud.btnBack.addEventListener(MouseEvent.CLICK,onReturn,false,0,true);
			var null2d:null2dArray = new null2dArray();
			roomArray = null2d.callFunction(roomArray,true,mapWidth,mapHeight);
			minimapArray = null2d.callFunction(minimapArray,true,mapWidth,mapHeight);
			null2d = null;
			startX = Math.floor(Math.random() * mapWidth);
			startY = Math.floor(Math.random() * mapHeight);
			pLocX = startX;
			pLocY = startY;
			
		}
		public function newGame(): void
		{
			loadNewObjects();
			addNewObjects();
			initializeObjects();
			loadNewLevel();
		}
		public function loadNewLevel(): void{
			level ++;
			var i:int = 0;
			var j:int = 0;
			hud.txtMessages.text = "";
			var null2d:null2dArray = new null2dArray();
			// initialize minimap array to null
			minimapArray = null2d.callFunction(minimapArray,false,mapWidth,mapHeight);
			roomArray = null2d.callFunction(roomArray,false,mapWidth,mapHeight);
			startX = Math.floor(Math.random() * mapWidth);
			startY = Math.floor(Math.random() * mapHeight);
			pLocX = startX;
			pLocY = startY;
			addRoom(startX,startY,"None",true);
			//NOW THAT THE DOORS ARE ADDED, UNLINK THE STUPID DOORS
			replaceRoomWithExit();
			//now that all rooms are available, populate.
			for (i = 0; i < mapWidth; i++){
				for (j = 0; j < mapHeight; j++){
					if (roomArray[i][j] != null){
						roomArray[i][j].populateGrid();
					}
				}
			}
			var cleandoors:cleanDoors = new cleanDoors(roomArray,mapWidth,mapHeight);
			var cleanmap:cleanDoors = new cleanDoors(minimapArray,mapWidth,mapHeight);
			for (i = 0; i < mapWidth; i++){
				for (j = 0; j < mapHeight; j++){
					if (roomArray[i][j] != null){
						roomArray[i][j].putWallOnDisabledDoor();
					}
				}
			}
			
			roomArray[startX][startY].addChild(player);
			player.setCurrentRoom(roomArray[startX][startY]);
			movemap = new moveMap(startX,startY);
			movemap.callFunction("Start", roomArray, mapWidth,mapHeight);
			roomArray[startX][startY].visible = true;
			
			for (i = 0; i < mapHeight; i++)
			{
				for (j = 0; j < mapWidth; j++)
				{
					if (minimapArray[i][j] != null){
						minimapSprite.addChild(minimapArray[i][j]);
					}
				}
			}
			minimapSprite.visible = false;
			this.addChild(playerbase);
			this.addChild(Crosshair);
			this.addChild(minimapSprite);
			this.addChild(upgradescreen);
			cmd.passConsoleMessage("\n\n\n");
			cmd.passConsoleMessage("\n----------------------------------------");
			cmd.passConsoleMessage("\n            LEVEL : " + level);
			cmd.passConsoleMessage("\n----------------------------------------");
		
		}
		private function replaceRoomWithExit(): void{
			var randX:int = Math.floor(Math.random() * mapWidth);
			var randY:int = Math.floor(Math.random() * mapHeight);
				if (roomArray[randX][randY] != null){
						if ((randX == startX) && (randY == startY)){
							replaceRoomWithExit();
						}
						else{
							removeChild(roomArray[randX][randY]);
							minimapArray[randX][randY] = null;
							roomArray[randX][randY] = null;
							addRoom(randX,randY,"None",false,true);
						}
				}
				else{
					replaceRoomWithExit();
				}
		}
		private function updateHud(): void
		{
			hud.txtWeapon.text = String(player.getCurrentWeapon());
			hud.txtAmmo.text = String(player.getCurrentAmmo("Value"));
			hud.txtHealth.text = String(player.getHealth());
			hud.txtArmor.text = String(player.getArmor());
			if (player.getArmorType() == 0)
			{
				hud.armorIcon.gotoAndStop(5);
			}
			else
			{
				hud.armorIcon.gotoAndStop(player.getArmorType());
			}
			hud.ammoIcon.gotoAndStop(player.getCurrentAmmo("Frame"));
			this.addChild(hud);
		}
		
		public function revealminimap(): void{
			for (var i:int = 0; i < mapHeight; i++){
				
				for (var j:int = 0; j < mapWidth; j++)
				{
					if (minimapArray[i][j] != null){
						minimapArray[i][j].visible = true;
					}
					
				}
			}
		}
		private function addRoom(randX:int, randY:int, identifier:String = "None",startroom:Boolean = false, exitroom:Boolean = false): void
		{
			if (roomArray[randX][randY] == null)
			{
				roomArray[randX][randY] = new roomContainer(ed,randX,randY,identifier,startroom,exitroom);
				minimapArray[randX][randY] = new minimapContainer(randX,randY,identifier,startroom,exitroom);
				this.addChild(roomArray[randX][randY]);
				
				//DETERMINE IF ANY DOORS
				
					if (randY != 0)
					{
						roomArray[randX][randY].addNorthDoor();
						minimapArray[randX][randY].addNorthDoor(roomArray[randX][randY]);
					}
					if (randX != (mapWidth - 1))
					{
						roomArray[randX][randY].addEastDoor();
						minimapArray[randX][randY].addEastDoor(roomArray[randX][randY]);
					}
					if (randX != 0)
					{
						roomArray[randX][randY].addWestDoor();
						minimapArray[randX][randY].addWestDoor(roomArray[randX][randY]);
					}
					if (randY != (mapHeight - 1))
					{
						roomArray[randX][randY].addSouthDoor();
						minimapArray[randX][randY].addSouthDoor(roomArray[randX][randY]);
					}
				
				//Add rooms based on doors;
				if (!exitroom){
					if ((roomArray[randX][randY].getWestDoor()) && (randX != 0))
					{
						addRoom(randX - 1,randY,"West");
					}
					if ((roomArray[randX][randY].getEastDoor()) && (randX != (mapWidth - 1)))
					{
						addRoom(randX + 1,randY,"East");
					}
					if ((roomArray[randX][randY].getSouthDoor()) && (randY != (mapWidth - 1)))
					{
						addRoom(randX,randY + 1,"South");
					}
					if ((roomArray[randX][randY].getNorthDoor()) && (randY != 0))
					{
						addRoom(randX,randY - 1,"North");
					}
				}
				
			}
		}
		private function checkDoorCollision(): void
		{
			if ((player.hitTestObject(roomArray[pLocX][pLocY].sDoor)) && (roomArray[pLocX][pLocY].sDoor.visible == true))
			{
				roomArray[pLocX][pLocY].stopEnemyUpdate();
				roomArray[pLocX][pLocY].visible = false;
				minimapArray[pLocX][pLocY].playerLoc.visible = false;
				roomArray[pLocX][pLocY].removeChild(player);
				pLocY++;
				player.setCurrentRoom(roomArray[pLocX][pLocY]);
				player.y = 20;
				roomArray[pLocX][pLocY].addChild(player);
				roomArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].playerLoc.visible = true;
				movemap.callFunction("South", roomArray, mapWidth,mapHeight);
				roomArray[pLocX][pLocY].resetPushBlocks();//this resets all push blocks to original location in room
				roomArray[pLocX][pLocY].startEnemyUpdate();
			}

			if ((player.hitTestObject(roomArray[pLocX][pLocY].nDoor)) && (roomArray[pLocX][pLocY].nDoor.visible == true))
			{
				roomArray[pLocX][pLocY].stopEnemyUpdate();
				roomArray[pLocX][pLocY].visible = false;
				minimapArray[pLocX][pLocY].playerLoc.visible = false;
				roomArray[pLocX][pLocY].removeChild(player);
				pLocY--;
				player.setCurrentRoom(roomArray[pLocX][pLocY]);
				player.y = roomArray[pLocX][pLocY].getRoomHeight() - 20;
				roomArray[pLocX][pLocY].addChild(player);
				roomArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].playerLoc.visible = true;
				movemap.callFunction("North", roomArray, mapWidth,mapHeight);
				roomArray[pLocX][pLocY].resetPushBlocks();//this resets all push blocks to original location in room
				roomArray[pLocX][pLocY].startEnemyUpdate();
			}

			//check door
			if ((player.hitTestObject(roomArray[pLocX][pLocY].wDoor)) && (roomArray[pLocX][pLocY].wDoor.visible == true))
			{
				roomArray[pLocX][pLocY].stopEnemyUpdate();
				roomArray[pLocX][pLocY].visible = false;
				minimapArray[pLocX][pLocY].playerLoc.visible = false;
				roomArray[pLocX][pLocY].removeChild(player);
				pLocX--;
				player.setCurrentRoom(roomArray[pLocX][pLocY]);
				player.x = roomArray[pLocX][pLocY].getRoomWidth() - 20;
				roomArray[pLocX][pLocY].addChild(player);
				roomArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].playerLoc.visible = true;
				movemap.callFunction("West", roomArray, mapWidth,mapHeight);
				roomArray[pLocX][pLocY].resetPushBlocks();//this resets all push blocks to original location in room
				roomArray[pLocX][pLocY].startEnemyUpdate();
			}

			//check door
			if ((player.hitTestObject(roomArray[pLocX][pLocY].eDoor)) && (roomArray[pLocX][pLocY].eDoor.visible == true))
			{
				roomArray[pLocX][pLocY].stopEnemyUpdate();
				roomArray[pLocX][pLocY].visible = false;
				minimapArray[pLocX][pLocY].playerLoc.visible = false;
				roomArray[pLocX][pLocY].removeChild(player);
				pLocX++;
				player.setCurrentRoom(roomArray[pLocX][pLocY]);
				player.x = 20;
				roomArray[pLocX][pLocY].addChild(player);
				roomArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].visible = true;
				minimapArray[pLocX][pLocY].playerLoc.visible = true;
				movemap.callFunction("East", roomArray, mapWidth,mapHeight);
				roomArray[pLocX][pLocY].resetPushBlocks();//this resets all push blocks to original location in room
				roomArray[pLocX][pLocY].startEnemyUpdate();
			}
		}
		private function clearmap(): void{
			var i:int = 0;
			var j:int = 0;
			for (i = 0; i < mapWidth; i++){
				for (j = 0; j < mapHeight; j++){
					if (minimapArray[i][j] != null){
						minimapSprite.removeChild(minimapArray[i][j]);
					}
				}
			}
			roomArray[pLocX][pLocY].removeChild(player);
			for (i = 0; i < mapWidth; i++){
				for (j = 0; j < mapHeight; j++){
					if (roomArray[i][j] != null){
						roomArray[i][j].exit();
						this.removeChild(roomArray[i][j]);
					}
				}
			}
		}
		
		private function loadShop(): void{
			consoleEnabled = false;
			console.visible = false;
			enableShop = true;
			upgradescreen.visible = true;
			upgradescreen.addListeners();
		}
		////////////////////////////////
		//	 OVERRIDES
		////////////////////////////////

		override public function tick(e:TimerEvent): void{
			if (consoleDisplayTimer > 0){
				consoleDisplayTimer--;
			}
			else{
				hud.txtDisplay.txtLastInput.text = " ";
				hud.txtDisplay.visible = false;
			}
			player.tick(e);
		}
		override public function update(e:Event): void{
			if (player.checkEndGame()){
				
				if (!enableShop){
					loadShop();
				}
				else{
					upgradescreen.update(e);
					if (upgradescreen.getShopFinished()){
						enableShop = false;
						upgradescreen.resetShop();
						upgradescreen.visible = false;
						player.setEndGame(false);
						clearmap();
						loadNewLevel();
					}
				}
			}
			else{
				roomArray[pLocX][pLocY].setplayer(player);
			
				roomArray[pLocX][pLocY].update(e);
				player.update(e);
				playerbase.x = player.x + 12;
				playerbase.y = player.y + 12;
				updateHud();
				checkDoorCollision();	
				angleplayer.callFunction(Crosshair.x,Crosshair.y,playerbase.x,playerbase.y,player,playerbase,Crosshair);
			}
			
		}
		
		override public function mouse_move(e:MouseEvent): void
		{
			if (!endGame){
				Crosshair.x = e.stageX;
				Crosshair.y = e.stageY;
			}
		}
		
		override public function key_up(k:KeyboardEvent): void
		{
			if (!consoleEnabled){
				switch (k.keyCode)
				{
				case Keyboard.A :
					player.setKeyPress("Left",false);
					break;
				case Keyboard.W :
					player.setKeyPress("Up",false);
					break;
				case Keyboard.D :
					player.setKeyPress("Right",false);
					break;
				case Keyboard.S :
					player.setKeyPress("Down",false);
					break;
				case Keyboard.NUMBER_1 :
					player.changeWeapon(1);
					break;
				case Keyboard.NUMBER_2 :
					player.changeWeapon(2);
					break;
				case Keyboard.NUMBER_3 :
					player.changeWeapon(3);
					break;
				case Keyboard.NUMBER_4 :
					player.changeWeapon(4);
					break;
				case Keyboard.NUMBER_5 :
					player.changeWeapon(5);
					break;
				case Keyboard.NUMBER_6 :
					player.changeWeapon(6);
					break;
				case Keyboard.NUMBER_7 :
					player.changeWeapon(7);
					break;
				case Keyboard.NUMBER_8 :
					player.changeWeapon(8);
					break;
				case Keyboard.NUMBER_9 :
					player.changeWeapon(9);
					break;
				case Keyboard.NUMBER_0 :
					player.changeWeapon(0);
					break;
				case Keyboard.Q:
					minimapSprite.visible = false;
					break;
				}
			}
		}
		override public function mouse_down(e:MouseEvent): void{
			player.setKeyPress("Left Click",true);
		}
		override public function mouse_up(e:MouseEvent): void{
			player.setKeyPress("Left Click",false);
		}	
		override public function key_down(k:KeyboardEvent): void
		{
			if (!endGame){
				if (!consoleEnabled){
					switch (k.keyCode)
					{
						case 192:
							if (!player.checkEndGame()){
								player.setKeyPress("Left",false);
								player.setKeyPress("Down",false);
								player.setKeyPress("Up",false);
								player.setKeyPress("Right",false);
								consoleEnabled = true;
								console.inputTXT.text = "";
								console.visible = true;
								stage.focus = console.inputTXT;
							}
							break;
						case Keyboard.A :
							player.setKeyPress("Left",true);
							break;
						case Keyboard.W :
							player.setKeyPress("Up",true);
							break;
						case Keyboard.D :
							player.setKeyPress("Right",true);
							break;
						case Keyboard.S :
							player.setKeyPress("Down",true);
							break;
						case Keyboard.Q :
							if (!player.checkEndGame()){
								hud.txtDisplay.visible = false;
								minimapSprite.visible = true;
							}
							break;
					}
				}
				else{
					switch (k.keyCode){
						case 192:
							consoleEnabled = false;
							console.visible = false;
							break;
						case Keyboard.UP:
							console.getLastInputCommand();
							break;
						case Keyboard.ENTER:
							console.setInput();
							if(!endGame){cmd.msg(console.getLastInput(),console.getLastAttribute(),console.getLastAttribute2(),console.getLastAttribute3());}
							cmd.doCmd(console.getLastInput(),console.getLastAttribute(),console.getLastAttribute2(),console.getLastAttribute3());
							break;
					}
				}
			}
		}
	}
}