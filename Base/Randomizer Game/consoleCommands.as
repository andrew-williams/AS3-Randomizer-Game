package  {
	
	import flash.system.System;
	
	public class consoleCommands {

		public var COMMANDS:String = "commands";
		public var GIVE:String = "give";
		public var GOD:String = "god";
		public var NOCLIP:String = "noclip";
		public var QUIT:String = "quit";
		public var RATEOFFIRE:String = "rateoffire";
		public var REVEALMINIMAP:String = "revealminimap";
		public var SPAWN:String = "spawn";
		public var SPEED:String = "speed";
		public var SUMMON:String = "summon";
		public var TRACE:String = "trace";
		public var RESET_PUSH:String = "resetpush";
		public var MEM:String = "mem";
		public var ENDLEVEL:String = "endlevel";
		public var TELEPORT:String = "xteleto";
		
		public var console:Console;
		public var stageParent;
		
		private var ed:entityDefinitions;
		
		public function consoleCommands(sparent, consoleObject,ed:entityDefinitions): void {
			// constructor code
			this.ed = ed;
			stageParent = sparent;
			console = consoleObject;
		}

		public function msg(command:String = "null", attribute:String = "null", attribute2:String = "null", attribute3:String = "null"): void{
			var output:String = "";
			var a:int = 0;
			var timer:int = 3;
			switch (command){
				case COMMANDS:
					switch (attribute){
						case COMMANDS:
						output = "\ncommands: Display available commands and command information";
						break;
						case ENDLEVEL:
						output = "\nendlevel: Ends current level";
						break;
						case GIVE:
						output = "\ngive x y: Gives object x with amount y\ngive all: Gives everything";
						break;
						case GOD:
						output = "\ngod: Toggles Invincibility";
						break;
						case MEM:
						output = "\nmem: Displays current memory usage (Accurate only when standalone)";
						break;
						case NOCLIP:
						output = "\nnoclip: Toggles the ability to walk through walls";
						break;
						case QUIT:
						output = "\nquit: Ends game and returns to main menu";
						break;
						case RATEOFFIRE:
						output = "\nrateoffire x: Changes rate of fire for current weapon where x is between 10 and 2000";
						break;
						case RESET_PUSH:
						output = "\nresetpush: Resets all push blocks to its original location in the current room.";
						break;
						case SPAWN:
						output = "\nspawn z x y: Spawns object z at x and y positions\nspawn list: Displays all available objects to spawn";
						break;
						case SPEED:
						output = "\nspeed x: Changes player movement speed where x is between 1 and 100. Default: 8";
						break;
						case SUMMON:
						output = "\nsummon z x y: Summons object z at x and y positions\nsummon list: Displays all available objects to summon";
						break;
						default:
						output = "\ncommands command to get additional information\ncommands\nendlevel\ngive\ngod\nmem\nrateoffire\nresetpush\nnoclip\nquit\nrevealminimap\nspawn\nspeed\nsummon";
						break;
					}
					break;
				case GIVE:
					if (attribute == "all"){output = "\nGiving Everything";}
					break;
				case GOD:
					if (stageParent.player.getGodmode()){output = "\nGod Mode Off";}
					else{output = "\nGod Mode On";}
					break;
				case MEM:
					var tempmem = System.totalMemory/1024/1024;
					output = "\nMemory Usage: "+ tempmem + " Mb";
					break;
				case NOCLIP:
					if (stageParent.player.getNoclip()){output = "\nNoclip Off";}
					else{output = "\nNoclip On";}
					break;
				case RATEOFFIRE:
					output = "\nRate Of Fire = " + stageParent.player.getAttackSpeed();
					break;
				case RESET_PUSH:
					output = "\nResetting All Push Blocks";
					break;
				case REVEALMINIMAP:
					output = "\nRevealing Minimap";
					break;
				case SPAWN:
					if (attribute == "list"){
						output = "\nDisplaying Spawn List\n---------------------";
						for (a = 0; a < ed.getItemNameArray().length; a++){
							output += "\n"+ed.getItemNameArray()[a];
						}
						output += "\nA total of "+a+" objects found in the database";
					}
					output += "\nUsage: spawn object x y";
					break;
				case SPEED:
					output = "\nSpeed = '" + stageParent.player.getMovementSpeed() + "' Default = '8'";
					break;
				case SUMMON:
					if (attribute == "list"){
						output = "\nDisplaying Summon List\n---------------------";
						for (a = 0; a < ed.getEnemyNameArray().length; a++){
							output += "\n"+ed.getEnemyNameArray()[a];
						}
						output += "\nA total of "+a+" objects found in the database";
					}
					output += "\nUsage: summon object x y";
					break;
				case TRACE: //DEBUG ONLY
					if (attribute != null){
						output += "\nTracing: " + attribute;
						trace("Tracing: " + attribute);
						timer = 0;
					}
					else{
						output += "\nUsage: trace message";
					}
					break;
				default:
					//output += console.returnLastInputCommand();
					timer = 0;
					break;
			}
			console.setMessage(output,timer);
		}

		public function passConsoleMessage(output:String,timer:int = 0): void{
			console.setMessage(output,timer);
		}

		public function doCmd(command:String = "null", attribute1:String = "null", attribute2:String = "null", attribute3:String = "null"): void{
			var tempNum1:Number = Number(attribute1);
			var tempNum2:Number = Number(attribute2);
			var tempNum3:Number = Number(attribute3);
			var a:int = 0;
			switch (command){
				case TELEPORT:
					stageParent.player.x = tempNum1 * 32 + 16;
					stageParent.player.y = tempNum2 * 32 + 16;
					break;
				case ENDLEVEL:
				case GIVE:
				case GOD:
				case NOCLIP:
				case RATEOFFIRE:
				case SPEED:
					stageParent.player.checkConsoleInput(command,attribute1,attribute2,attribute3);
					break;
				case QUIT:
					stageParent.endgame();
					break;
				case REVEALMINIMAP:
					stageParent.revealminimap();
					break;
				case SPAWN:
					if (attribute1 != "list"){
						for (a = 0; a < ed.getItemNameArray().length; a++){
							if (ed.getItemNameArray()[a] == attribute1){
								console.setMessage("\nSpawning '" + attribute1 + "' At (" + tempNum2 + "," + tempNum3 + ")");
								stageParent.getCurrentRoomArray().addItemObject(tempNum2,tempNum3,a + 1);
								break;
							}
						}
					}
					break;
					
				case SUMMON:
					if (attribute1 != "list"){
						for (a = 0; a < ed.getEnemyNameArray().length; a++){
							if (ed.getEnemyNameArray()[a] == attribute1){
								stageParent.getCurrentRoomArray().addEnemyObject(tempNum2,tempNum3,a + 1);
								break;
							}
						}
					}
					break;
					
				case RESET_PUSH:
					stageParent.getCurrentRoomArray().resetPushBlocks();
					break;
			}
		}
	}
}
