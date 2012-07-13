package 
{
    import flash.events.Event;
    import flash.geom.Point;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import starling.core.Starling;
    import starling.display.BlendMode;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.KeyboardEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.VAlign;
    import starling.utils.deg2rad;
    
    public class Game extends Sprite
    {
		private var mCircles:Dictionary;
		private var mTouchIds:Array;
		private var mRecPattern:RecPattern;
		private var mTip:TextField;
		private var mPatternGround:TextField;
		private var mRecConfig:XML;
		
        public function Game()
        {
			Starling.current.stage.stageWidth  = 1024;
			Starling.current.stage.stageHeight = 768;
			Assets.contentScaleFactor = Starling.current.contentScaleFactor;
			
			mCircles = new Dictionary();
			mTouchIds = new Array();
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
			
			mTip = new TextField(1024, 50, "在屏幕上放置数字积木吧^_^", "Verdana", 20, 0x000000);
			mTip.x = mTip.y = 0;
			mTip.hAlign = "center";
			addChild(mTip);
			
			mPatternGround = new TextField(400, 400, "", "Verdana", 500, 0x000000);
			mPatternGround.hAlign = "center";
			mPatternGround.alpha = 0.6;
			addChild(mPatternGround);
			
			Starling.current.stage.color = 0x00ff00;
			
			// recognization
			loadConfig();
        }
		
		private function loadConfig():void
		{
			mRecConfig = new XML();
			var xmlURL:URLRequest = new URLRequest("config.xml");
			var xmlLoader:URLLoader = new URLLoader(xmlURL);
			xmlLoader.addEventListener(Event.COMPLETE, function(event:Event):void{
				mRecConfig = XML(xmlLoader.data);
				trace(mRecConfig);
			});
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch;
			var circle:Image;
			var touches:Vector.<Touch> = event.getTouches(Starling.current.stage);
			for each (touch in touches)
			{
				if (touch.phase == TouchPhase.BEGAN)
				{
					var cir:Image = new Image(Assets.getTexture("Circle"));
					cir.pivotX = cir.width / 2;
					cir.pivotY = cir.height / 2;
					addChild(cir);
					
					mCircles[touch.id] = cir;
				}
				
				circle = mCircles[touch.id] as Image;
				if (circle == null) continue;
				
				circle.x = touch.getLocation(Starling.current.stage).x;
				circle.y = touch.getLocation(Starling.current.stage).y;
				
				mTouchIds.push(touch.id);
			}
			
			// pattern recognition
			if (touches.length == 3)
			{
				if (mRecPattern == null || !mRecPattern.matched)
				{
					mRecPattern = new RecPattern(touches, mRecConfig);
					mTip.text = "Base distance:"+mRecPattern.baselineDistance+", 3rd point to base distance:"+mRecPattern.distanceFrom3rdPointToBaselineCenter;
					mPatternGround.text = mRecPattern.matchedPattern;
				}
				
				if (mRecPattern.matched)
				{
					for each (touch in touches)
					{
						if (touch.id == mRecPattern.touchId4CornerA)
						{
							mRecPattern.cornerA = touch.getLocation(Starling.current.stage);
							break;
						}
					}
					mPatternGround.x = mRecPattern.cornerA.x;
					mPatternGround.y = mRecPattern.cornerA.y;
					mPatternGround.pivotX = mRecPattern.pivot.x;
					mPatternGround.pivotY = mRecPattern.pivot.y;
				}
			}
			
			// terminate pattern
			for each (touch in touches)
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					circle = mCircles[touch.id] as Image;
					if (circle)
					{
						circle.removeFromParent(true);
						circle = null;
					}
					
					delete mCircles[touch.id];
					if (mTouchIds.indexOf(touch.id) > -1)
					{
						mTouchIds.splice(mTouchIds.indexOf(touch.id), 1);
						mRecPattern = null;
					}
					
					mTip.text = "在屏幕上放置数字积木吧^_^";
					mPatternGround.text = "";
				}
			}
		}
		
		public override function dispose():void
		{
			Starling.current.stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			super.dispose();
		}
    }
}