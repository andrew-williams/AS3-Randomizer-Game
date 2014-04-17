package  {
	
	public class anglePlayer {
		//this rotates the player to look at the crosshair

		public function anglePlayer(): void {
			// constructor code
		}
		
		public function callFunction(mousex:int, mousey:int, playerx:int, playery:int, playerObj, playerRotObj, crosshairObj): void{
			playerRotObj.x = playerObj.x + 12;
			playerRotObj.y = playerObj.y + 12;
			playerRotObj.rotation = Math.atan2(mousey - playery,mousex - playerx) * (180/Math.PI);
			playerObj.setCrosshair(crosshairObj.x - 12,crosshairObj.y - 12);
		}

	}
	
}
