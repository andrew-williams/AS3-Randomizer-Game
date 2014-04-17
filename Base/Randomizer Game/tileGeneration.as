package 
{
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class tileGeneration
	{
		//definitions
		private var ed:entityDefinitions;
		
		private var sParent:Sprite;
		private var addentity:addEntity;
		private var item:itemContainer;
		private var enemy:enemyContainer;
		private var projectile:projectileContainer;
		private var pushblock:pushContainer;
		private var time:Timer = null;
		private var enemyArray:Array;
		private var timerState:Boolean = false;
		private var allowTimers:Boolean = false;
		private var saveFrequency:int;
		private var wall:wallContainer;
		private var floor:floorContainer;

		public function tileGeneration(parentSprite:Sprite,wallobject,itemobject,enemyobject,projobject,floorobject,pushobject,ed:entityDefinitions) : void
		{
			pushblock = pushobject;
			floor = floorobject;
			wall = wallobject;
			this.ed = ed;
			item = itemobject;
			enemy = enemyobject;
			projectile = projobject;
			sParent = parentSprite;
			//projectile.setRoom(sParent);
			addentity = new addEntity(sParent);

			// constructor code
		}

		public function generateEntity(objectX,objectY,array,ID:int = 0) : void{
			if ((objectX > 0) && (objectX < 20) && (objectY > 0) && (objectY < 20)){
				if (ID > 1){
					addentity.callFunction(objectX,objectY,ID,item,array,"Item");
				}
				else{
					addentity.callFunction(objectX,objectY,ed.randomizeAllItems(),item,array,"Item");
					//addentity.callFunction(objectX,objectY,ID,item,array,"Item");
				}
			}
			else{
				trace("Error placing object");
			}
		}
		
		public function summonEntity(objectX,objectY,array,wall,ID:int = 0) : void{
			if ((objectX > 0) && (objectX < 20) && (objectY > 0) && (objectY < 20)){
				//if (ID > 1){
					addentity.callFunction(objectX,objectY,ID,enemy,array,"Enemy");
				//}
			}
			else{
				trace("Error placing object");
			}
		}

		public function generateBorders(array) : void{
			addentity.callFunction(0,0,ed.WALL_WHITE_BLOCK_H9,wall,array,"Wall");
			addentity.callFunction(12,0,ed.WALL_WHITE_BLOCK_H9,wall,array,"Wall");
			addentity.callFunction(0,20,ed.WALL_WHITE_BLOCK_H9,wall,array,"Wall");
			addentity.callFunction(12,20,ed.WALL_WHITE_BLOCK_H9,wall,array,"Wall");
			addentity.callFunction(0,1,ed.WALL_WHITE_BLOCK_V8,wall,array,"Wall");
			addentity.callFunction(0,12,ed.WALL_WHITE_BLOCK_V8,wall,array,"Wall");
			addentity.callFunction(20,1,ed.WALL_WHITE_BLOCK_V8,wall,array,"Wall");
			addentity.callFunction(20,12,ed.WALL_WHITE_BLOCK_V8,wall,array,"Wall");
		}

		public function generateDoor(array:Array,type:String){
			switch(type){
				case "North":
					addentity.callFunction(9,0,ed.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
					break;
				case "South":
					addentity.callFunction(9,20,ed.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
					break;
				case "East":
					addentity.callFunction(20,9,ed.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
					break;
				case "West":
					addentity.callFunction(0,9,ed.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
					break;
			}
		}
		public function generateRoom(num,array,identifier:String) : void
		{
			switch (num)
			{
				case 1 :// START ROOM
					if (identifier == "Item")
					{
						addentity.callFunction(6,6,ed.randomizeItems(ed.LIST_STARTING_ITEMS),item,array,"Item");
						addentity.callFunction(6,14,ed.randomizeItems(ed.LIST_STARTING_ITEMS),item,array,"Item");
						addentity.callFunction(14,6,ed.randomizeItems(ed.LIST_STARTING_ITEMS),item,array,"Item");
						addentity.callFunction(14,14,ed.randomizeItems(ed.LIST_STARTING_ITEMS),item,array,"Item");
						addentity.callFunction(19,19,ed.ITEM_POWERUP_REGEN,item,array,"Item");
						//addentity.callFunction(1,19,ed.ITEM_POWERUP_RAPID_FIRE,item,array,"Item");
						addentity.callFunction(10,12,ed.ITEM_WEAPON_BLASTER,item,array,"Item");
					}
					else if (identifier == "Enemy"){
						addentity.callFunction(4,4,ed.ENEMY_TEST,enemy,array,"Enemy");
					}
					else if (identifier == "Wall"){
						addentity.callFunction(9,12,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(11,12,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(9,8,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(8,8,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(12,8,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(8,8,ed.FLOOR_START,floor,array,"Floor");
					}
					break;
				case 2: // Exit Room
					if (identifier == "Item")
					{
						
					}
					else if (identifier == "Wall"){
						addentity.callFunction(3,2,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(3,4,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(3,6,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(2,2,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						
						addentity.callFunction(6,2,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(8,2,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(6,5,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(8,5,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(7,4,ed.WALL_RED_BLOCK,wall,array,"Wall");
						
						addentity.callFunction(12,2,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(12,6,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(13,3,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						
						addentity.callFunction(16,2,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(17,3,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
											   
					}
					else if (identifier == "Floor"){
						addentity.callFunction(10,10,ed.FLOOR_EXIT,floor,array,"Floor");
					}
					break;
				case 3: //fighting room
					if (identifier == "Item"){
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
						addentity.callFunction(10,10,ed.ITEM_AMMO_SMALL_CELL,item,array,"Item");
					}
					else if (identifier == "Enemy"){
						enemyArray = array;
						allowTimers = true;
						saveFrequency = 1000;
						//activateSpawner(true);
					}
					break;
				case 4 : // ryus room
					if (identifier == "Item"){
						addentity.callFunction(1,7,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(12,7,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(19,7,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(10,9,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(11,10,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(9,10,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(10,11,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(6,14,ed.ITEM_HEALTH_25,item,array,"Item");
						addentity.callFunction(19,19,ed.ITEM_HEALTH_25,item,array,"Item");
					}
					else if (identifier == "Wall"){
						addentity.callFunction(2,2,ed.WALL_RED_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(11,2,ed.WALL_RED_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(18,3,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(18,8,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(8,3,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(9,4,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(11,3,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(10,4,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(13,4,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(2,4,ed.WALL_RED_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(1,6,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(4,7,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(1,8,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(2,9,ed.WALL_RED_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(2,10,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(6,5,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(11,6,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(11,7,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(8,8,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(16,5,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(8,9,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(8,11,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(1,12,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(11,12,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(12,11,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(12,9,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(15,10,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(15,11,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(17,12,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(19,12,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(2,14,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(3,18,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(12,18,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(4,13,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(5,15,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(8,13,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(8,14,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(7,16,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(11,13,ed.WALL_RED_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(15,14,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(18,15,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(16,17,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(14,18,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(11,14,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(10,15,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(13,15,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(14,16,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(7,4,ed.FLOOR_LAVA_V2,floor,array,"Floor");
						addentity.callFunction(10,6,ed.FLOOR_LAVA_V2,floor,array,"Floor");
						addentity.callFunction(9,7,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(17,5,ed.FLOOR_LAVA_V4,floor,array,"Floor");
						addentity.callFunction(3,7,ed.FLOOR_LAVA_V2,floor,array,"Floor");
						addentity.callFunction(4,8,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(7,9,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(8,10,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(6,10,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(12,10,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(14,12,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(13,10,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(10,12,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(10,14,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(3,16,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(18,12,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(16,19,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(17,18,ed.FLOOR_SLIME_2x2,floor,array,"Floor");
					}
					break;
				case 5 : // riley's room
					if (identifier == "Item"){
						addentity.callFunction(4,16,ed.ITEM_WEAPON_GRENADE_LAUNCHER,item,array,"Item");
						addentity.callFunction(12,11,ed.ITEM_HEALTH_10,item,array,"Item");
					}
					else if (identifier == "Wall"){
						addentity.callFunction(2,3,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(13,4,ed.WALL_RED_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(13,8,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(10,12,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(2,10,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(9,16,ed.WALL_RED_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(18,9,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(16,7,ed.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(16,14,ed.WALL_WHITE_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(14,13,ed.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(10,2,ed.WALL_RED_BLOCK_V6,wall,array,"Wall");
						addentity.callFunction(7,5,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(13,5,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(13,9,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(4,12,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(4,14,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(3,12,ed.WALL_WHITE_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(5,13,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(5,16,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(4,15,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(1,11,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
						addentity.callFunction(10,13,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(14,17,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(17,17,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(11,1,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(8,6,ed.FLOOR_SLIME_2x2,floor,array,"Floor");
						addentity.callFunction(4,5,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(4,7,ed.FLOOR_LAVA_3x3,floor,array,"Floor");
						addentity.callFunction(11,9,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(14,6,ed.FLOOR_LAVA_2x2,floor,array,"Floor");
						addentity.callFunction(11,7,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(14,10,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(19,7,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(13,13,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(15,14,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(16,15,ed.FLOOR_LAVA,floor,array,"Floor");
						addentity.callFunction(17,8,ed.FLOOR_LAVA_H3,floor,array,"Floor");
					}
					break;
				case 6 :// ITEM ROOM = 4
					if (identifier == "Item"){
						addentity.callFunction(1,2,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(2,1,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(2,3,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(3,2,ed.randomizeAllItems(),item,array,"Item");
						
						addentity.callFunction(17,2,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(18,1,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(18,3,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(19,2,ed.randomizeAllItems(),item,array,"Item");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(1,5,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(17,5,ed.FLOOR_LAVA_3x3,floor,array,"Floor");
					}
					else if (identifier == "Wall"){
						addentity.callFunction(4,1,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(4,3,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(16,1,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(16,3,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
						addentity.callFunction(8,1,ed.WALL_WHITE_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(12,1,ed.WALL_WHITE_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(1,4,ed.WALL_WHITE_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(16,4,ed.WALL_WHITE_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(12,8,ed.WALL_WHITE_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(1,8,ed.WALL_WHITE_BLOCK_H8,wall,array,"Wall");
					}
					break;
				case 7 ://room with number 1
					if (identifier == "Floor"){
						addentity.callFunction(8,8,ed.FLOOR_LAVA,floor,array,"Floor");
					}
					else if (identifier == "Wall"){
						addentity.callFunction(10,10,ed.WALL_WHITE_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(9,11,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(9,14,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
					}
					break;
				case 8 ://room with number 2
					if (identifier == "Wall"){
						addentity.callFunction(10,10,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(12,11,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(10,12,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(11,10,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(11,12,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(11,14,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
					}
					break;
				case 9 ://jackys room
					if (identifier == "Floor"){
						addentity.callFunction(11,4,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
						addentity.callFunction(4,10,ed.FLOOR_LAVA_3x3,floor,array,"Floor");
					}
					break;
				case 10 ://slime room
					if (identifier == "Floor"){
						addentity.callFunction(1,1,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
						addentity.callFunction(11,1,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
						addentity.callFunction(1,11,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
						addentity.callFunction(11,11,ed.FLOOR_SLIME_9x9,floor,array,"Floor");
					}
					break;
				case 11 ://leon room
					if (identifier == "Floor"){
						addentity.callFunction(2,2,ed.FLOOR_SLIME_V5,floor,array,"Floor");
						addentity.callFunction(3,6,ed.FLOOR_SLIME_H2,floor,array,"Floor");
						addentity.callFunction(6,2,ed.FLOOR_SLIME_V5,floor,array,"Floor");
						addentity.callFunction(7,2,ed.FLOOR_SLIME_H2,floor,array,"Floor");
						addentity.callFunction(7,4,ed.FLOOR_SLIME_H2,floor,array,"Floor");
						addentity.callFunction(7,6,ed.FLOOR_SLIME_H2,floor,array,"Floor");
						addentity.callFunction(10,2,ed.FLOOR_SLIME_H3,floor,array,"Floor");
						addentity.callFunction(10,6,ed.FLOOR_SLIME_H3,floor,array,"Floor");
						addentity.callFunction(10,3,ed.FLOOR_SLIME_V3,floor,array,"Floor");
						addentity.callFunction(12,3,ed.FLOOR_SLIME_V3,floor,array,"Floor");
						addentity.callFunction(14,2,ed.FLOOR_SLIME_V5,floor,array,"Floor");
						addentity.callFunction(18,2,ed.FLOOR_SLIME_V5,floor,array,"Floor");
						addentity.callFunction(15,3,ed.FLOOR_SLIME,floor,array,"Floor");
						addentity.callFunction(16,4,ed.FLOOR_SLIME,floor,array,"Floor");
						addentity.callFunction(17,5,ed.FLOOR_SLIME,floor,array,"Floor");
					}
					break;
				case 12 ://ricardo room
					if (identifier == "Wall"){
						addentity.callFunction(3,4,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(4,5,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(7,5,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(12,5,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(7,9,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(12,9,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(7,6,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(9,6,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(12,6,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(14,6,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(2,12,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(2,15,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(2,17,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(7,12,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(7,14,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(7,17,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(2,13,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(4,16,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(6,12,ed.WALL_RED_BLOCK_V6,wall,array,"Wall");
						addentity.callFunction(10,12,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(10,17,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(14,12,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(14,17,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(18,13,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(16,13,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(17,15,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(11,14,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(13,16,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(13,14,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(12,15,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(11,16,ed.WALL_RED_BLOCK,wall,array,"Wall");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(9,1,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(1,9,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(17,9,ed.FLOOR_SLIME_3x3,floor,array,"Floor");
						addentity.callFunction(9,15,ed.FLOOR_SLIME_V5,floor,array,"Floor");
						addentity.callFunction(10,19,ed.FLOOR_SLIME_H2,floor,array,"Floor");
						addentity.callFunction(10,4,ed.FLOOR_SLIME_V8,floor,array,"Floor");
						addentity.callFunction(11,4,ed.FLOOR_SLIME_V8,floor,array,"Floor");
						addentity.callFunction(4,10,ed.FLOOR_SLIME_H6,floor,array,"Floor");
						addentity.callFunction(4,11,ed.FLOOR_SLIME_H6,floor,array,"Floor");
						addentity.callFunction(12,10,ed.FLOOR_SLIME_H5,floor,array,"Floor");
						addentity.callFunction(12,11,ed.FLOOR_SLIME_H5,floor,array,"Floor");
					}
					else if (identifier == "Item"){
						addentity.callFunction(1,1,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(1,19,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(19,1,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(19,19,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(8,8,ed.ITEM_WEAPON_PLASMA_CANNON,item,array,"Item");
						addentity.callFunction(13,8,ed.ITEM_MEGA_100_PERCENT,item,array,"Item");
					}
					break;
				case 13 ://vertical test room
					if (identifier == "Wall"){
						addentity.callFunction(2,2,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(4,2,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(6,2,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(8,2,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(10,2,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(12,2,ed.WALL_RED_BLOCK_V6,wall,array,"Wall");
						addentity.callFunction(14,2,ed.WALL_RED_BLOCK_V7,wall,array,"Wall");
						addentity.callFunction(16,2,ed.WALL_RED_BLOCK_V8,wall,array,"Wall");
						addentity.callFunction(18,2,ed.WALL_RED_BLOCK_V9,wall,array,"Wall");
						addentity.callFunction(2,10,ed.WALL_WHITE_BLOCK_V9,wall,array,"Wall");
						addentity.callFunction(4,11,ed.WALL_WHITE_BLOCK_V8,wall,array,"Wall");
						addentity.callFunction(6,12,ed.WALL_WHITE_BLOCK_V7,wall,array,"Wall");
						addentity.callFunction(8,13,ed.WALL_WHITE_BLOCK_V6,wall,array,"Wall");
						addentity.callFunction(10,14,ed.WALL_WHITE_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(12,15,ed.WALL_WHITE_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(14,16,ed.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(16,17,ed.WALL_WHITE_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(18,18,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
					}
					break;
				case 14 ://horizontal test room
					if (identifier == "Wall"){
						addentity.callFunction(2,2,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(2,4,ed.WALL_RED_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(2,6,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(2,8,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(2,10,ed.WALL_RED_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(2,12,ed.WALL_RED_BLOCK_H6,wall,array,"Wall");
						addentity.callFunction(2,14,ed.WALL_RED_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(2,16,ed.WALL_RED_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(2,18,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(10,2,ed.WALL_WHITE_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(11,4,ed.WALL_WHITE_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(12,6,ed.WALL_WHITE_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(13,8,ed.WALL_WHITE_BLOCK_H6,wall,array,"Wall");
						addentity.callFunction(14,10,ed.WALL_WHITE_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(15,12,ed.WALL_WHITE_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(16,14,ed.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(17,16,ed.WALL_WHITE_BLOCK_H2,wall,array,"Wall");
						addentity.callFunction(18,18,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
					}
					break;
				case 15: //liquids room
					if (identifier == "Wall"){
						addentity.callFunction(14,2,ed.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(15,2,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
					}
					break;
				case 16 ://empty room leave blank
					break;
				case 17 ://push puzzle room
					if (identifier == "Wall"){
						addentity.callFunction(3,1,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(17,1,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(2,2,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(6,2,ed.WALL_RED_BLOCK_H9,wall,array,"Wall");
						addentity.callFunction(16,2,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(13,5,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(14,3,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(14,6,ed.WALL_RED_BLOCK_H4,wall,array,"Wall");
						addentity.callFunction(17,7,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(17,10,ed.WALL_RED_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(12,12,ed.WALL_RED_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(12,13,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(6,16,ed.WALL_RED_BLOCK_H7,wall,array,"Wall");
						addentity.callFunction(6,5,ed.WALL_RED_BLOCK_H5,wall,array,"Wall");
						addentity.callFunction(5,6,ed.WALL_RED_BLOCK_V4,wall,array,"Wall");
						addentity.callFunction(5,11,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(4,14,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(5,18,ed.WALL_RED_BLOCK_H8,wall,array,"Wall");
						addentity.callFunction(3,16,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(6,15,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(2,4,ed.WALL_RED_BLOCK_V3,wall,array,"Wall");
						addentity.callFunction(3,7,ed.WALL_RED_BLOCK_V5,wall,array,"Wall");
						addentity.callFunction(1,12,ed.WALL_RED_BLOCK_H3,wall,array,"Wall");
						addentity.callFunction(1,9,ed.WALL_RED_BLOCK,wall,array,"Wall");
						addentity.callFunction(11,6,ed.WALL_WHITE_BLOCK_V2,wall,array,"Wall");
						addentity.callFunction(12,7,ed.WALL_WHITE_BLOCK,wall,array,"Wall");
					}
					else if (identifier == "Floor"){
						addentity.callFunction(13,16,ed.FLOOR_WATER_4x4,floor,array,"Floor");
						addentity.callFunction(17,16,ed.FLOOR_WATER_H3,floor,array,"Floor");
						addentity.callFunction(13,15,ed.FLOOR_WATER_H7,floor,array,"Floor");
						addentity.callFunction(13,13,ed.FLOOR_WATER_H7,floor,array,"Floor");
						addentity.callFunction(13,14,ed.FLOOR_WATER_H7,floor,array,"Floor");
						addentity.callFunction(12,19,ed.FLOOR_PUSH_LEFT,floor,array,"Floor");
						addentity.callFunction(5,10,ed.FLOOR_PUSH_LEFT,floor,array,"Floor");
						addentity.callFunction(17,9,ed.FLOOR_PUSH_RIGHT,floor,array,"Floor");
						addentity.callFunction(19,12,ed.FLOOR_PUSH_UP,floor,array,"Floor");
					}
					else if (identifier == "Item"){
						addentity.callFunction(19,19,ed.ITEM_WEAPON_RAILGUN,item,array,"Item");
						addentity.callFunction(18,19,ed.ITEM_AMMO_SMALL_SLUG,item,array,"Item");
						addentity.callFunction(19,18,ed.ITEM_AMMO_SMALL_SLUG,item,array,"Item");
						addentity.callFunction(2,1,ed.randomizeAllItems(),item,array,"Item");
						addentity.callFunction(18,1,ed.randomizeAllItems(),item,array,"Item");
					}
					else if (identifier == "Push"){
						addentity.callFunction(7,1,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(9,12,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(1,6,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(6,6,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(9,7,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(9,8,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(12,8,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(13,8,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(14,8,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(6,9,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(13,9,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(13,10,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(8,11,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(12,11,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(13,11,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(9,13,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(8,14,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(8,15,ed.PUSH_BLUEBLOCK,pushblock,array,"Push");
						addentity.callFunction(4,3,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(18,6,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(7,7,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(15,8,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(9,9,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(10,11,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(6,12,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(10,14,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						addentity.callFunction(1,16,ed.PUSH_BLUEBLOCK_2X2,pushblock,array,"Push");
						
						
					}
					break;
			}
		}
/*
		public function disableDoor(identifier:String,wall, array)
		{
			switch (identifier)
			{
				case "North" :
					addentity.callFunction(9,0,t.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
					break;
				case "East" :
					addentity.callFunction(20,9,t.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
					break;
				case "West" :
					addentity.callFunction(0,9,t.WALL_WHITE_BLOCK_V3,wall,array,"Wall");
					break;
				case "South" :
					addentity.callFunction(9,20,t.WALL_WHITE_BLOCK_H3,wall,array,"Wall");
					break;
			}
		}
		*/
		private function timerFunction(f:TimerEvent) : void{
			//trace (enemyArray.length);
			if (enemyArray.length < 50){
				addentity.callFunction(1,1,ed.ENEMY_TEST,enemy,enemyArray,"Enemy");
				addentity.callFunction(1,19,ed.ENEMY_TEST,enemy,enemyArray,"Enemy");
				addentity.callFunction(19,1,ed.ENEMY_TEST,enemy,enemyArray,"Enemy");
				addentity.callFunction(19,19,ed.ENEMY_TEST,enemy,enemyArray,"Enemy");
			}
		}

		public function activateSpawner(active:Boolean) : void{
			
			if (active){
				//trace("Allow Timers:" + allowTimers);
				if ((time == null) && (allowTimers)){
					
					timerState = true;
					time = new Timer(saveFrequency,0);
					time.addEventListener(TimerEvent.TIMER,timerFunction);
					time.start();
				}
			}
			else{
				if (time != null){
					timerState = false;
					time.removeEventListener(TimerEvent.TIMER,timerFunction);
					time = null;
				}
			}
		}
		
		public function getTimerState() : Boolean{
			return timerState;
		}

	}

}