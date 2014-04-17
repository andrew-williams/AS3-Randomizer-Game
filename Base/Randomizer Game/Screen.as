package  {
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	public class Screen extends MovieClip{

		public static const PLAY:String = "Play Game";
		public static const END:String = "Main Menu";
		public static const HELP:String = "Help Menu";
		public static const CREDITS:String = "Credits Menu";

		public function Screen() : void {
			// constructor code
		}
		public function update(e:Event) : void{}
		public function key_down(e:KeyboardEvent) : void{}
		public function key_up(e:KeyboardEvent): void{}
		public function mouse_move(e:MouseEvent): void{}
		public function mouse_up(e:MouseEvent): void{}
		public function mouse_down(e:MouseEvent): void{}
		public function right_click(e:MouseEvent): void{}
		//public function left_click(e:MouseEvent){}
		public function tick(e:TimerEvent): void{}
	}
	
}
