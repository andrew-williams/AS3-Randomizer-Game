package  
{
	import flash.display.*;
	import flash.media.*;
	import flash.net.URLRequest;
	import flash.events.*;
		
	public class musicHandler extends MovieClip {

		//public static const TITLE:String = "Title Music";
		public static const LEVEL1:String = "Level 1 Music";
		//public static const BOSS:String = "Boss Music";

		private var music:Sound = new Sound();
		private var musicChannel:SoundChannel = new SoundChannel();
		private var isMusicPlaying:Boolean = false;
		private var soundTrack:Array = new Array(LEVEL1);
		private var mPos:int = 0;
		private var currentTrack:String = "NULL";

		public function musicHandler(track:String = null): void {
			// constructor code
			setMusicAndPlay(track);
		}
		
		public function getMaxTracks(): int{
			var max:int = 0;
			for (var count:int = 0; count < soundTrack.length; count++){
				max++;
			}
			return max;
		}
		
		public function displaySoundTrack(): void{
			trace("Tracks Detected: " + (soundTrack.length));
			for (var count:int = 0; count < soundTrack.length; count++){
				trace("Track " + (count + 1) + " = " + soundTrack[count]);
			}
		}
		
		private function completeSound(e:Event): void{
			//trace("PLaying from " + mPos);
   			playMusic(mPos);
		}
		
		public function setMusicAndPlay(track:String, position:int = 0): void{
			stopMusic();
			mPos = position;
			switch (track){
				/*case TITLE:
					currentTrack = TITLE;
					music = new musTitle();
					playMusic(mPos);
					break;
					*/
				case LEVEL1:
				/*
					currentTrack = LEVEL1;
					music = new musGame();
					playMusic(mPos);
					*/
					break;
					/*
				case BOSS:
					currentTrack = BOSS;
					music = new musBoss();
					playMusic(mPos);
					break;
					*/
				default:
					music = null;
					trace("Music Not Found");
					break;
			}
			//trace("Current Track: " + track);
		}
		
		public function playMusic(position): void{
			mPos = position;
			stopMusic();
			musicChannel = music.play(mPos,0);
			musicChannel.addEventListener(Event.SOUND_COMPLETE,completeSound);
			if (currentTrack == LEVEL1){
				mPos = 0;//8350;
			}
			/*
			else if (currentTrack == BOSS){
				mPos = 12250;
			}
			else if (currentTrack == TITLE){
				mPos = 0;
			}
			*/
			isMusicPlaying = true;
		}
		
		public function stopMusic(): void{
			musicChannel.stop();
			isMusicPlaying = false;
		}

	}
	
}
