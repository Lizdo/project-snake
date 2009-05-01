﻿package{		//imports	import flash.events.Event;	import flash.events.MouseEvent;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import com.flashdynamix.utils.SWFProfiler;		//[SWF( backgroundColor='0xFFFFFF', frameRate='24', width='480', height='320')]		public class ProjectSnake extends MovieClip {				private static var instance;				private var gameVisual;		private var gameLogic;				private var gridSystem;		private var snake;				private var inputManager;		private var enemyManager;		private var soundManager;				public function ProjectSnake(){			instance = this;			init();			SWFProfiler.init(stage, this);		}				public static function getInstance(){			return instance;		}					public function init(){			gameVisual = GameVisual.getInstance();			gameLogic = GameLogic.getInstance();			gridSystem = GridSystem.getInstance();			snake = Snake.getInstance();			inputManager = InputManager.getInstance();			enemyManager = EnemyManager.getInstance();			soundManager = SoundManager.getInstance();						addChildAt(gameVisual,0);						gridSystem.init();			gameVisual.init();			gameLogic.init();			snake.init();			inputManager.init();			enemyManager.init();			soundManager.playBackGroundMusic();		}				public function restart(){			removeChild(gameVisual);						GridSystem.reset();			GameVisual.reset();			GameLogic.reset();			Snake.reset();			InputManager.reset();			EnemyManager.reset();									init();		}			}		}