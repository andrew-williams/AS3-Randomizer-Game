package  {
	
	public class null2dArray {

		public function null2dArray() : void{
			
		}
		public function callFunction(array:Array,ifNew:Boolean = false, maxX:int = 2, maxY:int = 2):Array{
			for (var i:int = 0; i < maxY; i++){
				if (ifNew){array[i] = new Array();}
				for (var j:int = 0; j < maxX; j++)
				{
					array[i][j] = null;
				}
			}
			return array;
			
		}
		

	}
	
}
