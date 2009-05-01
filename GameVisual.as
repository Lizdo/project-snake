﻿package {	//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import fl.transitions.Tween;	import fl.transitions.easing.*;	import fl.transitions.TweenEvent;		import flash.geom.ColorTransform;	import flash.utils.getDefinitionByName;			public class GameVisual extends MovieClip {				private static  var instance:GameVisual;						public static function getInstance():GameVisual {			if (instance == null) {				instance = new GameVisual();			}			return instance;		}				public function GameVisual(){		}				public var background:Background = new Background();		public var gridSystem;		public var snake;		public var enemyManager;		public var gameLogic;				public function init(){			addChild(background);						gridSystem = GridSystem.getInstance();			addChild(gridSystem);						snake = Snake.getInstance();			addChild(snake);						enemyManager = EnemyManager.getInstance();			addChild(enemyManager);						background.init();			gameLogic = GameLogic.getInstance();		}						public function update(){			for each (var array in GridSystem.GridArray)				for each (var g in array)					g.updateVisual();			snake.updateVisual();			enemyManager.updateVisual();		}				public function updateBackground(time:Number){			background.update(time);			if (gameLogic.State == "State_Combo" && gameLogic.nextCombo != ""){				background.setColor(getColorByType(gameLogic.nextCombo));				background.setComboNumber(gameLogic.comboCollected);			}else if(gameLogic.State == "State_Combo"){				//don't update the color if a combo is just picked up				background.setComboNumber(gameLogic.comboCollected);							}else{				background.setColor();				background.setComboNumber(0);							}					}				var victoryStarted:Boolean = false;		var victoryTween;				public function victory(){			if (!victoryStarted){				victoryTween = new Tween(this, "alpha", Regular.easeIn, 1, 0, 10, true);				victoryTween.start();				victoryStarted = true;			}		}						////////////////////////////////		///		Common functions		////////////////////////////////						public static function getColorByType(Type:String):int{			switch (Type){				case "Speed":					return themeArray[0];				case "Energy":					return themeArray[1];				case "Absorb":					return themeArray[4];				default:					return themeArray[2];			}			return		}						//warm		//DED322,44AB36,247278,B88421,AB2F22		//Yellow,Green,Blue , ,Red				//B25438,998A51,C9BC7C,D6D3AB,94B5AA				private static var themeArray:Array = [0x776045, 0xA8C545, 0xDFD3B6, 0xFFFFFF, 0x0092B2];						public static function safelyRemove(obj, objContainer){			var container = objContainer;			if (obj!=null)				if (container.contains(obj))					container.removeChild(obj);		}						public static function blendColorWithBlack(color:Number, ratio:Number):Number{			var R:Number = color >> 16 & 0xFF;			var G:Number = color >> 8  & 0xFF;			var B:Number = color & 0xFF;			R *= ratio;			G *= ratio;			B *= ratio;			var colorRBG:uint = (R << 16 | G << 8 | B);			return colorRBG;		}				private var AbilitySymbol;		private var abilitySymbolTween:Tween;		private var currentDisplayedAbility:String = "";		private var abilityInEffect:Boolean = false;				public function showAbilitySymbol(ability:String, inEffect:Boolean = false){			if (ability == "Regular")				return;						if (currentDisplayedAbility == ability && !needRedraw(inEffect)){				if (abilitySymbolTimer){					abilitySymbolTimer.reset();					abilitySymbolTimer.start();				}				return;			}						if (abilityInEffect)				return;						currentDisplayedAbility = ability;							safelyRemove(AbilitySymbol, background);						if (inEffect){				var symbolColor:int = getColorByType(ability);				var finalAlpha:Number = 0.8;				abilityInEffect = true;			}else{				symbolColor = 0xEEEEEE;				finalAlpha = 0.6;				abilityInEffect = false;			}									AbilitySymbol = new (getDefinitionByName("Symbol_"+ ability) as Class)();			background.addChild(AbilitySymbol);			AbilitySymbol.x = 10;			AbilitySymbol.y = 10;			AbilitySymbol.width = AbilitySymbol.height = 60;						var color:ColorTransform = AbilitySymbol.transform.colorTransform;			color.color = symbolColor;			AbilitySymbol.transform.colorTransform = color;									abilitySymbolTween = new Tween(AbilitySymbol, "alpha", Regular.easeIn, 0, finalAlpha, 0.2, true);			abilitySymbolTween.start();			abilitySymbolTween.addEventListener(TweenEvent.MOTION_FINISH, abilitySymbolTweenCompleted);		}				private function needRedraw(inEffect):Boolean{			if (inEffect && !abilityInEffect)				return true;			if (!inEffect)				return false;			if (inEffect && abilityInEffect)				return false;			return false;		}				private var abilitySymbolTimer:Timer;				private function abilitySymbolTweenCompleted(e:Event){			abilitySymbolTimer = new Timer(1000,1);			abilitySymbolTimer.start();			abilitySymbolTimer.addEventListener(TimerEvent.TIMER_COMPLETE, abilitySymbolTimerCompleted);		}				private function abilitySymbolTimerCompleted(e:TimerEvent){			safelyRemove(AbilitySymbol, background);			currentDisplayedAbility = "";			abilityInEffect = false;		}						public static function reset(){			instance = null;		}			}}