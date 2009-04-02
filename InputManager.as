﻿package {	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	public class InputManager {		private static var instance:InputManager;		public static function getInstance():InputManager {			if (instance == null)			{				instance = new InputManager  ;			}			return instance;		}		public function InputManager() {		}		private var gameLogic:GameLogic;		public function init(){			GameVisual.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyboardEvent);			gameLogic = GameLogic.getInstance();		}		public function onKeyboardEvent(e:KeyboardEvent):void {			switch (e.keyCode)			{				case Keyboard.UP:					gameLogic.Input = "UP";					break;				case Keyboard.DOWN:					gameLogic.Input = "DOWN";					break;				case Keyboard.LEFT:					gameLogic.Input = "LEFT";					break;				case Keyboard.RIGHT:					gameLogic.Input = "RIGHT";					break;			}			trace(gameLogic.Input);		}				public static function reset(){			instance = null;		}	}}