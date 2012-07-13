package utils
{
	public class Vector_2D{
		
		public var x:Number = 0;
		public var y:Number = 0;
		public function Vector_2D(px:Number = 0, py:Number = 0) {
			x = px;
			y = py;
		}        
		
		public function clone():Vector_2D {
			return new Vector_2D(this.x,this.y);
		}
		/**
		 计算自身和矢量v点乘
		 */
		public function dot(v:Vector_2D):Number {
			return x * v.x + y * v.y;
		}
		/**
		 计算自身和矢量v点乘后的新矢量
		 */
		public function dotNew(v:Vector_2D):Vector_2D {
			return new Vector_2D(x * v.x, y * v.y);
		}
		/**
		 计算自身和矢量v的叉乘(按照右手定则)
		 @return        返回值顺时针为正，逆时针为负, 等于0表示完两矢量夹角为180/0度
		 */
		public function cross(v:Vector_2D):Number {
			
			return x * v.y - y * v.x;
		}
		/**
		 计算自身和矢量v点乘的合
		 */
		public function plus(v:Vector_2D):void {
			x += v.x;
			y += v.y;
		}
		public function plusNew(v:Vector_2D):Vector_2D {
			return new Vector_2D(x + v.x, y + v.y); 
		}
		/**
		 计算自身和矢量v点乘的差
		 */
		public function minus(v:Vector_2D):void {
			x -= v.x;
			y -= v.y;
		}
		
		public function minusNew(v:Vector_2D):Vector_2D {
			return new Vector_2D(x - v.x, y - v.y);    
		}
		/**
		 计算自身和矢量标量s的乘积
		 */
		public function mult(s:Number):void {
			x *= s;
			y *= s;
		}
		public function multNew(s:Number):Vector_2D {
			return new Vector_2D(x * s, y * s);
		}
		/**
		 计算自身除以s
		 */
		public function divide(s:Number):void{
			if(s<=0.00001){
				trace("分母不能为零");
			}else{
				x /= s;
				y /= s;
			}            
		}
		public function divideNew(s:Number):Vector_2D{
			if(s<=0){
				trace("分母不能为零");
			}else{
				return new Vector_2D(x/s,y/s);
			}
			return clone();
		}
		/**
		 判断自己和矢量v是否相同
		 @param            v 用于和自己做比较的矢量
		 @return            返回true表示相同，否则就不同
		 */
		public function equals(v:Vector_2D):Boolean {
			/**
			 判断自己是否与矢量v相等
			 */
			if(this.x == v.x && this.y == v.y){
				return true;
			}
			return false;
		}
		public function distance(v:Vector_2D):Number {
			var dx:Number = x - v.x;
			var dy:Number = y - v.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		//规范化(或单位化),得到和自身方向相同的单位矢量
		public function normalize():Vector_2D {
			var mag:Number = Math.sqrt(x * x + y * y);
			if(mag<=0){
				x = 0;
				y = 0;
				trace("Error:publicOrg.vily.primitives.Vector_2D::normalize()零矢量不能规范化");
				return this;
			}
			x /= mag;
			y /= mag;
			return this;
		}
		/**
		 计算幅 , 模, 自身的值表示的点到原点连线的长度
		 */
		public function magnitude():Number {
			return Math.sqrt(x * x + y * y);
		}
		/**
		 计算自身的模的平方值
		 */
		public function squareMagnitude():Number {            
			return (x * x + y * y);
		}
		/**
		 *     计算自己在任意矢量v上的投影
		 *    @param        v 为任意矢量
		 *    @return        返回自身的投影的矢量
		 */
		public function project(v:Vector_2D):Vector_2D {
			//计算自己在 b到原点连线 上的射影的新矢量
			var adotb:Number = this.dot(v);
			var len:Number = (v.x * v.x + v.y * v.y);
			
			var proj:Vector_2D = new Vector_2D(0,0);
			proj.x = (adotb / len) * v.x;
			proj.y = (adotb / len) * v.y;
			return proj;
		}
		/**
		 *     计算自己在单位矢量n上的投影
		 *    @param        n 单位矢量
		 */
		public function projectN(n:Vector_2D):void {
			//计算自己在 n -- 单位向量到原点连线 上的射影的新矢量
			var adotb:Number = this.dot(n);
			this.x = n.x * adotb;
			this.y = n.y * adotb;
		}        
		/**
		 @return        返回自身的值表示的点和原点的连线 与 水平向右的x轴之间夹角的弧度值(0 -> 2*PI)
		 */
		public function getRadian():Number{
			//返回相对于(start_x,start_y)点的角度的弧度值
			//计算现在位置变化后的方向弧度值
			var radians:Number = Math.atan(y/x);
			if(isNaN(radians)){
				return Math.PI/2;
			}
			if(y>=0 && x>=0){
				return radians;
			}else if(y<0 && x>=0){
				radians = 2*Math.PI+radians;
				return radians;
			}else{
				radians = Math.PI+radians;
				return radians;
			}
		}
		/**
		 @return        返回自身的值表示的点和原点的连线 与 水平向右的x轴之间夹角的角度值(0 -> 360)
		 */
		public function getAngle():Number{
			//返回相对于(start_x,start_y)点的角度
			//计算现在位置变化后的方向角度值
			var angle:Number = Math.atan(y/x) * 180/Math.PI;    
			if(y>=0 && x>=0){         
				return Math.round(angle);
			}else if(y<0 && x>=0){
				return Math.round(360+angle);
			}else{        
				return Math.round(180+angle);    
			}
		}
		public function toString():String{
			return "x: "+ x+"  y: "+y;
		}
	}
}