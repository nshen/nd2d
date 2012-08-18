package de.nulldesign.nd2d.effect
{
	
	import flash.geom.Vector3D;
	
	public class RectEmitter extends ParticleEmitterBase
	{
		
		public var lifeTime:int = 2;
		public var lifeTimeRange:int = 0;
		public var color:uint = 0xffffff;
		public var colorRange:uint = 0x000000;
		public var alpha:Number = 1;
		public var alphaRange:Number = 0;
		public var sizeX:Number = 10;
		public var sizeY:Number = 10;
		public var sizeRange:Number = 0;
		public var directionFrom:Vector3D = new Vector3D(0,1,0);
		public var directionTo:Vector3D = new Vector3D(0,1,0);
		public var vel:int = 100;
		public var velRange:int = 0;
		public var rot:Number = 0;
		public var rotRange:Number = 0;
		public var rotVel:Number = 1;
		public var rotVelRange:Number = 0;
		public var rectFrom:Vector3D = new Vector3D(-100,-100,0);
		public var rectTo:Vector3D = new Vector3D(100,100,0);
		
		public function RectEmitter()
		{
			super();
		} 
		
		override protected function initParticle(newParticle:ParticleExt):void
		{ 
//			newParticle.color = color + colorRange * Math.random();
			newParticle.startColor = 0xff0000;
			newParticle.endColor = 0x0000ff;
			newParticle.alpha = alpha + alphaRange * Math.random();
//			newParticle.startAlpha = 1;
//			newParticle.endAlpha = 0;
			newParticle.lifeTime = lifeTime + lifeTimeRange * Math.random();
			newParticle.dir.x = directionFrom.x * Math.random() + directionTo.x * Math.random();
			newParticle.dir.y = directionFrom.y * Math.random() + directionTo.y * Math.random();
//			newParticle.dir.z = directionFrom.z * Math.random() + directionTo.z * Math.random();
			newParticle.dir.normalize();
			newParticle.vel = vel + velRange * Math.random();
			var sizeRand : Number = sizeRange * Math.random();
			newParticle.startSizeX = newParticle.endSizeX = sizeX + sizeRand;
			newParticle.startSizeY = newParticle.endSizeY = sizeY + sizeRand;
			newParticle.rot = rot +  rotRange * Math.random();
			newParticle.rotVel = rotVel + rotVelRange * Math.random();
			
			newParticle.pos.x += (rectTo.x - rectFrom.x) * Math.random() + rectFrom.x;
			newParticle.pos.y += (rectTo.y - rectFrom.y) * Math.random() + rectFrom.y;
//			newParticle.pos.z += (EmitterRectTo.z - EmitterRectFrom.z) * Math.random() + EmitterRectFrom.z;
			
			newParticle.startTime = _particleSystem.currentTime;
		}
	}
}