package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class enemyContainer extends MovieClip {
		
		//ENEMY STATUS
		private var health = Math.ceil(Math.random() * 50 + 50); // Health of Enemy
		private var speed:int;                                   // Movement Speed Of Enemy
		private var weakBaseAttribute:String;                    // Base Attribute Enemy Is Weak Against
		private var weakSecondAttribute:String;					 // Second Attribute Enemy Is Weak Against
		private var strongBaseAttribute:String;                  // Base Attribute Enemy Is Strong Against
		private var strongSecondAttribute:String;                // Second Attribute Enemy Is Strong Against
		
		private var targetX;
		private var targetY;
		private var wallarray:Array;
		private var enemyarray:Array;
		private var previousX;
		private var previousY;
		public var dead:Boolean = false;
		private var currentState:String = "Idle";
		private var randomTravelDistance:int = 0;
		private var randomNum:int = 0;
		//directions to move when idles
		private var moveLeft:Boolean = false;
		private var moveUp:Boolean = false;
		private var moveDown:Boolean = false;
		private var moveRight:Boolean = false;
		private var isShot:Boolean = false;
		
		public function enemyContainer(wall): void {
			this.enemy.gotoAndStop(1);
			speed = 2;
			wallarray = wall;
			weakBaseAttribute = "None";
			weakSecondAttribute = "None";
			strongBaseAttribute = "None";
			strongSecondAttribute = "None";
			//trace(MovieClip(parent).getCurrentRoomArray());
			
			
			// constructor code
			//this.addEventListener(Event.ENTER_FRAME,update);
		}
		public function getState():String{
			return currentState;
		}
		
		public function idleState(e:Event): void{
			previousX = this.x;
			previousY = this.y;
			//generateDirections
			if (randomTravelDistance < 1){
				randomNum = Math.ceil(Math.random() * 120);
				if (randomNum <= 10){ // go left
					moveLeft = true;
					moveRight = false;
					moveUp = false;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 10) && (randomNum <= 20)){//go up
					moveLeft = false;
					moveRight = false;
					moveUp = true;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 20) && (randomNum <= 30)){//go right
					moveLeft = false;
					moveRight = true;
					moveUp = false;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 30) && (randomNum <= 40)){//go down
					moveLeft = false;
					moveRight = false;
					moveUp = false;
					moveDown = true;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 40) && (randomNum <= 50)){//go nw
					moveLeft = true;
					moveRight = false;
					moveUp = true;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 50) && (randomNum <= 60)){//go ne
					moveLeft = false;
					moveRight = true;
					moveUp = true;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 60) && (randomNum <= 70)){//go se
					moveLeft = false;
					moveRight = true;
					moveUp = false;
					moveDown = true;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else if ((randomNum > 70) && (randomNum <= 80)){//go sw
					moveLeft = true;
					moveRight = false;
					moveUp = false;
					moveDown = true;
					randomTravelDistance = Math.ceil(Math.random() * 64);
				}
				else{//random idle time
					moveLeft = false;
					moveRight = false;
					moveUp = false;
					moveDown = false;
					randomTravelDistance = Math.ceil(Math.random() * 32);
				}
			}
			else{
				if (moveLeft){
					this.x -= speed;
					randomTravelDistance -= speed;
					checkWallCollision("EW");
				}
				else if (moveRight){
					this.x += speed;
					randomTravelDistance -= speed;
					checkWallCollision("EW");
				}
				if (moveUp){
					this.y -= speed;
					randomTravelDistance -= speed;
					checkWallCollision("NS");
				}
				else if (moveDown){
					this.y += speed;
					randomTravelDistance -= speed;
					checkWallCollision("NS");
				}
				else{
					randomTravelDistance --;
				}
			}
			checkPlayer("Detect");
		}
		private function checkBorder(): void{
			if (this.x < 0){
				this.x = 10;
			}
			else if (this.x > 680){
				this.x = 670;
			}
			if (this.y < 0){
				this.y = 10;
			}
			else if (this.y > 680){
				this.y = 670;
			}
		}
		public function checkPlayer(identifier:String): void{
			switch (identifier){
				case "Detect":
					if (((this.x - targetX) <= 128) && ((this.x - targetX) >= -128)){
						if (((this.y - targetY) <= 128) && ((this.y - targetY) >= -128)){
							this.enemy.gotoAndStop(2);
							speed = 3;
							currentState = "Seek";
						}
					}
					if (((this.y - targetY) <= 128) && ((this.y - targetY) >= -128)){
						if (((this.x - targetX) <= 128) && ((this.x - targetX) >= -128)){
							this.enemy.gotoAndStop(2);
							speed = 3;
							currentState = "Seek";
						}
					}
					break;
				case "Escaped":
					if (((this.x - targetX) >= 224) || ((this.x - targetX) <= -224)){
							this.enemy.gotoAndStop(1);
							speed = 2;
							currentState = "Idle";
					}
					
					else if (((this.y - targetY) >= 224) || ((this.y - targetY) <= -224)){
							this.enemy.gotoAndStop(1);
							speed = 2;
							currentState = "Idle";
					}
					break;
				case "Shot":
					isShot = true;
					this.enemy.gotoAndStop(3);
					speed = 6;
					currentState = "Shot";
					break;
			}
		}
		public function shotState(e:Event): void{
			previousX = this.x;
			previousY = this.y;
			//trace(speed);
			if (this.x < targetX - 5){
				this.x += speed;
				checkWallCollision("EW");
			}
			else if (this.x > targetX + 5){
				this.x -= speed;
				checkWallCollision("EW");
			}
			if (this.y < targetY - 5){
				this.y += speed;
				checkWallCollision("NS");
			}
			else if (this.y > targetY + 5){
				this.y -= speed; 
				checkWallCollision("NS");
			}
		}
		
		public function seekState(e:Event): void{
			previousX = this.x;
			previousY = this.y;
			//trace(speed);
			if (this.x < targetX - 5){
				this.x += speed;
				checkWallCollision("EW");
			}
			else if (this.x > targetX + 5){
				this.x -= speed;
				checkWallCollision("EW");
			}
			if (this.y < targetY - 5){
				this.y += speed;
				checkWallCollision("NS");
			}
			else if (this.y > targetY + 5){
				this.y -= speed; 
				checkWallCollision("NS");
			}
			checkPlayer("Escaped");
		}
		private function checkWallCollision(directional:String): void
		{
			var b:Number = 0;
			var c:Number = 0;
			for (b = 0; b < wallarray.length; b++)
			{
				if (this.enemy.collision.hitTestObject(wallarray[b]))
				{
					if (directional == "NS")
					{
						y = previousY;
					}
					else if (directional == "EW")
					{
						x = previousX;
					}
					break;
				}

			}
			checkBorder();
		}
		
		public function setTarget(identifier, target): void{
			switch (identifier){
				case "X":
					targetX = target;
					break;
				case "Y":
					targetY = target;
					break;
				case "Wall Array":
					wallarray = target;
					break;
				case "Enemy Array":
					enemyarray = target;
					break;
			}
		}
		
		public function modifyHealth(hpValue:int,baseattribute:String = null,secondattribute:String = null):int{
			health = health + hpValue;
			//trace ("Health : " + health);
			if (health <= 0){
				dead = true;
			}
			return health;
		}
		
		public function getHealth():int{
			return health;
		}
	}
	
}
