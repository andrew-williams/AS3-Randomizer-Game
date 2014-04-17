package  {
	
	public class initializeWeaponSlotData {
		private var ed:entityDefinitions
		private var slotLimit:int;
		private static const maxweaponslots:int = 10;
		
		public function initializeWeaponSlotData(ed:entityDefinitions): void {
			this.ed = ed;
			slotLimit = 3;
			trace("initializeWeaponSlotData Created");
			// constructor code
		}
		
		public function getSlotLimit():int{
			return slotLimit;
		}
		
		public function getMaxWeaponSlots():int{
			return maxweaponslots;
		}
		
		public function initializeWeaponsInSlots(): Array{
			var weaponSlot:Array = new Array();
			var weaponSlot0:Array = new Array(ed.PLASMA_CANNON,ed.NONE,ed.NONE);
			var weaponSlot1:Array = new Array(ed.FIST,ed.BLASTER,ed.COMBAT_KNIFE);
			var weaponSlot2:Array = new Array(ed.SHOTGUN,ed.NONE,ed.NONE);
			var weaponSlot3:Array = new Array(ed.MACHINEGUN,ed.CHAINGUN,ed.NONE);
			var weaponSlot4:Array = new Array(ed.ROCKET_LAUNCHER,ed.GRENADE_LAUNCHER,ed.NONE);
			var weaponSlot5:Array = new Array(ed.PLASMA_RIFLE,ed.NONE,ed.NONE);
			var weaponSlot6:Array = new Array(ed.SNIPER_RIFLE,ed.NONE,ed.NONE);
			var weaponSlot7:Array = new Array("Unused",ed.NONE,ed.NONE);
			var weaponSlot8:Array = new Array("Unused",ed.NONE,ed.NONE);
			var weaponSlot9:Array = new Array(ed.RAILGUN,ed.NONE,ed.NONE);
			weaponSlot.push(weaponSlot0);
			weaponSlot.push(weaponSlot1);
			weaponSlot.push(weaponSlot2);
			weaponSlot.push(weaponSlot3);
			weaponSlot.push(weaponSlot4);
			weaponSlot.push(weaponSlot5);
			weaponSlot.push(weaponSlot6);
			weaponSlot.push(weaponSlot7);
			weaponSlot.push(weaponSlot8);
			weaponSlot.push(weaponSlot9);
			return weaponSlot;
		}
		
		public function initializeWeaponSlotsAvailable():Array{
			var weaponSlotAvailable:Array = new Array(0,1,0,0,0,0,0,0,0,0);
			return weaponSlotAvailable;
		}
		
		public function initializeWeaponsAvailable(): Array{
			var a:int = 0;
			var b:int = 0;
			var weaponAvailable:Array = new Array();
			for (b = 0; b < maxweaponslots; b++)
			{
				var weaponSlot:Array = new Array();
				for (a = 0; a < slotLimit; a++){
					weaponSlot.push(0);
				}
				weaponAvailable.push(weaponSlot);
			}
			weaponAvailable[1][0] = 1;
			return weaponAvailable;
		}

	}
	
}
