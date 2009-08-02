﻿package {	import flash.events.*;		import flash.system.Security;		import flash.display.Sprite;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.display.MovieClip;	import flash.display.Loader;		import flash.external.ExternalInterface;	public class Uploader extends Sprite {		private var button:Sprite;		private var browser:FilesBrowser;		private var queue:FilesQueue;				private var callback:String;		public var options:Object = {			callback:			null,			url:				null,			data:				null,			fileName:			'file',			timeLimit:			0,			minSize:			0,			maxSize:			0,			types:				null,			allowDuplicates:	false,			trace:				false		};				public function Uploader():void {			ExternalInterface.addCallback('initialize', initialize);						notify('initialized');		}				public function initialize(given:Object = null):void {			Security.allowDomain("*");						if (given != null){				for(var name:String in given){					if (options.hasOwnProperty(name)){						options[name] = given[name];					}				}			}						button 					= new Sprite();			button.x 				= 0;			button.y				= 0;			button.buttonMode 		= true;			button.useHandCursor	= true;			button.graphics.beginFill(0xFFFFFF, 0);			button.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);			button.graphics.endFill();						stage.align		= StageAlign.TOP_LEFT;			stage.scaleMode = StageScaleMode.NO_SCALE;			stage.addChild(button);						queue	= new FilesQueue(this);			browser = new FilesBrowser(queue);						stage.addEventListener(MouseEvent.CLICK, 		browser.browse);			stage.addEventListener(MouseEvent.MOUSE_OVER,	handleMouseEvent);			stage.addEventListener(MouseEvent.MOUSE_OUT,	handleMouseEvent);			stage.addEventListener(MouseEvent.MOUSE_DOWN,	handleMouseEvent);			stage.addEventListener(MouseEvent.MOUSE_UP,		handleMouseEvent);			stage.addEventListener(Event.RESIZE, 			handleResize);						ExternalInterface.addCallback('start',  queue.start);			ExternalInterface.addCallback('remove', queue.remove);			ExternalInterface.addCallback('stop',	queue.stop);		}						public function notify(name:String, data:Object = null):void {			//trace(name + " " + Utils.d(data));						if (options.trace){				ExternalInterface.call('console.log', 'event: ' + name, Utils.escape(data));			}						ExternalInterface.call(loaderInfo.parameters.callback, name, Utils.escape(data));		}				private function handleMouseEvent(e:MouseEvent):void {			notify(e.type.toLowerCase());		}				private function handleResize(e:Event):void {			button.width  = stage.stageWidth;			button.height = stage.stageHeight;		}	}}