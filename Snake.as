﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import flash.display.Sprite;		import flash.filters.GlowFilter;	import flash.filters.DropShadowFilter;			public class Snake extends Sprite{				private static var instance:Snake;						public static function getInstance():Snake {			if (instance == null) {				instance = new Snake();			}			return instance;		}				public var BodyPartList:Array = [];		public var head:BodyPart;		public var Energy:int = 100;		public var Speed:Number = 2.5;				private var _State:String = "Normal";				public function Snake(){					}						public function set State(s:String){			if (_State == s)				return;			if (_State == "EnergyEmpty" && s != "Normal")				return;			switch (State){				case "Normal":				case "EnemyAbsorbed":				case "Boost":				case "SpecialAbility":				case "EnergyEmpty":					_State = s;			}		}				public function get State():String{			return _State;		}				private var gameLogic:GameLogic;				public function init(){			//Set init position, init length;			gameLogic = GameLogic.getInstance();						var grids:Array = [];			var centerX:int = Math.round(GridSystem.BATTLEFIELD_X/2);			var centerY:int = Math.round(GridSystem.BATTLEFIELD_Y/2);			var g:Grid = GridSystem.GridArray[centerX][centerY];			var g2:Grid = GridSystem.GridArray[centerX][centerY+1];			grids.push(g2);			grids.push(g);			initWithGrids(grids);		}				public function initWithGrids(grids:Array){			BodyPartList = [];			for each (var g in grids){				var bodyPart = new BodyPart(g);				//bodyPart.Color = 0x247278;				addBodyPart(bodyPart);			}			//for the last bodypart, the head			bodyPart.isHead = true;			head = bodyPart;					}				public function moveToNextGrid(nextGrid:Grid, hitEnemy:Boolean){			if (hitEnemy){						head.isHead = false;				var bodyPart = new BodyPart(nextGrid);				bodyPart.isHead = true;				head = bodyPart;				addBodyPart(bodyPart);			}else{				for (var i:int = 0; i < BodyPartList.length-1; i++){					BodyPartList[i].grid = BodyPartList[i+1].grid;				}				BodyPartList[BodyPartList.length - 1].grid = nextGrid;			}		}				private function addBodyPart(b:BodyPart){			BodyPartList.push(b);			addChild(b);		}						public function inBodyPartList(g:Grid):Boolean {			for each (var bodyPart in BodyPartList){				if (bodyPart.grid == g)					return true;			}			return false;		}				public var energyDepleteRatio:int = 5;				private var LAST_ENERGY_UPDATE:int = 0;		private var ENERGY_UPDATE_INTERVAL:int = 500;						public function update(){			if (gameLogic.TOTAL_RUNNING_TIME - LAST_ENERGY_UPDATE >= ENERGY_UPDATE_INTERVAL){				updateEnergy();				LAST_ENERGY_UPDATE = gameLogic.TOTAL_RUNNING_TIME;			}							updateSpecialState();						for each (var b in BodyPartList){				b.update();			}					}				private var glowStrenth:Number = 12;		private var glowStrenthStep:Number = 0.1;		private var glowStrenthDelta:Number = 0.1;		private var glowStrenthMax = 18;		private var glowStrenthMin = 10;				private function updateGlowStrenth(){			glowStrenth += glowStrenthDelta;						if (glowStrenth > glowStrenthMax){				glowStrenth = glowStrenthMax;				glowStrenthDelta = - glowStrenthStep;			}						if (glowStrenthStep < glowStrenthMin){				glowStrenth = glowStrenthMin;				glowStrenthDelta = glowStrenthStep;			}		}								public function updateVisual(){			for each (var b in BodyPartList){				b.updateVisual();			}						if (State == "EnergyEmpty")				filters = [new DropShadowFilter(3.0,45,0xFF0000,0.8)];			else{				var filterArray = [new DropShadowFilter(3.0,45,0x000000,0.4)];				if (hasSpecialState()){					//updateGlowStrenth();					var specialStateColor = GameVisual.getColorByType(SpecialStateArray[0]);					filterArray.push(new GlowFilter(specialStateColor, 0.8, glowStrenth, glowStrenth, 2));				}				filters = filterArray;			}		}				private var nbOfPartsNeededForSpecialState = 4;		private var specialStateTimeOut:int = 4000;				public var absorbRadius:Number = 2;				private function updateSpecialState(){			var headType = head.Type;			if (BodyPartList.length < nbOfPartsNeededForSpecialState)				return;			var specialStateTriggered:Boolean = true;				for (var i:int = 1; i < nbOfPartsNeededForSpecialState; i++)			{				var bodyPart = BodyPartList[BodyPartList.length - i - 1];				if (bodyPart.Type != headType || bodyPart.energy < 100)					specialStateTriggered = false;			}						if (specialStateTriggered && !hasSpecialState(headType))				addSpecialState(headType);							//update timeout			var itemsToDelete:Array = [];			for (i = 0; i < SpecialStateTimeOutArray.length; i++)			{				if (gameLogic.TOTAL_RUNNING_TIME >= SpecialStateTimeOutArray[i]){					itemsToDelete.push(i);				}			}						itemsToDelete.sort(Array.NUMERIC|Array.DESCENDING);						for each (i in itemsToDelete)			{				SpecialStateTimeOutArray.splice(i,1);				SpecialStateArray.splice(i,1);			}		}				// "Speed", "Energy", "Absorb"						public function addSpecialState(type:String){			if (GameLogic.ValidType.indexOf(type) == -1)				return;			if (type == "Regular")				return;			if (hasSpecialState(type))				return;			for (var i:int = 0; i < nbOfPartsNeededForSpecialState; i++){				var bodyPart = BodyPartList[BodyPartList.length - i - 1];				bodyPart.Type = "Regular";			}			SpecialStateArray.push(type);			SpecialStateTimeOutArray.push(gameLogic.TOTAL_RUNNING_TIME + specialStateTimeOut);		}				public function hasSpecialState(type:String = ""):Boolean{			if (type == ""){				if (SpecialStateArray.length > 0)					return true;				else					return false;			}			if (SpecialStateArray.indexOf(type) != -1)				return true;			else				return false;		}				public var SpecialStateArray:Array = [];		public var SpecialStateTimeOutArray:Array = [];				private var totalEnergy:int;				private function updateEnergy(){			var bodyPartFound:Boolean = false;			for (var i:int = 0; i<BodyPartList.length; i++){				var bodyPart = BodyPartList[i];				if (bodyPart.energy > 0){					bodyPart.energy -= energyDepleteRatio;					if (bodyPart.energy < 0)						bodyPart.energy = 0;					bodyPartFound = true;					break;				}			}			// All Bodyparts Energy < 0			if (!bodyPartFound)				gameLogic.restart();			else{				totalEnergy = 0;				for each (bodyPart in BodyPartList){					totalEnergy += bodyPart.energy;				}				if (totalEnergy < 100)					State = "EnergyEmpty";				else if (State == "EnergyEmpty")					State = "Normal";								}		}				public static function reset(){			instance = null;		}	}	}