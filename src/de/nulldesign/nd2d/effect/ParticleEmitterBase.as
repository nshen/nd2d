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
	public class ParticleEmitterBase
	{
		/**
		 *   How many seconds emit one time.
		 */
		public var emitPeriod:Number = 5;
		
		/**
		 * Emitting duration in a emitPeriod
		 */
		public var emitTime:Number = 1;
		/**
		 * Emit particles number per second.
		 */
		public var emitRate:Number = 5;
		
		protected var _particleSystem:ParticleSystemExt;
		protected var _newParticleCount:Number = 0;
		
		protected var pastTime:Number = 0;
		protected var inEmitTime : Boolean = true;

		public function update(elapsed:Number):void
		{
			if(!_particleSystem)
				return ;
			
			pastTime += elapsed;
			if(emitTime >= emitPeriod || emitPeriod <= 0)
				inEmitTime = true;
			else
			{
				var remainTime:Number = pastTime % emitPeriod ;
				inEmitTime = (remainTime <= emitTime );
			}
			if(!inEmitTime) return ;
			
			_newParticleCount += Number(elapsed * emitRate) ; 
			while( _newParticleCount > 1)
			{
				var newParticle:ParticleExt = _particleSystem.generateParticle();
				if(newParticle)
				{	
					initParticle(newParticle);
					if(_particleSystem)
						_particleSystem.uploadParticle(newParticle);
				}
				
				_newParticleCount--;
			}
		}
		
		protected function initParticle(newParticle:ParticleExt):void
		{
			throw new Error("you need override initParticle method.");
		}
		
		public function set particleSystem(value:ParticleSystemExt) : void
		{
			_particleSystem = value;
		}
	}
}