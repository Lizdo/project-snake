﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;		public class GameVisual extends MovieClip {				private static  var instance:GameVisual;						public static function getInstance():GameVisual {			if (instance == null) {				instance = new GameVisual();			}			return instance;		}				public function GameVisual(){		}				public var background:Background = new Background();		public var gridSystem;		public var snake;		public var enemyManager;				public function init(){			addChild(background);						gridSystem = GridSystem.getInstance();			addChild(gridSystem);						snake = Snake.getInstance();			addChild(snake);						enemyManager = EnemyManager.getInstance();			addChild(enemyManager);						background.init();					}						public function update(){			for each (var array in GridSystem.GridArray)				for each (var g in array)					g.updateVisual();			snake.updateVisual();			enemyManager.updateVisual();		}				public function updateBackground(time:Number){			background.update(time);		}				////////////////////////////////		///		Common functions		////////////////////////////////						public static function getColorByType(Type:String):int{			switch (Type){				case "Speed":					return 0xDED322;				case "Energy":					return 0x44AB36;				case "Absorb":					return 0xB88421;				default:					return 0x888888;			}			return		}				//DED322,44AB36,247278,B88421,AB2F22				public static function safelyRemove(obj, objContainer){			var container = objContainer;			if (obj!=null)				if (container.contains(obj))					container.removeChild(obj);		}										public static function reset(){			instance = null;		}			}}