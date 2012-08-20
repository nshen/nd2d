package de.nulldesign.nd2d.effect.modifier
{
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
	}
}