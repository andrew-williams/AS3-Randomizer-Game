package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Player extends MovieClip
	{
		//LEVELABLE STATS AND SUCH
		private var skillPoints:int = 0;
		private var cash:int = 0;
		private var healthUpgradeLevel:int = 0;
		private var armorUpgradeLevel:int = 0;
		
		private var skill_str:int = 0; //increases damage to range weapons, increases max ammo, reduces damage taken from non-magic
		private var skill_dex:int = 0; //increases damage to melee weapons, increases max armor, increases dodge chance
		private var skill_int:int = 0; //increases damage to magic weapons, increases max mana,reduces damage taken from magic
		private var skill_vit:int = 0; //increases max health, increases health regeneration
		
		private var dodge_percentage:int = 0; //percent in which the player can dodge an attack. has a cap of % to prevent OP DODGING LIKE JAX SO OP
		//POWERUPS
		//Rune (Held until removed)
		private var p_regen:Boolean = false;
		//Powerup (Held for a time limit)
		private var p_rapidfire:Boolean = false;
		private var p_rapidfire_counter:int = 0;
		//player stats
		private var attackSpeed:Number = 0;
		private var movementSpeed:Number = 8;
		private var health:int = 100;
		private var maxhealth:int = 200;
		//player modifiers
		private var godmode:Boolean = false;
		private var noclip:Boolean = false;
		//Inherited variables
		private var cmd:consoleCommands;
		private var ed:entityDefinitions;
		
		private var armor:int = 0;
		private var armortype:int = 0;
		private var GREEN_ARMOR_MAX:int = 100;//armor type 1   25%
		private var YELLOW_ARMOR_MAX:int = 250;// armor type 2 50%
		private var RED_ARMOR_MAX:int = 1000;// armor type 3   80%
		private var TITAN_ARMOR_MAX:int = 2500;// armor type 4 100%
		private var maxarmor:int;
		//
		private var previousX:int;
		private var previousY:int;
		private var crosshairX:int;
		private var crosshairY:int;
		private var currentRoom:roomContainer;
		//Movement
		private var moveLeft:Boolean = false;
		private var moveRight:Boolean = false;
		private var moveUp:Boolean = false;
		private var moveDown:Boolean = false;
		//shooting
		private var shooting:Boolean = false;
		private var ammoType:Array = new Array("None","Shells","Bullets","Rockets","Cells","Slugs","Explosives");
		//Ammunition List:
		//(NONE,SHELLS,BULLETS,ROCKETS,CELLS,SLUGS,EXPLOSIVES);
		public var ammoCount:Array = new Array(null,0,0,0,0,0,0);
		private var currentWeapon:String;
		private var currentAmmo:String = "None";

		private var ammo:assignAmmo;
		//weapons
		private var weaponAvailable:Array;
		private var weaponSlot:Array;
		private var weaponSlotAvailable:Array;
		private var maxSlots:int; // max weapons  in a slot
		private var maxWeaponSlot:int;
		private var bulletTime:Timer;
		//weapon selection
		private var weaponchanger:weaponChanger;
		
		private var endgame:Boolean = false;
		private var dead:Boolean = false;
		//gets
		public function getArmor(){return armor;}
		public function getArmorType(){return armortype;}
		public function getArmorUpgradeLevel(){return armorUpgradeLevel;}
		public function getAttackSpeed(){return attackSpeed;}
		public function getCash(){return cash;}
		public function getCurrentWeapon(){return currentWeapon;}
		public function getGodmode(){return godmode;}
		public function getHealth(){return health;}
		public function getHealthUpgradeLevel(){return healthUpgradeLevel;}
		public function getMaxArmor(){return maxarmor;}
		public function getMaxHealth(){return maxhealth;}
		public function getMovementSpeed(){return movementSpeed;}
		public function getNoclip(){return noclip;};
		public function getSkillPoints(){return skillPoints;}
		//sets
		public function addHealthUpgradeLevel():void{skillPoints--;healthUpgradeLevel += 1;setMaxHealth();}
		public function addArmorUpgradeLevel():void{skillPoints--;armorUpgradeLevel += 1;setArmorType(armortype);}		
		public function setCurrentRoom(room){currentRoom = room;}
		
		private function powerupAction(id:String){
			switch (id){
				case "Regen":
					if (p_regen){
						if ((health < 100) && ((armor == 0)||(armor >= 100))){health += 10;if (health > 100){health = 100;}}
						else if ((health < 100) && (armor > 0) && (armor < 100)){
							health += 5;
							armor += 5;
							if (health > 100){health = 100;}
							if (armor > 100){armor = 100;}
						}
						else if ((health >= 100) && (armor < 100) && (armor > 0)){
							armor += 10;
							if (armor > 100){armor = 100;}
						}
					}
				break;
				case "Rapid Fire":
					if(p_rapidfire){
						if ((p_rapidfire_counter > 0) && (p_rapidfire_counter != 3)){
							p_rapidfire_counter --;
						}
						else if (p_rapidfire_counter == 3){
							p_rapidfire_counter --;
							cmd.passConsoleMessage("\nRapid Fire Is Wearing Out...",3);
						}
						else if (p_rapidfire_counter >= 0){
							cmd.passConsoleMessage("\nRapid Fire Has Worn Out...",3);
							p_rapidfire = false;
							p_rapidfire_counter = 0;
							adjustASpeed(currentWeapon);
						}
					}
			}
		}
		public function tick(e:TimerEvent){
			if (!endgame){
				powerupAction("Regen");
				powerupAction("Rapid Fire");
			}
		}
		public function Player(cmd:consoleCommands,ed:entityDefinitions)
		{
			trace("Player Created");
			this.cmd = cmd;
			this.ed = ed;
			ammo = new assignAmmo(ed);
			this.x = 336;
			this.y = 336;
			var weaponInitializer:initializeWeaponSlotData = new initializeWeaponSlotData(ed);
			weaponAvailable = weaponInitializer.initializeWeaponsAvailable();
			weaponSlot = weaponInitializer.initializeWeaponsInSlots();
			maxSlots = weaponInitializer.getSlotLimit();
			maxWeaponSlot = weaponInitializer.getMaxWeaponSlots();
			weaponSlotAvailable = weaponInitializer.initializeWeaponSlotsAvailable();
			weaponInitializer = null;
			currentWeapon = weaponSlot[1][0];
			maxarmor = armortype;
			attackSpeed = 250;//start fist aspeed
			weaponchanger = new weaponChanger(maxSlots);
			bulletTime = new Timer(attackSpeed,0);
			bulletTime.addEventListener(TimerEvent.TIMER,bulletTimer);
			bulletTime.start();
		}
		
		public function checkConsoleInput(msg:String, attribute:String = "null",attribute2:String = "null",attribute3:String = "null")
		{
			var returnInput:String = "";
			var a:int = 0;
			var b:int = 0;
			var tempNum:Number = Number(attribute);
			if (msg == cmd.GOD){if (godmode){godmode = false;}else{godmode = true;}}
			else if (msg == cmd.NOCLIP){if (noclip){noclip = false;}else{noclip = true;}}
			else if (msg == cmd.SPEED){if ((tempNum > 0) && (tempNum <= 100)){movementSpeed = tempNum;}}
			else if (msg == cmd.ENDLEVEL){
				this.x = 336;
				this.y = 336;
				endgame = true;
				//disabling rapidfire
				p_rapidfire = false;
				p_rapidfire_counter = 0;
				adjustASpeed(currentWeapon);
				cmd.passConsoleMessage("\nLevel Ended");
				cmd.passConsoleMessage("\nYou Gain 5 Skill Points To Spend",3);
				skillPoints += 5;
			}
			else if (msg == cmd.GIVE)
			{
				
				if (attribute == "all")
				{ //GIVE ALL
					for (a = 1; a < ammoCount.length; a++){ammoCount[a] = 99999;}//Give 99999 Ammo
					for (a = 0; a < weaponSlotAvailable.length; a++){weaponSlotAvailable[a] = 1;}//Enable all weapon slots
					for (a = 0; a < maxWeaponSlot; a++){for (b = 0; b < maxSlots;b++){if (weaponSlot[a][b] != ed.NONE){weaponAvailable[a][b] = 1;}}}//Give all weapons
					p_rapidfire = true;
					p_rapidfire_counter = 30;
					healthUpgradeLevel = 9999;
					setMaxHealth();
					armorUpgradeLevel = 9999;
					health = maxhealth;//Give 99999 health
					setArmorType(4);//Give best armor
					armor = maxarmor;//Give 99999 armor
				}
			}
			
			else if (msg == cmd.RATEOFFIRE){if ((tempNum >= 10) && (tempNum <= 2000)){adjustASpeed("Custom",1,tempNum);}}
			else{
				// Error Handler
				cmd.passConsoleMessage("\nPlayer.as: Error Detected in function: 'checkConsoleInput'\nPlayer.as: Undefined command '"+msg+"' sent to player.",0);
			}
		}
		
		public function update(e:Event)
		{
			if (p_rapidfire){
				if (currentWeapon != ed.CHAINGUN){
					adjustASpeed("Maxed",1,10);
				}
				//adjustASpeed(currentWeapon,0.5); // fix this to work with 2x speed
			}
			if (!dead){

			speedRecovery();
			previousX = this.x;
			previousY = this.y;
			if (moveLeft)
			{
				this.x -= movementSpeed;
				if (!noclip)
				{
					checkWallCollision("EW");
					checkPushBlockCollision("W");
				}
				borderCollision();
			}
			if (moveRight)
			{
				this.x += movementSpeed;
				if (!noclip)
				{
					checkWallCollision("EW");
					checkPushBlockCollision("E");
				}
				borderCollision();
			}
			if (moveDown)
			{
				this.y += movementSpeed;
				if (!noclip)
				{
					checkWallCollision("NS");
					checkPushBlockCollision("S");
				}
				borderCollision();

			}
			if (moveUp)
			{
				this.y -= movementSpeed;
				if (!noclip)
				{
					checkWallCollision("NS");
					checkPushBlockCollision("N");
				}
				borderCollision();
			}
			if (!noclip){checkFloorCollision();}
			checkItemCollision(currentRoom.getItemArray());
			}
			else{
				shooting = false;
				movementSpeed = 0;

			}
		}
		private function speedRecovery(){
			if (movementSpeed < 8){
				movementSpeed++;
			}
		}
		public function setKeyPress(selectedKey:String, keyState:Boolean)
		{
			switch (selectedKey)
			{
				case "Left" :
					moveLeft = keyState;
					break;
				case "Right" :
					moveRight = keyState;
					break;
				case "Up" :
					moveUp = keyState;
					break;
				case "Down" :
					moveDown = keyState;
					break;
				case "Left Click" :
					shooting = keyState;
					break;
			}
		}
		private function borderCollision()
		{
			if (this.x < 0)
			{
				x = 10;
			}
			else if (this.x > 680)
			{
				x = 670;
			}
			if (this.y < 0)
			{
				y = 10;
			}
			else if (this.y > 680)
			{
				y = 670;
			}
		}
		private function checkItemCollision(array)
		{
			for (var i:Number = 0; i < array.length; i++)
			{
				if (array[i].hitTestObject(this))
				{
					pickupItem(array[i].currentFrame);
					currentRoom.deleteEntity(array[i],array);
				}
			}
		}
		private function checkPushBlockCollision(directional:String){
			var pushArray:Array = currentRoom.getPushArray();
			for (var b:int = 0; b < pushArray.length; b++){
				if (this.hitTestObject(pushArray[b])){
					pushArray[b].setTouch(directional);
					if (directional == "N")
						{
							y = previousY;
						}
						else if (directional == "E")
						{
							x = previousX;
						}
						else if (directional == "W")
						{
							x = previousX;
						}
						else if (directional == "S")
						{
							y = previousY;
						}
					
				}
			}
		}
		private function checkWallCollision(directional:String)
		{
			var b:Number = 0;
			var c:Number = 0;
			var wallArray:Array = currentRoom.getWallArray();
			for (b = 0; b < wallArray.length; b++)
			{

				for (c = 0; c < wallArray[b].walls.collision.numChildren; c++)
				{
					if (this.hitTestObject(wallArray[b].walls.collision.getChildAt(c)))
					{
						if (directional == "NS")
						{
							y = previousY;
						}
						else if (directional == "EW")
						{
							x = previousX;
						}
					}
				}
			}
		}
		public function doDamage(id:String = "None")
		{
			if (! godmode)
			{
				var damage:int;
				switch (id)
				{
					case "slime" ://slime
						if (armortype != 0)
						{
							armor--;
						}
						else
						{
							health--;
						}
						break;
					case "lava" :
						if (armortype != 0)
						{
							armor -=  1;
							health -=  1;
						}
						else
						{
							health -=  2;
						}
						break;
				}
				if (armor <= 0)
				{
					armortype = 0;
					armor = 0;
				}
				if (health <= 0)
				{
					health = 0;
					armor = 0;
					killPlayer();
				}
			}
		}
		private function setMaxHealth(){maxhealth = 200 + (25 * (healthUpgradeLevel));}
		private function floorCollisionAction(floors){
			if (this.hitTestObject(floors)){
				switch(floors.name){
					case "slime":
					movementSpeed = 1;
					doDamage("slime");
					break;
					case("lava"):
					movementSpeed = 2;
					doDamage("lava");
					break;
					case("water"):
					movementSpeed = 3;
					break;
					case "exit":
					endgame = true;
					//disabling rapidfire
					p_rapidfire = false;
					p_rapidfire_counter = 0;
					adjustASpeed(currentWeapon);
					cmd.passConsoleMessage("\nLevel Ended");
					cmd.passConsoleMessage("\nYou Gain 5 Skill Points To Spend",3);
					skillPoints += 5;
					//trace("END");
					break;
					case "push_up":
					this.y -= movementSpeed;checkWallCollision("NS");checkPushBlockCollision("N");
					break;
					case "push_down":
					this.y += movementSpeed;checkWallCollision("NS");checkPushBlockCollision("S");
					break;
					case "push_left":
					this.x -= movementSpeed;checkWallCollision("EW");checkPushBlockCollision("W");
					break;
					case "push_right":
					this.x += movementSpeed;checkWallCollision("EW");checkPushBlockCollision("E");
					break;
				}
			}
		}
		private function checkFloorCollision()
		{
			var b:Number = 0;
			var floorArray:Array = currentRoom.getFloorArray();
			for (b = 0; b < floorArray.length; b++)
			{
				floorCollisionAction(floorArray[b].getChildAt(0));
			}
		}
		public function killPlayer()
		{
			dead = true;
			this.x = -9999;
			this.y = -9999;
			
		}
		public function setEndGame(varValue:Boolean)
		{
			endgame = varValue;

		}

		public function checkEndGame()
		{
			return endgame;
		}
		
		/////////////////////////////
		//temp
		public function getCurrentAmmo(type:String = "Value")
		{
			if (type == "Value")
			{
				var aType:String = ammo.getAmmoSlot(currentWeapon,ammoCount);
				return aType;
			}
			else if (type == "Frame")
			{
				var frameNum:int = ammo.getAmmoFrame(currentWeapon);
				return frameNum;
			}

		}

		public function setCrosshair(cx,cy)
		{
			crosshairX = cx;
			crosshairY = cy;
		}
		
		public function changeWeapon(slot:int)
		{
			if (weaponSlotAvailable[slot]){
				currentWeapon = weaponchanger.changeWeapon(slot,weaponAvailable,weaponSlot);
				adjustASpeed(currentWeapon);
				currentAmmo = ammo.getAmmo(currentWeapon,ammoType);
			}
		}
		private function pickupItem(itemID)
		{//itemID = itemcontainer frame #
			var output:String = "";
			var timer:int = 3;
			switch (itemID)
			{
				case 2 :
					output = "\nYou Found A Stimpack +1";
					health +=  1;
					break;
				case 3 :
					output = "\nYou Found A Stimpack +2";
					health +=  2;
					break;
				case 4 :
					output = "\nYou Found A Health Pack +5";
					health +=  5;
					break;
				case 5 :
					output = "\nYou Found A Health Pack +10";
					health +=  10;
					break;
				case 6 :
					output = "\nYou Found A Medikit +25";
					health +=  25;
					break;
				case 7 :
					output = "\nYou Found A Medikit +50";
					health +=  50;
					break;
				case 8 :
					output = "\nYou Found A Megahealth +100";
					health +=  100;
					break;
				case 9 :
					output = "\nYou Found A Megahealth +150";
					health +=  150;
					break;
				case 10 :
					output = "\nYou Found A Megahealth +200";
					health +=  200;
					break;
				case 11 :
					output = "\nYou Found A Megahealth +500";
					health +=  500;
					break;
				case 12 :
					output = "\nYou Found A Health Stim 5%";
					health +=  (maxhealth * 0.05);
					break;
				case 13 :
					output = "\nYou Found A Health Stim 10%";
					health +=  (maxhealth * 0.1);
					break;
				case 14 :
					output = "\nYou Found A Health Stim 25%";
					health +=  (maxhealth * 0.25);
					break;
				case 15 :
					output = "\nYou Found An Adrenaline Boost";
					health +=  maxhealth;
					break;
				case 16 :
					output = "\nYou Found An Armor Shard +1";
					setArmorType(1);
					armor +=  1 / armortype;
					break;
				case 17 :
					output = "\nYou Found An Armor Shard +5";
					setArmorType(1);
					armor +=  5 / armortype;
					break;
				case 18 :
					output = "\nYou Found A Green Armor +25";
					setArmorType(1);
					armor +=  25 / armortype;
					break;
				case 19 :
					output = "\nYou Found A Yellow Armor +25";
					setArmorType(2);
					armor +=  25 / (armortype / 2);
					break;
				case 20 :
					output = "\nYou Found A Yellow Armor +50";
					setArmorType(2);
					armor +=  50 / (armortype / 2);
					break;
				case 21 :
					output = "\nYou Found A Yellow Armor +75";
					setArmorType(2);
					armor +=  75 / (armortype / 2);
					break;
				case 22 :
					output = "\nYou Found A Yellow Armor +100";
					setArmorType(2);
					armor +=  100 / (armortype / 2);
					break;
				case 23 :
					output = "\nYou Found A Red Armor +100";
					setArmorType(3);
					armor +=  100 / (armortype / 3);
					break;
				case 24 :
					output = "\nYou Found A Red Armor +150";
					setArmorType(3);
					armor +=  150 / (armortype / 3);
					break;
				case 25 :
					output = "\nYou Found A Red Armor +200";
					setArmorType(3);
					armor +=  200 / (armortype / 3);
					break;
				case 26 :
					output = "\nYou Found A Red Armor +250";
					setArmorType(3);
					armor +=  250 / (armortype / 3);
					break;
				case 27 :
					output = "\nYou Found A Titan Armor +250";
					setArmorType(4);
					armor +=  250 / (armortype / 4);
					break;
				case 28 :
					output = "\nYou Found A Titan Armor +500";
					setArmorType(4);
					armor +=  500 / (armortype / 4);
					break;
				case 29 :
					output = "\nYou Found A Heavy Titan Armor 100%";
					setArmorType(4);
					armor +=  maxarmor;
					break;
				case 30 :
					output = "\nYou Found A Mega Health/Armor Pack +100";
					setArmorType(4);
					armor +=  100 / (armortype / 4);
					health +=  100;
					break;
				case 31 :
					output = "\nYou Found A Mega Health/Armor Pack +500";
					setArmorType(4);
					armor +=  500 / (armortype / 4);
					health +=  500;
					break;
				case 32 :
					output = "\nYou Found A Mega Health/Armor Stim 50%";
					setArmorType(4);
					armor +=  (maxarmor / 2);
					health +=  (maxhealth / 2);
					break;
				case 33 :
					output = "\nYou Found A Mega Health/Armor Stim 100%";
					setArmorType(4);
					armor +=  maxarmor;
					health +=  maxhealth;
					break;
					//Ammunition List: ammoCount
					//(NONE,SHELLS,BULLETS,ROCKETS,CELLS,SLUGS,EXPLOSIVES);
				case 34 :
					output = "\nYou Found A Small Bullet Box";
					ammoCount[2] +=  30;
					break;
				case 35 :
					output = "\nYou Found A Small Shell Box";
					ammoCount[1] +=  4;
					break;
				case 36 :
					output = "\nYou Found A Rocket";
					ammoCount[3] +=  1;
					break;
				case 37 :
					output = "\nYou Found A Small Slug Box";
					ammoCount[5] +=  4;
					break;
				case 38 :
					output = "\nYou Found A Small Cell Battery";
					ammoCount[4] +=  30;
					break;
				case 39 :
					output = "\nYou Found An Explosive Pack";
					ammoCount[6] +=  1;
					break;
				case 40 ://blaster
					output = "\nYou Found A Blaster";
					weaponAvailable[1][1] = 1;
					weaponSlotAvailable[1] = 1;
					break;
				case 41 ://gl
					output = "\nYou Found A Grenade Launcher";
					weaponAvailable[4][1] = 1;
					weaponSlotAvailable[4] = 1;
					ammoCount[6] +=  5;
					break;
				case 42 ://mg
					output = "\nYou Found A Machinegun";
					weaponAvailable[3][0] = 1;
					weaponSlotAvailable[3] = 1;
					ammoCount[2] +=  50;
					break;
				case 43 ://plasma cannon
					output = "\nYou Found A Plasma Cannon";
					weaponAvailable[0][0] = 1;
					weaponSlotAvailable[0] = 1;
					ammoCount[4] +=  50;
					break;
				case 44 ://plasma rifle
					output = "\nYou Found A Plasms Rifle";
					weaponAvailable[5][0] = 1;
					weaponSlotAvailable[5] = 1;
					ammoCount[4] +=  50;
					break;
				case 45 ://rl
					output = "\nYou Found A Rocket Launcher";
					weaponAvailable[4][0] = 1;
					weaponSlotAvailable[4] = 1;
					ammoCount[3] +=  5;
					break;
				case 46 ://sg
					output = "\nYou Found A Shotgun";
					weaponAvailable[2][0] = 1;
					weaponSlotAvailable[2] = 1;
					ammoCount[1] +=  12;
					break;
				case 47 ://sniper
					output = "\nYou Found A Sniper Rifle";
					weaponAvailable[6][0] = 1;
					weaponSlotAvailable[6] = 1;
					ammoCount[5] +=  4;
					break;
				case ed.ITEM_WEAPON_RAILGUN:
					output = "\nYou Found A Railgun";
					weaponAvailable[9][0] = 1;
					weaponSlotAvailable[9] = 1;
					ammoCount[5] += 3;
					break;
				case ed.ITEM_WEAPON_COMBAT_KNIFE:
					output = "\nYou Found A Combat Knife";
					weaponAvailable[1][2] = 1;
					weaponSlotAvailable[1] = 1;
					break;
				case ed.ITEM_POWERUP_REGEN:
					output = "\nYou Found The Regen Rune";
					p_regen = true;
					break;
				case ed.ITEM_POWERUP_RAPID_FIRE:
					output = "\nYou Found The Rapid Fire Powerup";
					p_rapidfire = true;
					p_rapidfire_counter = 30;
					break;
				case ed.ITEM_WEAPON_CHAINGUN:
					output = "\nYou Found A Chaingun";
					weaponAvailable[3][1] = 1;
					weaponSlotAvailable[3] = 1;
					ammoCount[2] += 100;
					break;
				default :
					// Error Handler
					cmd.passConsoleMessage("\nPlayer.as: Error Detected in function: 'pickupItem'\nPlayer.as: You picked up an item with ID:"+itemID+" which is currently undefined.",0);
					break;
			}
			cmd.passConsoleMessage(output,timer);
			checkMaxVitals();
		}
		public function adjustASpeed(weapon:String = "null",modifier:Number = 1,num:int = 1000)
		{
			if ((weapon == ed.BLASTER) || (weapon == ed.COMBAT_KNIFE)){
				attackSpeed = 500 * modifier;
			}
			else if ((weapon == ed.PLASMA_RIFLE) || (weapon == ed.MACHINEGUN)){
				attackSpeed = 125 * modifier;
			}
			else if ((weapon == ed.PLASMA_CANNON) || (weapon == ed.FIST)){
				attackSpeed = 250 * modifier;
			}
			else if (weapon == ed.CHAINGUN){
				attackSpeed = 1 * modifier; 
			}
			else{
				attackSpeed = num * modifier;
				
			}
			bulletTime.removeEventListener(TimerEvent.TIMER,bulletTimer);
			bulletTime = new Timer(attackSpeed,0);
			bulletTime.addEventListener(TimerEvent.TIMER,bulletTimer);
			bulletTime.start();
			
		}
		private function setArmorType(armorvalue)
		{
			if (armorvalue >= armortype)
			{
				armortype = armorvalue;
				switch (armortype)
				{
					case 1 :
						maxarmor = GREEN_ARMOR_MAX + (25 * armorUpgradeLevel);
						break;
					case 2 :
						maxarmor = YELLOW_ARMOR_MAX + (25 * armorUpgradeLevel);
						break;
					case 3 :
						maxarmor = RED_ARMOR_MAX + (25 * armorUpgradeLevel);
						break;
					case 4 :
						maxarmor = TITAN_ARMOR_MAX + (25 * armorUpgradeLevel);
						break;
				}
			}
		}
		private function checkMaxVitals()
		{
			if (health > maxhealth)
			{
				health = maxhealth;
			}
			if (armor > maxarmor)
			{
				armor = maxarmor;
			}
		}
//Ammunition List:
		//(NONE,SHELLS,BULLETS,ROCKETS,CELLS,SLUGS,EXPLOSIVES);
		public function bulletTimer(e:TimerEvent)
		{
			if (shooting)
			{
				switch (currentWeapon)
				{
					case ed.COMBAT_KNIFE:
						currentAmmo = ammoType[0];//none
						currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						break;
					case ed.FIST:
						currentAmmo = ammoType[0];//none
						currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						break;
					case ed.BLASTER :
						currentAmmo = ammoType[0];//none
						currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						break;
					case ed.SHOTGUN:
						currentAmmo = ammoType[1];//shells
						if (ammoCount[1] > 0){
							if(!p_rapidfire){ammoCount[1]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case "Unused":
					case ed.NONE :
						currentAmmo = ammoType[0];
						break;
					case ed.PLASMA_RIFLE :
						currentAmmo = ammoType[4];
						if (ammoCount[4] > 0)
						{
							if (!p_rapidfire){ammoCount[4]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case ed.MACHINEGUN :
						currentAmmo = ammoType[2];
						if (ammoCount[2] > 0)
						{
							if (!p_rapidfire){ammoCount[2]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case ed.CHAINGUN :
						currentAmmo = ammoType[2];
						if (ammoCount[2] > 0)
						{
							if (!p_rapidfire){ammoCount[2]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case ed.PLASMA_CANNON :
						currentAmmo = ammoType[4];
						if (ammoCount[4] >= 20)
						{
							if (!p_rapidfire){ammoCount[4] -=  20;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case ed.ROCKET_LAUNCHER :
						currentAmmo = ammoType[3];
						if (ammoCount[3] > 0)
						{
							if (!p_rapidfire){ammoCount[3]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					case ed.RAILGUN :
						currentAmmo = ammoType[5];//5
						if (ammoCount[5] > 0){
							if (!p_rapidfire){ammoCount[5]--;}
							currentRoom.shootProjectile(this.x,this.y,crosshairX,crosshairY,currentWeapon);
						}
						break;
					default :
						// Error Handler
						cmd.passConsoleMessage("\nPlayer.as: Error Detected in function: 'bulletTimer'\nPlayer.as: Either shouldn't be here or weapon cannot be shot at the moment.",0);
						break;
				}

			}
		}
	}

}