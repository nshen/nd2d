package de.nulldesign.nd2d.effect.affector
{
	public class SizeAffector extends AffectorBase
	{
		private var _sizeAffectorVect43:Vector.<Number> = new <Number>[]; //[x,y,0,lifePercent]
		
		public function SizeAffector()
		{
			super();
		}
		
		public function addKeyFrame(lifePercent:Number, x:Number , y:Number) : void
		{
			if(_sizeAffectorVect43.length >= GPU_MAX_FRAMES * 4)
				return ;
			
			if(lifePercent < 0) lifePercent = 0;
			if(lifePercent > 1) lifePercent = 1;
			
			var i:int = 0;
			while(i<_sizeAffectorVect43.length && lifePercent > _sizeAffectorVect43[i+3])
			{
				i+=4;
			}
			_sizeAffectorVect43.splice(i, 0, x,y,0,lifePercent);
		}
		
		public function get keyframeCount():int
		{
			return int(_sizeAffectorVect43.length/4) ; 
		}
		
		public function get bufferData():Vector.<Number>
		{
			return _sizeAffectorVect43;
		}
	}
	
	
}