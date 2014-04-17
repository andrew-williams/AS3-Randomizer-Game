package  {
	
	public class assignAmmo {

		private var ed:entityDefinitions;
		
		public function assignAmmo(ed:entityDefinitions) : void{
			// constructor code
			this.ed = ed;
		}
//ammoType:Array = new Array("None","Shells","Bullets","Rockets","Cells","Slugs","Explosives");
		public function getAmmo(weapon:String, ammoType:Array) : String {
			var ammo:String;
			switch (weapon){
				//All shell ammos
				case ed.SHOTGUN:
					ammo = ammoType[1].toString();
					break;
				//All bullet ammos
				case ed.MACHINEGUN:
				case ed.CHAINGUN:
					ammo = ammoType[2].toString();
					break;
				//All rocket ammos
				case ed.ROCKET_LAUNCHER:
					ammo = ammoType[3].toString();
					break;
				//All cell ammos
				case ed.PLASMA_CANNON:
				case ed.PLASMA_RIFLE:
					ammo = ammoType[4].toString();
					break;
				//All slug ammos
				case ed.RAILGUN:
				case ed.SNIPER_RIFLE:
					ammo = ammoType[5].toString();
					break;
				//All explosive ammos
				case ed.GRENADE_LAUNCHER:
					ammo = ammoType[6].toString();
					break;
				default:
					ammo = ammoType[0].toString();
					break;
			}
			return ammo;
		}
		
		public function getAmmoFrame(weapon:String) : int{
			var ammo:int;
			switch (weapon){
				//All shell ammo
				case ed.SHOTGUN:
					ammo = 11;
					break;
				//All bullet ammo
				case ed.CHAINGUN:
				case ed.MACHINEGUN:
					ammo = 7;
					break;
				//All rocket ammo
				case ed.ROCKET_LAUNCHER:
					ammo = 10;
					break;
				//All cell ammo
				case ed.PLASMA_CANNON:
				case ed.PLASMA_RIFLE:
					ammo = 8;
					break;
				//All slug ammo
				case ed.RAILGUN:
				case ed.SNIPER_RIFLE:
					ammo = 12;
					break;
				//All explosive ammo
				case ed.GRENADE_LAUNCHER:
					ammo = 9;
					break;
				//All unlimited undefined ammo
				default :
					ammo = 5;
					break;
			}
			return ammo;
		}
		
		//Ammunition List:
		//(NONE,SHELLS,BULLETS,ROCKETS,CELLS,SLUGS,EXPLOSIVES);
		//This function actually displays the values on screen unlike the last one, which keeps track of the actual ammo count
		public function getAmmoSlot(weapon:String, ammoType) : String{
			var ammo:String;
			switch (weapon){
				//All shell ammos
				case ed.SHOTGUN:
					ammo = ammoType[1].toString();
					break;
				//All bullet ammos
				case ed.MACHINEGUN:
				case ed.CHAINGUN:
					ammo = ammoType[2].toString();
					break;
				//All rocket ammos
				case ed.ROCKET_LAUNCHER:
					ammo = ammoType[3].toString();
					break;
				//All cell ammos
				case ed.PLASMA_CANNON:
				case ed.PLASMA_RIFLE:
					ammo = ammoType[4].toString();
					break;
				//All slug ammos
				case ed.RAILGUN:
				case ed.SNIPER_RIFLE:
					ammo = ammoType[5].toString();
					break;
				//All explosive ammos
				case ed.GRENADE_LAUNCHER:
					ammo = ammoType[6].toString();
					break;
				default :
					ammo = "∞";
					break;
			}
			return ammo;
		}

	}
	
}
