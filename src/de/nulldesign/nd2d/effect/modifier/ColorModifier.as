/*
* ND2D - A Flash Molehill GPU accelerated 2D engine
*
* Author: Lars Gerckens
* Copyright (c) nulldesign 2011
* Repository URL: http://github.com/nulldesign/nd2d
* Getting started: https://github.com/nulldesign/nd2d/wiki
*
* ParticleExt system by Nshen 
* nshen121@gmail.com
* Working progress or Chinese documents see: http://www.nshen.net/effector.html 
*
*
* Licence Agreement
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
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
			
			if(haveFrames())
			{
				var f1Percent:Number ,f2Percent:Number;
				var fi1:uint = 0 ;
				var fi2:uint = fi1 + 4;
				while(fi2 < _colorVector.length)
				{
					f1Percent = _colorVector[fi1];
					f2Percent = _colorVector[fi2];
					if((particle.startColorPercent != f1Percent || particle.endColorPercent != f2Percent) && particleLifePercent >= f1Percent && particleLifePercent < f2Percent)
					{
						particle.startColorPercent = f1Percent;
						particle.endColorPercent = f2Percent;
						particle.startR = _colorVector[fi1+1];
						particle.startG = _colorVector[fi1+2];
						particle.startB = _colorVector[fi1+3];
						particle.endR = _colorVector[fi2+1];
						particle.endG = _colorVector[fi2+2];
						particle.endB = _colorVector[fi2+3];
						material.updateParticleColor(particle);
						break ;
					}
					fi1 = fi2;
					fi2 = fi1 + 4;
				}
				
			}
		}
		
		override public function haveFrames():Boolean
		{
			return _colorVector.length > 4;
		}
		
	}
}