package {

	//imports
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	
	public class BodyPart{
		
		public var grid;
		
		private var _State:String = "Normal";
		public var isHead:Boolean = false;
		
		public function BodyPart(g:Grid){
			grid = g;
			//g.State = "Enemy";
		}
		
		
		public function set State(s:String){
			if (_State == s)
				return;
			switch (State){
				case "Normal":
				default:
				_State = s;
			}
		}
		
		public function get State():String{
			return _State;
		}
		
		
	}
}