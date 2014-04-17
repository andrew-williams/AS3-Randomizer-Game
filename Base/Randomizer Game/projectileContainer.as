package  {
	/*NOTES:
	FIX SHOTGUN PELLET SPREAD TO SHOOT PROPERLY
	fix chaingun, similar to sg so it will spread randomly due to its high aspeed
	*/
	import flash.display.MovieClip;
	import flash.events.Event;
	/* TABLES
	Base Attributes Affect Both Player And Enemy.
	Player: Affects damage ratio between health and armor. Player has no weakness to base attributes.
	Enemy: Affects damage. Weakness = 2x damage, Strength = 0.5x damage. Enemies have no armor. Just a visible shield if any which is an extra layer of health.
	Base Attribute Table: Health/Armor Damage
	Normal    20/80
	Energy    40/60
	Explosive 50/50
	Magic     60/40
	Piercing  80/20
	
	Secondary Attributes Affect Enemy Only.
	Player: Player has no weakness to secondary attribute, therfore has no use to player.
	Enemy: Affects damage. Weakness = 2x damage, strength = 0.5x damage. Enemies have no armor. Affects shield.
	Secondary Attribute List:
	ELEMENTS: Fire, Water, Wind, Earth, Ice, Dark, Light, Electric
	Other: Plasma
	
	Normal is default base and secondary attribute.
	*/
	public class projectileContainer extends MovieClip {
		
		private var speed:int; // Projectile Speed
		private var attribute1:String = "Normal"; // Base Attribute
		private var attribute2:String = "Normal"; // Second Attribute
		private var ttl:int;                    // Time To Live
		private var angle:Number;
		private var dead:Boolean = false;
		private var test:int = 0;
		public function projectileContainer(): void {
			// constructor code

		}
		
		public function getBaseAttribute():String{return attribute1;}
		public function getSecondAttribute():String{return attribute2;}
		
		public function exit(): void{
			dead = true;
		}
		public function isdead():Boolean{
			//if (dead){
			//	trace("This projectile dealt " + getBaseAttribute() + "/" + getSecondAttribute() + " type damage if it hit something.");
			//}
			return dead;
		}

		private function getAttribute(): void{
			switch (this.currentFrame){
				case 1: //test shot
					speed = 30;
					break;
				case 2: //blaster shot
					attribute1 = "Energy";
					speed = 15;
				case 3: //plasma rifle shot
					attribute1 = "Energy";
					attribute2 = "Plasma";
					speed = 30;
					break;
				case 4: //bullet shot
				case 12://cg bulet
					speed = 30;
					break;
				case 5: // plasma cannon
					attribute1 = "Energy";
					attribute2 = "Plasma";
					speed = 30;
					break;
				case 6: // rocket launcher
					attribute1 = "Explosive";
					attribute2 = "Fire";
					speed = 20;
					break;
				case 7: // rail beam
					attribute1 = "Energy";
					speed = 0;
					this.addEventListener(Event.ENTER_FRAME, beamTimer,false,0,true);
					break;
				case 8: // rail beam
					attribute1 = "Piercing";
					speed = 0;
					dead = true;
					break;
				case 9: // fist
					speed = 3;
					ttl = 3;
					this.addEventListener(Event.ENTER_FRAME,timetolive,false,0,true);
					break;
				case 10: // combat knife
					attribute1 = "Piercing";
					speed = 5;
					ttl = 3;
					this.addEventListener(Event.ENTER_FRAME,timetolive,false,0,true);
					break;
				case 11: // sg pellet
					speed = 30;
					break;
				default:
					attribute1 = "Normal";
					attribute2 = "Normal";
					break;
			}
			//trace("The Attribute for this bullet is " + attribute1 + " and "+attribute2);
		}
		//FOR MELEE
		private function timetolive(e:Event): void{ // in frames
			if (ttl != 0){
				ttl--;
			}
			else{
				this.removeEventListener(Event.ENTER_FRAME,timetolive);
				//parent.removeChild(this);
				dead = true;
			}
		}
		//DONE FOR MELEE
		
		public function getEndAnim(identifier):int{
			var current:int = -1;
			switch (identifier){
				case "Railgun":
					current = this.prjRail.currentFrame;
					//return current;
					break;
			}
			return current;
		}
		
		private function beamTimer(e:Event): void{
			if (this.prjRail.currentFrame == this.prjRail.totalFrames){
				this.removeEventListener(Event.ENTER_FRAME,beamTimer);
				this.prjRail.gotoAndStop(1);
				}
		}
		
		public function shootBullet(destinationX,destinationY,playerX,playerY): void{
			getAttribute();
			// On X axis use the cosinus angle
			this.rotation = Math.atan2(destinationY - playerY,destinationX - playerX) * (180/Math.PI);
			switch (this.currentFrame){
				case 11://shotgun pellets
					angle = Math.atan2((Math.floor(Math.random() * 128) + (destinationY - playerY)) - 64,(Math.floor(Math.random() * 128) + (destinationX - playerX)) - 64);
					this.x +=  Math.cos(angle) * 16;
    				this.y +=  Math.sin(angle) * 16;
					this.addEventListener(Event.ENTER_FRAME,moveBullet,false,0,true);
					break;
				case 12://chaingun
					var randx =Math.floor(Math.random() * 16);
					var randy =Math.floor(Math.random() * 16);
					angle = Math.atan2( randx + (destinationY - playerY) - 8,randy + (destinationX - playerX) - 8);
					this.rotation = Math.atan2(destinationY - playerY,destinationX - playerX) * (180/Math.PI);
					this.x +=  Math.cos(angle) * 16;
    				this.y +=  Math.sin(angle) * 16;
					this.addEventListener(Event.ENTER_FRAME,moveBullet,false,0,true);
					break;
				case 7: //railguns
				case 8:
					angle = Math.atan2(destinationY - playerY,destinationX - playerX);
					break;
				default:
					angle = Math.atan2(destinationY - playerY,destinationX - playerX);
					//this.rotation = Math.atan2(destinationY - playerY,destinationX - playerX) * (180/Math.PI);
					this.x +=  Math.cos(angle) * 16;
    				this.y +=  Math.sin(angle) * 16;
					this.addEventListener(Event.ENTER_FRAME,moveBullet,false,0,true);
					break;
			}
			/*
			angle = Math.atan2(destinationY - playerY,destinationX - playerX);
			this.rotation = Math.atan2(destinationY - playerY,destinationX - playerX) * (180/Math.PI);
			
			if ((this.currentFrame != 7) && (this.currentFrame != 8)){//DO NOT ADD MOVEMENT TO INSTANT HITS LIKE RAILGUN
				this.x +=  Math.cos(angle) * 16;
    			this.y +=  Math.sin(angle) * 16;
				this.addEventListener(Event.ENTER_FRAME,moveBullet,false,0,true);
			}
			*/
		}
		
		private function moveBullet(e:Event): void{
			if (!dead){checkWallCollision();}
			if (!dead){
			this.x +=  Math.cos(angle) * speed;
    		this.y +=  Math.sin(angle) * speed;
			}
			
		}
		private function checkWallCollision(): void{
			var b:Number = 0;
			var c:Number = 0;
			if (x > 1000){
				dead = true;
			}
			else if (x < -1000){
				dead = true;
			}
			if (y > 1000){
				dead = true;
			}
			else if (y < -1000){
				dead = true;
			}
			if (!dead){var wallArray:Array = MovieClip(parent.parent).getCurrentRoomArray().getWallArray();
			for (b = 0; b < wallArray.length; b++)
			{

				for (c = 0; c < wallArray[b].walls.collision.numChildren; c++)
				{
					if (this.hitTestObject(wallArray[b].walls.collision.getChildAt(c)))
					{
						dead = true;
						break;
					}
				}
				
			}
			}
		}
	}
	
}
