package de.nulldesign.nd2d.effect.affector
{
	public class AlphaAffector extends AffectorBase
	{
		private var _alphaEffectorVect43:Vector.<Number>; //[a,0,0,lifePercent]
		
		public function AlphaAffector()
		{
			_alphaEffectorVect43  = new Vector.<Number>();
		}
		
		public function addKeyFrame(lifePercent:Number, a:int) : void
		{
		    if(keyframeCount >= GPU_MAX_FRAMES)
				return ;
			
			if(lifePercent < 0) lifePercent = 0;
			if(lifePercent > 1) lifePercent = 1;
			
			var i:int = 0;
			while(i<_alphaEffectorVect43.length && lifePercent > _alphaEffectorVect43[i+3])
			{
				i+=4;
			}
			_alphaEffectorVect43.splice(i, 0, a,0,0,lifePercent);
		}
		
		public function get keyframeCount():int
		{
			return int(_alphaEffectorVect43.length/4) ; 
		}
		
		public function get bufferData():Vector.<Number>
		{
			return _alphaEffectorVect43;
		}
		
	}
}