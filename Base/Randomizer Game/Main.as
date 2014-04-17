package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Main extends MovieClip {
		
		private var screen:Screen;
		private var debugmode:Boolean = true;
		private var tick:Timer; //for timers that count up/down per second
		
		private function forceGC(): void{
			System.gc();
		}
		private function debug(): void{
			trace("Memory Used: "+System.totalMemory / 1024 / 1024 + " Mb");
			//forceGC();
		}
		
		public function Main(): void {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.focus = this;
			stage.stageFocusRect = false;
			screen = new MainMenu();
			this.addChild(screen);
			addListeners();
			addInputListeners();
		}
		
		private function addInputListeners():void{
			stage.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse_move, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouse_down, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouse_up, false, 0, true);
			stage.addEventListener(MouseEvent.RIGHT_CLICK,right_click, false, 0, true);//disable rightclick
			stage.addEventListener(MouseEvent.CLICK,left_click,false,0,true);
			tick = new Timer(1000,0);
			tick.addEventListener(TimerEvent.TIMER,tickTimer,false,0,true);
			tick.start();
		}
		
		
		private function addListeners(){
			screen.addEventListener(Screen.PLAY, onScreenChange,false,0,true);
			screen.addEventListener(Screen.END, onScreenChange,false,0,true);
			screen.addEventListener(Screen.CREDITS, onScreenChange,false,0,true);
			screen.addEventListener(Screen.HELP, onScreenChange,false,0,true);
			this.addChild(screen);
		}
		private function removeListeners(){
			screen.removeEventListener(Screen.PLAY, onScreenChange);
			screen.removeEventListener(Screen.END, onScreenChange);
			this.removeChild(screen);
			screen = null;
			//forceGC();
		}
		private function mouse_move(e:MouseEvent){screen.mouse_move(e);}
		private function mouse_up(e:MouseEvent){screen.mouse_up(e);}
		private function mouse_down(e:MouseEvent){screen.mouse_down(e);}
		private function right_click(e:MouseEvent){screen.right_click(e);}
		private function left_click(e:MouseEvent){}
		private function key_down(e:KeyboardEvent){screen.key_down(e);}
		private function key_up(e:KeyboardEvent){screen.key_up(e);}
		private function update(e:Event){screen.update(e);}
		private function tickTimer(e:TimerEvent){
			screen.tick(e);
			if (debugmode){
				debug();
			}
		}
		
		public function onScreenChange(e:Event)
		{
			removeListeners();
			switch (e.type)
			{
				case Screen.PLAY :
					screen = new Game();
					addListeners();
					MovieClip(screen).newGame();
					break;
				case Screen.END :
					screen = new MainMenu();
					addListeners();
					break;
				case Screen.HELP :
					screen = new HelpMenu();
					addListeners();
					break;
				case Screen.CREDITS :
					screen = new CreditsMenu();
					addListeners();
					break;
			}
			stage.focus = screen;
		}

	}
	
}
