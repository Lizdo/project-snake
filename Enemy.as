﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import flash.display.Sprite;			public class Enemy extends Sprite{				private var _grid:Grid;		public var movingInProgress:Boolean = false;		public function get grid():Grid		{ 			return _grid; 		}		public function set grid(value:Grid):void		{			if (value !== _grid)			{				if(_grid && _grid.enemy && _grid.enemy == this)					_grid.enemy = null;				_grid = value;				value.enemy = this;			}		};				private var _Type:String = "Regular";		public function get Type():String		{ 			return _Type; 		}		public function set Type(value:String):void		{			if (GameLogic.ValidType.indexOf(value) == -1)				return;			if (value != _Type)			{				_Type = value;			}		}				//Enemy Type:		//	Speed/Energy/Absorb/Regular						public static function getRandomType():String{			var index:int = Math.floor(Math.random() * GameLogic.ValidType.length);			return GameLogic.ValidType[index];		}				public function get Color():int{			return GameVisual.getColorByType(Type);		}						public function Enemy(g:Grid){			grid = g;		}								public function update(){			if (movingInProgress)				return;			if (x != grid.x || y != grid.y)			{				x = grid.x;				y = grid.y;				updateVisual();			}		}				private var enemySizeRatio = 0.8;				private var visual:Sprite;				private function updateVisual(){			GameVisual.safelyRemove(visual, this);			visual = new Sprite();			var offsetX = GridSystem.GRID_SIZE * (1 - enemySizeRatio);			var offsetY = GridSystem.GRID_SIZE * (1 - enemySizeRatio);									visual.graphics.beginFill(Color);			visual.graphics.drawRect(offsetX, offsetY, GridSystem.GRID_SIZE*enemySizeRatio, GridSystem.GRID_SIZE*enemySizeRatio);			visual.alpha = 0.5;			visual.graphics.endFill();			addChild(visual);		}					}}