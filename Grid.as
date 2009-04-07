﻿package {	import flash.display.MovieClip;	import flash.display.*;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.filters.GlowFilter;	import flash.filters.DropShadowFilter;		public class Grid extends MovieClip {				public var idX:Number;		public var idY:Number;						public function Grid(){		}				public var enemy;		public var bodyPart;				public var snake;				/*			TODO 				Split the visual from the grid		*/				public function init(idx:int, idy:int){			idX = idx;			idY = idy;			snake = Snake.getInstance();		}				public function addBorder(){			var border = new Sprite();			border.graphics.lineStyle(1);			border.graphics.drawRect(0, 0, GridSystem.GRID_SIZE, GridSystem.GRID_SIZE);			border.alpha = 0.5;			gridVisual.addChild(border);		}						public function get State():String		{ 			if (bodyPart != null)				return "Snake";			else if (enemy != null)				return "Enemy";			else				return "None";		}		public function set State(value:String):void		{			return;		}				public var gridVisual:Sprite;				public function update(){			if (enemy && enemy.movingInProgress)				return;		//	safelyRemove(gridVisual);			//if (State != "None" && State != "")			//	addGridVisual();		}				private function addGridVisual(){			gridVisual = new Sprite();			addChild(gridVisual);		}						private function safelyRemove(obj, objContainer = "this"){			if (objContainer == "this")				var container = this;			else				container = objContainer;			if (obj!=null)				if (container.contains(obj))					container.removeChild(obj);		}			}}