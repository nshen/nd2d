package de.nulldesign.nd2d.effect
{
	import flash.geom.Point;

	public class ParticleSystemExtPreset
	{
		public function ParticleSystemExtPreset()
		{
		}
		public var minStartPosition:Point = new Point(-5.0, 0.0);
		public var maxStartPosition:Point = new Point(5.0, 0.0);
		
		public var minSpeed:Number = 100.0;
		public var maxSpeed:Number = 300.0;
		
		public var minEmitAngle:Number = 0.0;
		public var maxEmitAngle:Number = 360.0;
		
		public var startColor:Number = 0xD60606;
		public var startColorVariance:Number = 0xD60606;
		
		public var startAlpha:Number = 1.0;
		
		public var endColor:Number = 0xF9D101;
		public var endColorVariance:Number = 0xF9D101;
		
		public var endAlpha:Number = 0.0;
		
		public var spawnDelay:Number = 10.0;
		
		public var minLife:Number = 2000.0;
		public var maxLife:Number = 3000.0;
		
		public var minStartSizeX:Number = 1.0;
		public var maxStartSizeX:Number = 1.0;
		public var minEndSizeX:Number = 1.0;
		public var maxEndSizeX:Number = 2.0;
		
		public var minStartSizeY:Number = 1.0;
		public var maxStartSizeY:Number = 1.0;
		public var minEndSizeY:Number = 1.0;
		public var maxEndSizeY:Number = 2.0;
		
		public var rotVel : Number = 1;
		public var rotVelRange : Number = 0;
		
		public function set minStartSize(value:Number):void
		{
			minStartSizeX = minStartSizeY = value;
		}
		public function set maxStartSize(v:Number):void
		{
			maxStartSizeX = maxStartSizeY = v;
		}
		public function set minEndSize(v:Number):void
		{
			minEndSizeX = minEndSizeY = v;
		}
		public function set maxEndSize(v:Number):void
		{
			maxEndSizeX = maxEndSizeY = v;
		}
		
	}
}