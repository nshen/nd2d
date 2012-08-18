package de.nulldesign.nd2d.effect
{
	import flash.geom.Vector3D;

	public class ParticleExt
	{
		public var index : int;
		
		public var pos : Vector3D = new Vector3D;
		public var dir : Vector3D = new Vector3D;
		public var vel : Number = 0;
		
		public var rot : Number = 0;
		public var rotVel : Number = 0;
		
		public var startColor:uint = 0xffffff;
		public var endColor:uint = 0xffffff;
		public var startColorPercent:Number = 0 ;
		public var endColorPercent:Number = 1;
		
		public var startAlpha:Number = 1;
		public var endAlpha:Number = 1;
		
//		public var u : Number = 0.0;
//		public var v : Number = 0.0;
//		public var su : Number = 1.0;
//		public var sv : Number = 1.0;
		
		public var startTime:Number = 0 ;
		public var lifeTime:Number = 0 ;
		
		public var startSizeX:Number = 0;
		public var startSizeY:Number = 0;
		public var endSizeX:Number = 0;
		public var endSizeY:Number = 0;
		
		public function ParticleExt(index:int)
		{
			this.index = index;
		}
		
		public function set color(value:Number):void
		{
			startColor = endColor = value;
		}
		public function set size(value:Number):void
		{
			startSizeX = startSizeY = endSizeX = endSizeY = value;
		}
		public function set alpha(value:Number):void
		{
			startAlpha = endAlpha = value;
		}
		
		public function get startR():Number
		{
			return ((startColor & 0xff0000) >> 16) / 0xff;
		}
		public function get startG():Number
		{
			return ((startColor & 0x00ff00) >> 8) / 0xff;
		}
		public function get startB():Number
		{
			return (startColor & 0x0000ff) / 0xff;
		}
		
		public function get endR():Number
		{
			return ((endColor & 0xff0000) >> 16) / 0xff;
		}
		public function get endG():Number
		{
			return ((endColor & 0x00ff00) >> 8) / 0xff;
		}
		public function get endB():Number
		{
			return (endColor & 0x0000ff) / 0xff;
		}
		
		public function reset():ParticleExt
		{
			startTime = 0;
			lifeTime = 0;
			
			color = 0xffffff;
			alpha = 1;
			size = 1;
			vel = 0;
			rot = 0;
			rotVel = 0;
//			u = 0;
//			v = 0;
			pos.setTo(0,0,0);
			dir.setTo(0,1,0);
			return this;
		}
		
//		public function set remainTime(value : int) : void
//		{
//			_remainTime = value;
//			pastTime = 0;
//		}
//		public function get remainTime() : int {return _remainTime;}
//		public function isDead() : Boolean {return _remainTime <= 0 && !noDead ; } 
//		public function die() : void { pastTime += _remainTime; _remainTime = 0; noDead = false; }
		
		public function update(elapsed:Number) : void
		{
//			_remainTime -= elapsed;
//			pastTime += elapsed;
//			if(noDead && _remainTime<=0)
//			{
//				_remainTime = pastTime + _remainTime;
//				pastTime = 0;
//			}
		}
	}
}