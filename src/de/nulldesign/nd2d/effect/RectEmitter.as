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
	
	import de.nulldesign.nd2d.utils.VectorUtil;
	import flash.geom.Vector3D;
	
	public class RectEmitter extends ParticleEmitterBase
	{
		/**
		 * second
		 */
		public var lifeTime:Number = 2;
		/**
		 * second
		 */
		public var lifeTimeVariance:Number = 0;

	
		public var directionFrom:Vector3D = new Vector3D(0,0,0);
		public var directionTo:Vector3D = new Vector3D(0,0,0);
		public var vel:Number = 100;
		public var velVariance:Number = 0;
		public var rot:Number = 0;
		public var rotVariance:Number = 0;
		public var rotVel:Number = 1;
		public var rotVelVariance:Number = 0;
		public var rectFrom:Vector3D = new Vector3D(-100,-100,0);
		public var rectTo:Vector3D = new Vector3D(100,100,0);
		
		
		public var startColor:Number = 0xffffff;
		public var startColorVariance:Number = 0;
		public var endColor:Number = 0xffffff;
		public var endColorVariance:Number = 0;
		
		public var startSizeX:Number = 10;
		public var startSizeY:Number = 10;
		public var endSizeX:Number = 10;
		public var endSizeY:Number = 10;
		public var sizeVariance:Number = 0;
		
		
		/**
		 * 0~1
		 */
		public var startAlpha:Number = 1;
		/**
		 * 0~1
		 */
		public var endAlpha:Number = 0;
		
		public function set color(value:Number):void
		{
			startColor = endColor = value;
		}
		public function set colorVariance(value:Number):void
		{
			startColorVariance = endColorVariance = value;
		}
		
		public function set alpha(value:Number):void
		{
			startAlpha = endAlpha = value;
		}
		public function set size(value:Number):void
		{
			startSizeX = startSizeY = endSizeX = endSizeY = value;
		}
		public function RectEmitter()
		{
			super();
		} 
		
		override protected function initParticle(newParticle:ParticleExt):void
		{ 
			newParticle.startColor = startColor + startColorVariance * Math.random();
			newParticle.endColor = endColor+ endColorVariance * Math.random();
			newParticle.startAlpha = startAlpha;
			newParticle.endAlpha = endAlpha;

			newParticle.lifeTime = lifeTime + lifeTimeVariance * Math.random();
			newParticle.dir.x = directionFrom.x * Math.random() + directionTo.x * Math.random();
			newParticle.dir.y = directionFrom.y * Math.random() + directionTo.y * Math.random();
//			newParticle.dir.z = directionFrom.z * Math.random() + directionTo.z * Math.random();
			newParticle.dir.normalize();
			newParticle.vel = vel + velVariance * Math.random();
			
			var sizevar : Number = sizeVariance * Math.random();
			newParticle.startSizeX = startSizeX + sizevar;
			newParticle.endSizeX = endSizeX + sizevar;
			newParticle.startSizeY = startSizeY + sizevar;
			newParticle.endSizeY = endSizeY + sizevar;
			
			newParticle.rot = VectorUtil.deg2rad(rot + rotVariance * Math.random());
			newParticle.rotVel = VectorUtil.deg2rad( rotVel+ rotVelVariance * Math.random());
			
			newParticle.pos.x += (rectTo.x - rectFrom.x) * Math.random() + rectFrom.x;
			newParticle.pos.y += (rectTo.y - rectFrom.y) * Math.random() + rectFrom.y;
//			newParticle.pos.z += (EmitterRectTo.z - EmitterRectFrom.z) * Math.random() + EmitterRectFrom.z;
			
			newParticle.startTime = _particleSystem.currentTime;
		}
	}
}