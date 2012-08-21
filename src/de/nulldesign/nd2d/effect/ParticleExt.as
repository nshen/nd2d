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
package de.nulldesign.nd2d.effect
{
	import flash.geom.Vector3D;

	public class ParticleExt
	{
		public var index : int;
		
		public var pos:Vector3D = new Vector3D();
		public var dir:Vector3D = new Vector3D();
		public var vel:Number = 0;
		
		public var rot:Number = 0;
		public var rotVel:Number = 0;
		
		public var startR:Number = 1;
		public var startG:Number = 1;
		public var startB:Number = 1;
		public var endR:Number = 1;
		public var endG:Number = 1;
		public var endB:Number = 1;
		public var startColorPercent:Number = 0 ;
		public var endColorPercent:Number = 1;
		
		public var startAlpha:Number = 1;
		public var endAlpha:Number = 1;
		public var startAlphaPercent:Number = 0;
		public var endAlphaPercent:Number = 1;
		
		
		public var startTime:Number = 0 ;
		public var lifeTime:Number = 0 ;
		
		public var startSizeX:Number = 0;
		public var startSizeY:Number = 0;
		public var endSizeX:Number = 0;
		public var endSizeY:Number = 0;
		
		public function ParticleExt(index:int)
		{
			this.index = index;
		}
		
//		public function set color(value:Number):void
//		{
//			startColor = endColor = value;
//		}
//		public function set size(value:Number):void
//		{
//			startSizeX = startSizeY = endSizeX = endSizeY = value;
//		}
//		public function set alpha(value:Number):void
//		{
//			startAlpha = endAlpha = value;
//		}
		
		public function set startColor(value:Number):void
		{
			startR = value >> 16 & 0xff / 0xff;
			startG = value >> 8 & 0xff / 0xff;
			startB = value & 0xff / 0xff;
		}
		public function set endColor(value:Number):void
		{
			endR = value >> 16 & 0xff / 0xff;
			endG = value >> 8 & 0xff / 0xff;
			endB = value & 0xff / 0xff;
		}
		
		public function get startColor():Number
		{
			return startR << 16 | startG << 8 | startB;
		}
		
		public function get endColor():Number
		{
			return endR << 16 | endG << 8 | endB;
		}
		
		public function reset():ParticleExt
		{
			startTime = 0;
			lifeTime = 0;
			startColor = endColor = 0xffffff;
			startAlpha = endAlpha = 1;
			startSizeX = startSizeY = endSizeX = endSizeY  = 1;
			vel = 0;
			rot = 0;
			rotVel = 0;
//			u = 0;
//			v = 0;
			pos.setTo(0,0,0);
			dir.setTo(0,1,0);
			return this;
		}
		
	}
}