﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;		public class GameVisual extends MovieClip {				private static  var instance:GameVisual;						public static function getInstance():GameVisual {			if (instance == null) {				instance = new GameVisual();			}			return instance;		}				public function GameVisual(){		}				public var backGround:BackGround = new BackGround();		public var gridSystem;						public function init(){			addChild(backGround);			gridSystem = GridSystem.getInstance();			addChild(gridSystem);		}						public function update(){			for each (var array in GridSystem.GridArray)				for each (var g in array)					g.update();		}						public static function reset(){			instance = null;		}			}}