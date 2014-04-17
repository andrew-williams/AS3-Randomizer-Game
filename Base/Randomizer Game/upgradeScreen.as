package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class upgradeScreen extends MovieClip {
		
		var player:Player;
		var cmd:consoleCommands;
		var shopFinished:Boolean = false;
		public function upgradeScreen(player:Player,cmd:consoleCommands) : void {
			// constructor code
			this.player = player;
			this.cmd = cmd;
			this.visible = false;
		}
		public function addListeners():void{
			btnMaxArmor.addEventListener(MouseEvent.CLICK,upMaxArmor,false,0,true);
			btnMaxHealth.addEventListener(MouseEvent.CLICK,upMaxHealth,false,0,true);
			btnContinue.addEventListener(MouseEvent.CLICK,finish,false,0,true);
		}
		
		private function finish(e:MouseEvent):void{
			removeListeners();
			shopFinished = true;
		}
		public function getShopFinished():Boolean{
			return shopFinished;
		}
		public function resetShop():void{
			shopFinished = false;
		}
		
		private function removeListeners():void{
			btnContinue.removeEventListener(MouseEvent.CLICK,finish);
			btnMaxArmor.removeEventListener(MouseEvent.CLICK,upMaxArmor);
			btnMaxHealth.removeEventListener(MouseEvent.CLICK,upMaxHealth);
		}
		private function upMaxArmor(e:MouseEvent):void{
			if (player.getSkillPoints() > 0){
				player.addArmorUpgradeLevel();
				cmd.passConsoleMessage("\n1 Skill Point Used On Armor Upgrade",3);
			}
			else{
				cmd.passConsoleMessage("\nNot Enough Skill Points",3);
			}
		}
		private function upMaxHealth(e:MouseEvent):void{
			if (player.getSkillPoints() > 0){
				player.addHealthUpgradeLevel();
				cmd.passConsoleMessage("\n1 Skill Point Used On Health Upgrade",3);
			}
			else{
				cmd.passConsoleMessage("\nNot Enough Skill Points",3);
			}
		}
		
		public function update(e:Event):void{
			txtSkillPointsRemaining.text = player.getSkillPoints();
			txtMaxHealthLevel.text = player.getHealthUpgradeLevel();
			txtMaxArmorLevel.text = player.getArmorUpgradeLevel();
			txtCurrentHealth.text = player.getHealth();
			txtMaxHealth.text = player.getMaxHealth();
			txtCurrentArmor.text = player.getArmor();
			txtMaxArmor.text = player.getMaxArmor();
			if (player.getArmorType() == 0){iconArmor.gotoAndStop(5);}
			else{iconArmor.gotoAndStop(player.getArmorType());}
		}
	}
	
}
