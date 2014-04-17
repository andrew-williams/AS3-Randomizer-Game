package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class removeEntity extends MovieClip{

		private var sParent:Sprite;
		
		public function removeEntity(parentSprite:Sprite) : void{
			// constructor code
			sParent = parentSprite;
		}

		public function callFunction(object, objectArray, entity:String = "Null"): void{
			switch (entity){
				case "Wall":// for wallContainer
					objectArray.splice(objectArray.indexOf(object),1);
					sParent.removeChild(object);
					break;
				default:
					//trace("Unknown Identifier");
					if (objectArray.indexOf(object) != null){
						objectArray.splice(objectArray.indexOf(object),1);
						sParent.removeChild(object);
					}
					break;
			}
		}
		
	}
	
}
