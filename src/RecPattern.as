package
{
	import flash.display3D.IndexBuffer3D;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.events.Touch;
	
	import utils.Vector_2D;

	public class RecPattern
	{
		private var mThreshold:Number = 6;
		private var mMatched:Boolean;
		private var mMatchedPattern:String = "";
		private var mPatternRule:XML;
		private var mTouchId4CornerA:int;
		private var mTouchId4CornerB:int;
		
		public function RecPattern(touches:Vector.<Touch>, patternRules:XML)
		{
			if (touches.length == 3)
			{
				var pointA:Point = touches[0].getLocation(Starling.current.stage);
				var pointB:Point = touches[1].getLocation(Starling.current.stage);
				var pointC:Point = touches[2].getLocation(Starling.current.stage);
				var distAB:int = getDistance(pointA, pointB);
				var distAC:int = getDistance(pointA, pointC);
				var distBC:int = getDistance(pointB, pointC);
				
				var baseline:int = Math.min(distAB, distAC, distBC);
				var pointMiddle:Point, pointTop:Point;
				if (baseline == distAB)
				{
					pointMiddle = new Point(pointA.x + (pointB.x-pointA.x)/2, pointA.y + (pointB.y-pointA.y)/2);
					pointTop = pointC;
				}
				else if (baseline == distAC)
				{
					pointMiddle = new Point(pointA.x + (pointC.x-pointA.x)/2, pointA.y + (pointC.y-pointA.y)/2);
					pointTop = pointB;
					pointB = pointC;
				}
				else if (baseline == distBC)
				{
					pointMiddle = new Point(pointC.x + (pointB.x-pointC.x)/2, pointC.y + (pointB.y-pointC.y)/2);
					pointTop = pointA;
					pointA = pointC;
				}
				var vertline:int = getDistance(pointMiddle, pointTop);
				
				// iterate patterns config xml
				for (var i:int=0; i<patternRules.descendants("Rec").length(); i++)
				{
					var rec:XML = patternRules.descendants("Rec")[i];
					var base:int = int(rec.@base);
					var distance:int = int(rec.@distance);
					if (Math.abs(base - baseline) < mThreshold &&
						Math.abs(vertline - distance) < mThreshold)
					{
						mPatternRule = rec;
						mMatched = true;
						mMatchedPattern = rec.toString();
						
						var ps:String = rec.@pivot;
						this.pivot = new Point( int(ps.substr(0, ps.indexOf(","))), int(ps.substr(ps.indexOf(",")+1)) );
						
						// to make clockwise points
						cornerC = pointTop;
						var vectorAC:Vector_2D = new Vector_2D(cornerC.x - pointA.x, cornerC.y - pointA.y);
						var vectorAB:Vector_2D = new Vector_2D(pointB.x - pointA.x, pointB.y - pointA.y);
						// if cross greater than 0, counter clockwise, else clockwize
						if (vectorAC.cross(vectorAB) < 0)
						{
							cornerA = pointA;
							cornerB = pointB;
						}
						else
						{
							cornerA = pointB;
							cornerB = pointA;
						}
						
						for each (var touch:Touch in touches)
						{
							if (cornerA.equals(touch.getLocation(Starling.current.stage)))
							{
								mTouchId4CornerA = touch.id;
							}
							else if (cornerB.equals(touch.getLocation(Starling.current.stage)))
							{
								mTouchId4CornerB = touch.id;
							}
						}
						
						break;
					}
				}
				
				if (!mMatched)
				{
					cornerC = pointTop;
					cornerA = pointA;
					cornerB = pointB;
				}
			}
		}
		
		private function getDistance(point1:Point, point2:Point):int
		{
			var dx:int = Math.abs(point1.x - point2.x);
			var dy:int = Math.abs(point1.y - point2.y);
			return Math.sqrt(dx*dx + dy*dy);
		}
		
		// A, B, C points, clockwise
		public var cornerA:Point;
		public var cornerB:Point;
		public var cornerC:Point;
		
		// offset from 1st point to origin
		public var pivot:Point;
		
		// in degrees
		public function get angle():Number
		{
			return Math.atan2(cornerB.y-cornerA.y, cornerB.x-cornerA.x);
		}
		
		public function get touchId4CornerA():int
		{
			return mTouchId4CornerA;
		}
		
		public function get touchId4CornerB():int
		{
			return mTouchId4CornerB;
		}
		
		public function get matched():Boolean
		{
			return mMatched;
		}
		
		public function get matchedPattern():String
		{
			return mMatchedPattern;
		}
		
		public function get baselineDistance():Number
		{
			return getDistance(cornerA, cornerB);
		}
		
		public function get distanceFrom3rdPointToBaselineCenter():Number
		{
			var pointMiddle:Point = new Point(cornerA.x + (cornerB.x-cornerA.x)/2, cornerA.y + (cornerB.y-cornerA.y)/2);
			return getDistance(cornerC, pointMiddle);
		}
	}
}