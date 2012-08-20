package de.nulldesign.nd2d.effect.modifier
{
	import de.nulldesign.nd2d.effect.ParticleExt;
	import de.nulldesign.nd2d.effect.ParticleSystemExtMaterial;

	public class AlphaModifier extends ModifierBase
	{
		public var _alphaVector:Vector.<Number>; //[lifePercent,a,0,0]
		
		public function AlphaModifier()
		{
			_alphaVector  = new Vector.<Number>();
		}
		
		public function addKeyFrame(lifePercent:Number, a:int) : void
		{
	
			if(lifePercent < 0) lifePercent = 0;
			if(lifePercent > 1) lifePercent = 1;
			
			var i:int = 0;
			while(i<_alphaVector.length && lifePercent > _alphaVector[i])
			{
				i+=4;
			}
			_alphaVector.splice(i, 0, lifePercent,a,0,0);
		}
		
		public function get keyframeCount():int
		{
			return int(_alphaVector.length/4) ; 
		}
		
		override public function modify(particle:ParticleExt, particleLifePercent:Number, material:ParticleSystemExtMaterial):void
		{
			if(_alphaVector.length > 4)
			{
				var fi1:uint = 0 ;
				var fi2:uint = fi1 + 4;
				var f1Percent:Number , f2Percent:Number;
				while(fi2 < _alphaVector.length)
				{
					
					f1Percent = _alphaVector[fi1];
					f2Percent = _alphaVector[fi2];
					if((particle.startAlphaPercent != f1Percent || particle.endAlphaPercent != f2Percent) && particleLifePercent >= f1Percent && particleLifePercent < f2Percent)
					{
						particle.startAlpha = _alphaVector[fi1+1];
						particle.endAlpha = _alphaVector[fi2+1];
						particle.startAlphaPercent = f1Percent;
						particle.endAlphaPercent = f2Percent;
						material.updateParticleAlpha(particle);
						break ;
					}
					fi1 = fi2;
					fi2 = fi1 + 4;
				}
			}
		}
	}
}