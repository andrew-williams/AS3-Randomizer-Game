package  {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/*
		xloc = the x location of the entity
		yloc = the y location of the entity
		frame = the type of entity in the container
		object = the actual object itself
		objectarray = the object array for the container
		entity = identifier
		*/
	public class addEntity extends MovieClip{

		private var sParent:Sprite;
		private var maxFrame = 52;


		public function addEntity(parentSprite): void {
			// constructor code
			sParent = parentSprite;
		}
		
		private function assignStats(xloc, yloc,frame, object,objectArray:Array): void{
			object.x = xloc * 32;
			object.y = yloc * 32;
			object.gotoAndStop(frame);
			sParent.addChild(object);
			objectArray.push(object);
		}
		public function callFunction(xloc, yloc,frame, object, objectArray:Array,entity:String = "Null"): void{
			switch (entity){
				case "Push"://for push container
					object = new pushContainer();
					object.x = xloc * 32;
					object.y = yloc * 32;
					object.setStart(object.x,object.y);
					object.gotoAndStop(frame);
					sParent.addChild(object);
					objectArray.push(object);
					break;
				case "Wall":// for wallContainer
					object = new wallContainer();
					assignStats(xloc,yloc,frame,object,objectArray);
					break;
				case "Floor":// for floorContainer
					object = new floorContainer();
					assignStats(xloc,yloc,frame,object,objectArray);
					break;
				case "Item":// for itemContainer
					if ((frame != 1) && (frame <= maxFrame)){
						object = new itemContainer();
						assignStats(xloc,yloc,frame,object,objectArray);
					}
					break;
				case "Enemy":
					object = new enemyContainer(MovieClip(sParent).getWallArray());
					object.x = xloc * 32 + 16;
					object.y = yloc * 32 + 16;
					object.gotoAndStop(frame);
					sParent.addChild(object);
					objectArray.push(object);
					break;
				default:
					trace("Unknown Identifier");
					break;
			}
		}
		
		public function createProjectile(xloc,yloc,frame,object,objectArray,crosshairx,crosshairy): void{
			object = new projectileContainer();
			object.x = xloc;
			object.y = yloc;
			object.gotoAndStop(frame);
			sParent.addChild(object);
			object.shootBullet(crosshairx,crosshairy,xloc,yloc);
			objectArray.push(object);
		}

	}
	
}
