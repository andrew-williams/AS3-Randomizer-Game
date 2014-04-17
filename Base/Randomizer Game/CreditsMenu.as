package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	
	public class CreditsMenu extends Screen {
		
		public function CreditsMenu(): void {
			// constructor code
			addListeners();
		}
		
		public function onBack(e:MouseEvent): void{
			removeListeners();
			dispatchEvent(new Event(Screen.END));
		}
		
		private function addListeners(): void{
			btnBack.addEventListener(MouseEvent.CLICK,onBack,false,0,true);
		}
		
		private function removeListeners(): void{
			btnBack.removeEventListener(MouseEvent.CLICK, onBack);
		}
		
	}
	
}
