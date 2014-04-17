package  {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.system.System;
	
	public class MainMenu extends Screen {
		
		public function MainMenu() : void {
			// constructor code
			addListeners();
		}
		
		public function onPlay(e:MouseEvent): void{
			removeListeners();
			dispatchEvent(new Event(Screen.PLAY));
		}
		public function onHelp(e:MouseEvent): void{
			removeListeners();
			dispatchEvent(new Event(Screen.HELP));
		}
		public function onCredits(e:MouseEvent): void{
			removeListeners();
			dispatchEvent(new Event(Screen.CREDITS));
		}
		
		override public function key_down(e:KeyboardEvent): void{
			if (e.keyCode == Keyboard.SPACE){
				//System.gc();
			}
		}
		
		private function addListeners(): void{
			btnPlay.addEventListener(MouseEvent.CLICK,onPlay,false,0,true);
			btnHelp.addEventListener(MouseEvent.CLICK,onHelp,false,0,true);
			btnCredits.addEventListener(MouseEvent.CLICK,onCredits,false,0,true);
		}
		
		private function removeListeners(): void{
			btnPlay.removeEventListener(MouseEvent.CLICK, onPlay);
			btnHelp.removeEventListener(MouseEvent.CLICK,onHelp);
			btnCredits.removeEventListener(MouseEvent.CLICK,onCredits);
		}

	}
	
}
