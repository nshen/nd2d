package de.nulldesign.nd2d.effect.modifier
{
	import de.nulldesign.nd2d.effect.ParticleExt;
	import de.nulldesign.nd2d.effect.ParticleSystemExtMaterial;
	
	public class ColorModifier extends ModifierBase
	{
		protected var _colorVector:Vector.<Number>; //[lifepercent,r,g,b]
		
		public function ColorModifier()
		{
			_colorVector = new Vector.<Number>;
		}
		
		public function addKeyFrame(lifePercent:Number, r:Number , g:Number , b:Number) : void
		{
			if(lifePercent < 0) lifePercent = 0;
			if(lifePercent > 1) lifePercent = 1;
			
			var i:int = 0;
			while(i < _colorVector.length && lifePercent > _colorVector[i])
			{
				i+=4;
			}
			_colorVector.splice(i,0,lifePercent, r, g, b);
		}
		
		public function get keyframeCount():int
		{
			return int(_colorVector.length/4) ; 
		}
		
		override public function modify(particle:ParticleExt, particleLifePercent:Number, material:ParticleSystemExtMaterial):void
		{
			
			if(_colorVector.length > 4)
			{
				var f1Percent:Number ,f2Percent:Number;
				var fi1:uint = 0 ;
				var fi2:uint = fi1 + 4;
				while(fi2 < _colorVector.length)
				{
					
					f1Percent = _colorVector[fi1];
					f2Percent = _colorVector[fi2];
					if(particleLifePercent >= f1Percent && particleLifePercent < f2Percent)
					{
						material.upadteParticleColor(
							particle.index,
							_colorVector[fi1+1],_colorVector[fi1+2],_colorVector[fi1+3],
							_colorVector[fi2+1] , _colorVector[fi2+2] , _colorVector[fi2+3],
							f1Percent,f2Percent
						)
						break ;
					}
					fi1 = fi2;
					fi2 = fi1 + 4;
				}
				
			}
		}
		
	}
}