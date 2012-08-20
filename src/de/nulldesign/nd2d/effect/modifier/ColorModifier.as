package de.nulldesign.nd2d.effect.modifier
{
	public class ColorModifier extends ModifierBase
	{
		public var _colorVector:Vector.<Number>; //[lifepercent,r,g,b]
		
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
		
	}
}