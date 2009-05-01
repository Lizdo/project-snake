package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	

	public class SoundManager {

		public static  var instance:SoundManager;

		public function SoundManager() {

		}
		
		public static function getInstance():SoundManager {
			if (instance == null) {
				instance = new SoundManager();
				return instance;
			} else {
				return instance;

			}
		}
		public var noMusic:Boolean = false;

		private var musicSoundChannel:SoundChannel = new SoundChannel();
		private var fxSoundChannel:SoundChannel = new SoundChannel();
		
		private var music;
		private var fx;

		public function playBackGroundMusic(id:String = "BKG") {
			if (noMusic)
				return;
			musicSoundChannel.stop();
			var st:SoundTransform = new SoundTransform(0.4);
			music = new (getDefinitionByName("MUSIC_"+ id) as Class)();
			musicSoundChannel = music.play(0,1000, st);
		}
		
		public function playFX(id:String = "DEFAULT"){
			if (noMusic)
				return;
			fx = new (getDefinitionByName("FX_"+ id) as Class)();
			fx.play(0,1);
		}
		
	}
}