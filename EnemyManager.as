﻿package {	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	import fl.transitions.Tween;	import fl.transitions.easing.*;	import fl.transitions.TweenEvent;			public class EnemyManager {		private static var instance:EnemyManager;		public static function getInstance():EnemyManager {			if (instance == null)			{				instance = new EnemyManager  ;			}			return instance;		}		public function EnemyManager() {		}		private var gameLogic:GameLogic;		private var snake:Snake;				public function init(){			EnemyList = new Array();			gameLogic = GameLogic.getInstance();			snake = Snake.getInstance();		}		public var EnemyList:Array;		public var LAST_ENEMY_UPDATE = 0;				public var ENEMY_SPAWN_INTERVAL = 3000;		public function update(){						if (gameLogic.TOTAL_RUNNING_TIME - LAST_ENEMY_UPDATE >= ENEMY_SPAWN_INTERVAL){				spawnEnemy();				LAST_ENEMY_UPDATE = gameLogic.TOTAL_RUNNING_TIME;			}					}				private function spawnEnemy(){			var g:Grid = getRandomEmptyGrid();			var e:Enemy = new Enemy(g);			e.Type = "Absorb";			//e.Type = Enemy.getRandomType();			EnemyList.push(e);		}				private function getRandomEmptyGrid():Grid{			var rndX = Math.floor(Math.random() * GridSystem.BATTLEFIELD_X);			var rndY = Math.floor(Math.random() * GridSystem.BATTLEFIELD_Y);			if (GridSystem.outOfBorder(rndX, rndY))				return getRandomEmptyGrid();			var g:Grid = GridSystem.GridArray[rndX][rndY];			if (snake.inBodyPartList(g))				return getRandomEmptyGrid();			for each (var enemy in EnemyList){				if (GridSystem.distance(g, enemy.grid) <= 2)					return getRandomEmptyGrid();			}			return g;		}		var TweenArray:Array = [];				public function absorbEnemyToGrid(g:Grid){			var enemy:Enemy = getEnemyToAbsorb(g);			if (enemy == null)				return;			//add latent function for moving the enemy TBD			//var tweenTime:Number = gameLogic.timeUntilNextMove() * 0.75;			//var absorbTweenX:Tween = new Tween(enemy, "x", Elastic.easeOut, enemy.x, g.x, tweenTime, false);			//var absorbTweenY:Tween = new Tween(enemy, "y", Elastic.easeOut, enemy.y, g.y, tweenTime, false);			enemy.grid = g;		}				private function absorbTweenCompleted(e:TweenEvent){					}				public function getEnemyToAbsorb(g:Grid):Enemy{			var adjucentGrids = GameLogic.getAdjucentGrids(g, Math.ceil(snake.absorbRadius))			for each (var grid in adjucentGrids){				if (grid.enemy != null)					return grid.enemy;			}			return null;		}				public static function reset(){			instance = null;		}	}}