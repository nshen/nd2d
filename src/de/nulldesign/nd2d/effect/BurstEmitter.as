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
	import de.nulldesign.nd2d.utils.NumberUtil;
	import de.nulldesign.nd2d.utils.VectorUtil;
	
	import flash.geom.Vector3D;

	/**
	 * Emit all particles in the particleSystem at once . It's like the ParticleSystem2D with burst set to true.
	 * The most performance emitter . preset the emitt rules and only upload vertex data one time.
	 */ 
	public class BurstEmitter extends ParticleEmitterBase
	{
		
		public var minStartPosition:Vector3D = new Vector3D(-5, 0);
		public var maxStartPosition:Vector3D = new Vector3D(5, 0);
		
		public var minSpeed:Number = 100;
		public var maxSpeed:Number = 300;
		
		public var minEmitAngle:Number = 0;
		public var maxEmitAngle:Number = 360;
		
		public var startColor:Number = 0xD60606;
		public var startColorVariance:Number = 0xD60606;
		public var endColor:Number = 0xff0000;
		public var endColorVariance:Number = 0x0000ff;
		
		public var startAlpha:Number = 1;
		public var endAlpha:Number = 0;
		
		public var minLife:Number = 1;
		public var maxLife:Number = 3;
		
		public var minStartSizeX:Number = 1;
		public var maxStartSizeX:Number = 1;
		public var minEndSizeX:Number = 1;
		public var maxEndSizeX:Number = 1;
		
		public var minStartSizeY:Number = 1;
		public var maxStartSizeY:Number = 1;
		public var minEndSizeY:Number = 1;
		public var maxEndSizeY:Number = 1;
		
		/**
		 * rotate speed ,degrees per second
		 */
		public var rotVel:Number = 0;
		public var rotVelVariance:Number = 360;
		
		/**
		 * initial degrees
		 */
		public var rot:Number = 0
		
		public function set minStartSize(value:Number):void
		{
			minStartSizeX = minStartSizeY = value;
		}
		public function set maxStartSize(v:Number):void
		{
			maxStartSizeX = maxStartSizeY = v;
		}
		public function set minEndSize(v:Number):void
		{
			minEndSizeX = minEndSizeY = v;
		}
		public function set maxEndSize(v:Number):void
		{
			maxEndSizeX = maxEndSizeY = v;
		}
		
		
		public function BurstEmitter()
		{
			super();
		}
		
		override public function update(elapsed:Number):void
		{
			if(_particleSystemDirty)
			{
				for each(var p:ParticleExt in _particleSystem.particles)
				{
					presetParticle(p);
				}
				_particleSystemDirty = false
			}
			return;
		}
		
		protected var _particleSystemDirty:Boolean = false;
		override public function set particleSystem(value:ParticleSystemExt):void
		{
			super.particleSystem = value;
			if( value )
			{
				_particleSystemDirty = true;
			}
		}
		
		protected function presetParticle(p:ParticleExt):void
		{
			p.pos.x = NumberUtil.rndMinMax(minStartPosition.x, maxStartPosition.x);
			p.pos.y = NumberUtil.rndMinMax(minStartPosition.y, maxStartPosition.y);
			
			p.vel = NumberUtil.rndMinMax(minSpeed, maxSpeed);
			var angle:Number = NumberUtil.rndMinMax(VectorUtil.deg2rad(minEmitAngle),VectorUtil.deg2rad(maxEmitAngle));
			p.dir.setTo(Math.sin(angle),Math.cos(angle),0);
			p.startColor = startColor + startColorVariance * Math.random();
			p.endColor = endColor + endColorVariance * Math.random();
			p.startAlpha = startAlpha;
			p.endAlpha = endAlpha;
			
			p.startSizeX = p.startSizeY = NumberUtil.rndMinMax(minStartSizeX, maxStartSizeX);
			p.endSizeX = p.endSizeY = NumberUtil.rndMinMax(minEndSizeX, maxEndSizeX);
			
			p.rotVel =  VectorUtil.deg2rad( rotVel+ rotVelVariance * Math.random());
			p.rot = VectorUtil.deg2rad(rot);
			p.lifeTime  = NumberUtil.rndMinMax(minLife, maxLife);
			p.startTime = _particleSystem.currentTime;// + p.lifeTime * Math.random()  
			
			_particleSystem.uploadParticle(p);
		}
		
	}
}