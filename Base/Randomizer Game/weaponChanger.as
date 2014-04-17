package  {
/*
		Public Function: changeWeapon
		slot:int = the slot number being changed into. (slots 0-9)
		This function changes current weapon. if multiple weapons in a slot, will cycle. Requires a counter for a 'for' loop.
		If weapon slot has a weapon in it (weaponSlotAvailable[slot]) then do this function, else do nothing.
		If last slot selected is not current, make it current, then make start weapon check to first weapon.
		If current weapon in slot is the last weapon of all, go back to first weapon to cycle.
		Else, check the next weapon.
		For Loop:
			Start at last currently selected weapon. (if count < slotWeaponSelected)...
			If weapon is available in that slot, set current weapon. Set count to max to end loop.
			Else, check next weapon slot. if already at last weapon slot, go back to first weapon slot
			to cycle.
		After everything is done, set attack speed and ammo used for weapon.
		*/	
	public class weaponChanger {

		private var slotWeaponSelected = 0; //default first weapon:fist
		private var lastSlotSelected:int = 1; //default fist weapon slot: 1
		private var maxSlots:int;
		private var currentWeapon:String;

		public function weaponChanger(maxSlots:int) : void {
			this.maxSlots = maxSlots;
		}
		
		public function changeWeapon(slot:int, weaponAvailable:Array, weaponSlot:Array) : String{
			if (slotWeaponSelected == maxSlots - 1){
				slotWeaponSelected = 0;
			}
			else{
				slotWeaponSelected++;
			}
			if (lastSlotSelected != slot){
				lastSlotSelected = slot;
				slotWeaponSelected = 0;
			}
			for (var a:int = 0; a < maxSlots; a++){
				if (a < slotWeaponSelected){
					a = slotWeaponSelected;
				}
				if (weaponAvailable[slot][a] == 1)
				{
					currentWeapon = weaponSlot[slot][a];
					a = maxSlots;
				}
				else{
					if (slotWeaponSelected == maxSlots - 1){
						slotWeaponSelected = 0;
						a = -1;
					}
					else{
						slotWeaponSelected++;
					}
				}
			}
			return currentWeapon;
		}

	}
	
}
