package  {
	
	import flash.display.MovieClip;
	
	
	public class pushContainer extends MovieClip {
		
		private var previousX:int;
		private var previousY:int;
		private var startX:int;
		private var startY:int;
		
		
		public function pushContainer(): void {
			// constructor code
		}
		public function setTouch(dir:String): void{
			previousX = this.x;
			previousY = this.y;
			switch (dir){
				case "W":
					this.x -= 4;
					checkWallCollision("EW");
					checkFloorCollision("EW");
					checkPushBlockCollision("W");
					break;
				case "E":
					this.x += 4;
					checkWallCollision("EW");
					checkFloorCollision("EW");
					checkPushBlockCollision("E");
					break;
				case "S":
					this.y += 4;
					checkWallCollision("NS");
					checkFloorCollision("NS");
					checkPushBlockCollision("S");
					break;
				case "N":
					this.y -= 4;
					checkWallCollision("NS");
					checkFloorCollision("NS");
					checkPushBlockCollision("N");
					break;
			}
		}
		private function checkFloorCollision(directional:String): void{
			var floorArray:Array = MovieClip(parent).getFloorArray();
			for (var b:int = 0; b < floorArray.length; b++){
				if (this.pushblock.collision.hitTestObject(floorArray[b])){
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
		private function checkPushBlockCollision(directional:String): void{
			var pushArray:Array = MovieClip(parent).getPushArray();
			for (var b:int = 0; b < pushArray.length; b++){
				if ((this.hitTestObject(pushArray[b].pushblock.collision))&& (this != pushArray[b])){
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
		public function resetBlock(): void{
			this.x = startX;
			this.y = startY;
		}
		public function setStart(xLoc,yLoc): void{
			startX = xLoc;
			startY = yLoc;
		}
		private function checkWallCollision(directional:String): void
		{
			var b:Number = 0;
			var wallArray:Array = MovieClip(parent).getWallArray();
			for (b = 0; b < wallArray.length; b++)
			{
					if (this.hitTestObject(wallArray[b].walls.collision))
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
	
}
