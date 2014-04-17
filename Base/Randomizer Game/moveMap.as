package  {
	
	public class moveMap extends Game{
		
		private var sX:int;
		private var sY:int;
		
		public function moveMap(startx:int, starty:int): void{
			sX = startx;
			sY = starty;
		}
		
		public function callFunction(direct:String, array:Array, mapLength:int, mapHeight:int): void{
			
			switch(direct){
				case "East":
				for (var i:int = 0; i < mapHeight; i++)
				{
					for (var j:int = 0; j < mapLength; j++)
					{
						if (array[i][j] != null){
							array[i][j].x -= 672;//672
						}
					}
				}
				break;
				case "West":
				for (var k:int = 0; k < mapHeight; k++)
				{
					for (var l:int = 0; l < mapLength; l++)
					{
						if (array[k][l] != null){
							array[k][l].x += 672;
						}
					}
				}
				break;
				case "North":
				for (var m:int = 0; m < mapHeight; m++)
				{
					for (var n:int = 0; n < mapLength; n++)
					{
						if (array[m][n] != null){
							array[m][n].y += 672;
						}
					}
				}
				break;
				case "South":
				for (var o:int = 0; o < mapHeight; o++)
				{
					for (var p:int = 0; p < mapLength; p++)
					{
						if (array[o][p] != null){
							array[o][p].y -= 672;
						}
					}
				}
				break;
				
				case "Start":
				//this.x = 13 + xLoc * 672;
			//this.y = 13 + yLoc * 672;
				for (var q:int = 0; q < mapHeight; q++)
				{
					for (var r:int = 0; r < mapLength; r++)
					{
						if (array[q][r] != null){
							array[q][r].y -= (sY * 672);
							array[q][r].x -= (sX * 672);//672;
						}
					}
				}
				break;
			}
			
		}
		

	}
	
}
