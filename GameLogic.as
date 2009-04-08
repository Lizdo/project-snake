﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import flash.utils.Timer;	import flash.utils.getTimer;		public class GameLogic{				private static var instance:GameLogic;						public static function getInstance():GameLogic {			if (instance == null) {				instance = new GameLogic();			}			return instance;		}						/*			TODO: GameState				NORMAL_GAMEPLAY				COLLECT_COMBO				BOSS_FIGHT					*/				private var validGameState:Array = ["State_Normal", "State_Combo", "State_Bossfight", "State_Pause"];				private var _State:String;		public function get State():String		{ 			return _State; 		}		public function set State(value:String):void		{			if (value !== _State && validGameState.indexOf(value) != -1)			{				_State = value;			}		}						private var updateTimer:Timer;		private var lastUpdatedTime:Number;					public var UPDATE_INTERVAL:Number = 40;		public var TOTAL_RUNNING_TIME:Number = 0;		public var RUNNING_TIME:Number = 0;				public var snake:Snake;		public var enemyManager;				public static var ValidType:Array = ["Speed", "Energy", "Absorb", "Regular"];						public function GameLogic(){		}				public function init(){			snake = Snake.getInstance();			enemyManager = EnemyManager.getInstance();			updateTimer = new Timer(UPDATE_INTERVAL,1);	//inifinite Loop			updateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, update);			lastUpdatedTime = getTimer();						updateTimer.start();			this.State = "State_Pause";		}						public function update(e:TimerEvent){			updateTime();			updateControl();			//updateGrids();			EnemyManager.getInstance().update();						GameVisual.getInstance().update();			snake.update();		}						private function updateTime(){			// Check if turn is Finished			if (State != "State_Pause"){				TOTAL_RUNNING_TIME += UPDATE_INTERVAL;				RUNNING_TIME += UPDATE_INTERVAL;			}			//New Timer			var currentTime:Number = getTimer();			var newTimeInterval = UPDATE_INTERVAL - (currentTime - lastUpdatedTime - UPDATE_INTERVAL);			lastUpdatedTime = currentTime;			if (newTimeInterval <= 0)				newTimeInterval = 5;			updateTimer = new Timer(newTimeInterval,1);	//inifinite Loop			updateTimer.start();			updateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, update);								}							private var _Input:String = "";		public var LastInput:String = "";		public var LAST_INPUT_UPDATE:Number = 0;				public function set Input(s:String){			if (s == _Input)				return;			if (getReverse(s) == _Input)				return;			if (State == "State_Pause")				State = "State_Normal";			switch (s){				case "UP":				case "DOWN":				case "LEFT":				case "RIGHT":					_Input = s;					LastInput = s;					break;			}		}				public static function getReverse(s:String):String		{			if (s == "UP")				return "DOWN";			if (s == "DOWN")				return "UP";			if (s == "LEFT")				return "RIGHT";			if (s == "RIGHT")				return "LEFT";			return null;		}				public function get Input():String{			return _Input;		}				private function updateControl(){						if (TOTAL_RUNNING_TIME - LAST_INPUT_UPDATE >= timeUntilNextMove()){				//move snake				moveSnake();				LAST_INPUT_UPDATE = TOTAL_RUNNING_TIME;				Input = "";			}		}				// Speed = ? Grid per second... for example 3g/s		//		timeNeeded for 1 grid= 1000 / 3				public function timeUntilNextMove():Number{			var speed = snake.Speed * (snake.hasSpecialState("Speed")?4:1);			var timeNeeded:Number = 1000/speed;			return timeNeeded;		}				private function moveSnake(){			if (State == "State_Pause")				return;						if (Input == "")				Input = LastInput;							var g:Grid = snake.head.grid;			var nextGrid:Grid = getNextGrid(g);						if (nextGrid == null){				hitBorder();				return;			}						if (snake.inBodyPartList(nextGrid)){				hitSelf(nextGrid);				return;			}			//Update GridList						var enemyHit:Boolean = false;						for each (var enemy in enemyManager.EnemyList){				if (nextGrid == enemy.grid){					enemyManager.removeEnemy(enemy);					enemyHit = true;					break;				}			}						snake.moveToNextGrid(nextGrid, enemyHit);			//absorb starts after every movement			updateAbsorb();		}				private function getNextGrid(g:Grid):Grid{			var nextI = g.idX;			var nextJ = g.idY;						switch (Input){				case "UP":					nextJ--;					break;				case "DOWN":					nextJ++;					break;								case "LEFT":					nextI--;					break;													case "RIGHT":					nextI++;					break;				default:					trace("Input Error !!!!");					return null;			}			if (GridSystem.outOfBorder(nextI, nextJ)){				return null;			}			var nextGrid = GridSystem.GridArray[nextI][nextJ];			return nextGrid;		}						private function updateAbsorb(){			if (!snake.hasSpecialState("Absorb"))				return;			var nextGrid = getNextGrid(snake.head.grid);			//hit border next			if (nextGrid == null)				return;			enemyManager.absorbEnemyToGrid(nextGrid);		}				private function hitSelf(nextGrid:Grid){			restart();		}				private function hitBorder(){			restart();		}						public static function getAdjucentGrids(sourceGrid:Grid, radius:int):Array		{			var oriI:int = sourceGrid.idX;			var oriJ:int = sourceGrid.idY;			var returnArray:Array = [];			for (var i:int = -radius; i <= radius; i++)			{				for (var j:int = -radius; j <= radius; j++)				{					var nextI:int = oriI + i;					var nextJ:int = oriJ + j;					if (!GridSystem.outOfBorder(nextI, nextJ)){						var grid = GridSystem.GridArray[nextI][nextJ];						returnArray.push(grid);					}									}			}			return returnArray;		}		/////////////////////		///		MISC		/////////////////////				public function restart(){			trace("restart!");			updateTimer.stop();			ProjectSnake.getInstance().restart();		}						public static function reset(){			instance = null;			}					}}