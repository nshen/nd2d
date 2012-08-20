package de.nulldesign.nd2d.effect
{
	import de.nulldesign.nd2d.utils.NumberUtil;
	import de.nulldesign.nd2d.utils.VectorUtil;
	
	import flash.geom.Vector3D;

	public class BurstEmitter extends ParticleEmitterBase
	{
		
		public var minStartPosition:Vector3D = new Vector3D(-5, 0);
		public var maxStartPosition:Vector3D = new Vector3D(5, 0);
		
		public var minSpeed:Number = 100.0;
		public var maxSpeed:Number = 300.0;
		
		public var minEmitAngle:Number = 0.0;
		public var maxEmitAngle:Number = 360.0;
		
		public var startColor:Number = 0xD60606;
		public var startColorVariance:Number = 0xD60606;
		
		public var startAlpha:Number = 1.0;
		public var endAlpha:Number = 0.0;
		
		public var endColor:Number = 0xff0000;
		public var endColorVariance:Number = 0x0000ff;
		
		public var spawnDelay:Number = 10.0;
		
		public var minLife:Number = 1;
		public var maxLife:Number = 3;
		
		public var minStartSizeX:Number = 1.0;
		public var maxStartSizeX:Number = 1.0;
		public var minEndSizeX:Number = 1.0;
		public var maxEndSizeX:Number = 1.0;
		
		public var minStartSizeY:Number = 1.0;
		public var maxStartSizeY:Number = 1.0;
		public var minEndSizeY:Number = 1.0;
		public var maxEndSizeY:Number = 2.0;
		
		public var rotVel : Number = 1;
		public var rotVelVariance : Number = 0;
		
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
		
		
		public function BurstEmitter()
		{
			super();
		}
		
		override public function update(elapsed:Number):void
		{
			if(_particleSystemDirty)
			{
				for each(var p:ParticleExt in _particleSystem.particles)
				{
					presetParticle(p);
				}
				_particleSystemDirty = false
			}
			return;
		}
		
		protected var _particleSystemDirty:Boolean = false;
		override public function set particleSystem(value:ParticleSystemExt):void
		{
			super.particleSystem = value;
			if( value )
			{
				_particleSystemDirty = true;
			}
		}
		
		protected function presetParticle(p:ParticleExt):void
		{
			p.pos.x = NumberUtil.rndMinMax(minStartPosition.x, maxStartPosition.x);
			p.pos.y = NumberUtil.rndMinMax(minStartPosition.y, maxStartPosition.y);
			
			p.vel = NumberUtil.rndMinMax(minSpeed, maxSpeed);
			var angle:Number = NumberUtil.rndMinMax(VectorUtil.deg2rad(minEmitAngle),VectorUtil.deg2rad(maxEmitAngle));
			p.dir.setTo(Math.sin(angle),Math.cos(angle),0);
			p.startColor = startColor + startColorVariance * Math.random();
			p.endColor = endColor + endColorVariance * Math.random();
			p.startAlpha = startAlpha;
			p.endAlpha = endAlpha;
			
			p.startSizeX = p.startSizeY = NumberUtil.rndMinMax(minStartSizeX, maxStartSizeX);
			p.endSizeX = p.endSizeY = NumberUtil.rndMinMax(minEndSizeX, maxEndSizeX);
			
			p.lifeTime  = NumberUtil.rndMinMax(minLife, maxLife);
			p.startTime = _particleSystem.currentTime// + p.lifeTime * Math.random()  //- 4* Math.random()// _preset.spawnDelay * p.index;
			p.rotVel = rotVel + rotVelVariance * Math.random();
			p.rot = 5;
			
			_particleSystem.uploadParticle(p);
		}
		
	}
}