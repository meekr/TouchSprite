package
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#000000")]
	public class TouchSprite extends Sprite
	{
		private var mStarling:Starling;
		
		public function TouchSprite()
		{
			// This project requires the sources of the "demo" project. Add them either by 
			// referencing the "demo/src" directory as a "source path", or by copying the files.
			// The "media" folder of this project has to be added to its "source paths" as well, 
			// to make sure the icon and startup images are added to the compiled mobile app.
			
			// set general properties
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = false; // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			
			var viewPort:Rectangle =  new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
			
			
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			
			var startupBitmap:Bitmap = new AssetEmbeds_1x.SplashScreen();
			startupBitmap.x = viewPort.x;
			startupBitmap.y = viewPort.y;
			startupBitmap.width  = viewPort.width;
			startupBitmap.height = viewPort.height;
			startupBitmap.smoothing = true;
			addChild(startupBitmap);
			
			// launch Starling
			
			mStarling = new Starling(Game, stage, viewPort);
			mStarling.simulateMultitouch  = true;
			mStarling.enableErrorChecking = false;
			
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
			{
				// Starling is ready! We remove the startup image and start the game.
				removeChild(startupBitmap);
				mStarling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, 
				function (e:Event):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, 
				function (e:Event):void { mStarling.stop(); });
		}
	}
}