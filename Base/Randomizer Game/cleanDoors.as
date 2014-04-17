package  {
	//import flash.display.MovieClip;
	
	public class cleanDoors extends Game{
		/*
		This function will clean up the doors after level generation.
		The function is given the 2D Map array with the map height and length(width).
		First, the function will check 2 columns at a time for any doors that do not link.
		If they do not link, remove doors from the unlinked rooms.
		Then do the same for 2 rows at a time.
		After that, now that the doors are fixed and all doors connect together, add walls onto the disabled doors
		to signify that there is no door there.
		*/
		
		public function cleanDoors(array, mapLength, mapHeight): void {
			// constructor code
			//trace("Clear East West Unlinked Doors");
			for (var j:int = 0; j < mapLength - 1; j++)
			{
				for (var i:int = 0; i < mapHeight; i++)
				{
					if ((array[j][i] != null) && (array[j+1][i] != null))
					{
						if ((array[j][i].getEastDoor()) && (!array[j+1][i].getWestDoor()))
						{
							array[j][i].removeEastDoor();
							array[j + 1][i].removeWestDoor();
						}
						if ((!array[j][i].getEastDoor()) && (array[j+1][i].getWestDoor()))
						{
							array[j][i].removeEastDoor();
							array[j + 1][i].removeWestDoor();
						}
					}
					else if ((array[j][i] == null) && (array[j+1][i] != null)){
						array[j + 1][i].removeWestDoor();
						
					}
					else if ((array[j][i] != null) && (array[j+1][i] == null)){
						array[j][i].removeEastDoor();
					}
				}
			}
			//trace("Clear North South Unlinked Doors"); // FIX THIS
			for (var k:int = 0; k < mapLength; k++)
			{
				for (var l:int = 0; l < mapHeight + 1; l++)
				{
					if ((array[k][l] != null) && (array[k][l+1] != null))
					{
						if ((array[k][l].getSouthDoor()) && (!array[k][l+1].getNorthDoor()))
						{
							array[k][l].removeSouthDoor();
							array[k][l + 1].removeNorthDoor();
						}
						if ((!array[k][l].getSouthDoor()) && (array[k][l+1].getNorthDoor()))
						{
							array[k][l].removeSouthDoor();
							array[k][l + 1].removeNorthDoor();
							
						}
					}
					else if ((array[k][l] == null) && (array[k][l+1] != null))
					{
						array[k][l + 1].removeNorthDoor();
					}
					else if ((array[k][l] != null) && (array[k][l+1] == null)){
						array[k][l].removeSouthDoor();
					}
				}
			}
		}
	}
	
}
