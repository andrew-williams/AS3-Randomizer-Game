package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Console extends MovieClip {
		
		private var lastInputCommand:String = "";
		private var lastInput:String;
		private var lastAttribute:String;
		private var lastAttribute2:String;
		private var lastAttribute3:String;
		private var lastOutput:String;
		
		public function Console(): void {
			// constructor code
			inputTXT.multiline = false;
			inputTXT.text = "";
			txtOutput.appendText("\n\n\n\n\n\n\n\n\n\n\n\n");
		}
		
		public function returnLastInputCommand():String{
			return lastInputCommand;
		}
		
		public function getLastInputCommand(): void{
			inputTXT.text = lastInputCommand;
		}
		
		public function getLastInput():String{
			return lastInput;
		}
		
		public function getLastAttribute2():String{
			return lastAttribute2;
		}
		
		public function getLastAttribute():String{
			return lastAttribute;
		}
		
		public function getLastAttribute3():String{
			return lastAttribute3;
		}
		private function splitString(msg:String): void{
			var stringToSplit:String = msg;
     		var splitString:Array = stringToSplit.split(" "); // results == ["","b"]
     		for (var a:int = 0; a < splitString.length; a++){
				if (a == 0){
					lastInput = splitString[a];
					lastAttribute = null;
					lastAttribute2 = null;
				}
				else if (a == 1){
					lastAttribute = splitString[a];
				}
				else if (a == 2){
					lastAttribute2 = splitString[a];
				}
				else if (a == 3){
					lastAttribute3 = splitString[a];
				}
			}
		}
		
		public function setInput(): void{
			txtOutput.appendText("\n] " + inputTXT.text);
			splitString(inputTXT.text);
			lastInputCommand = inputTXT.text;
			inputTXT.text = "";
			txtOutput.scrollV = txtOutput.maxScrollV;
		}
		public function getLastOutput():String{
			return lastOutput;
		}
		
		public function setMessage(msg:String, timer:int = 3): void{
			lastOutput = msg;
			MovieClip(parent.parent).setConsoleDisplayTimer(timer);
			txtOutput.appendText(msg);
			txtOutput.scrollV = txtOutput.maxScrollV;
			
		}
	}
	
}
