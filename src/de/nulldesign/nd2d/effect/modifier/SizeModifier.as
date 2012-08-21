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
	public class SizeModifier extends ModifierBase
	{
		protected var _sizeAffectorVect43:Vector.<Number> = new <Number>[]; //[x,y,0,lifePercent]
		
		public static const GPU_MAX_FRAMES:uint = 4;
		
		/**
		 * Due to the different implementation,SizeModifier only support 4 key frames for now .
		 */
		public function SizeModifier()
		{
			super();
		}
		
		public function addKeyFrame(lifePercent:Number, x:Number , y:Number) : void
		{
			if(_sizeAffectorVect43.length >= GPU_MAX_FRAMES * 4)
				throw new Error("SizeModifier only support 4 keyframes.");
			
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