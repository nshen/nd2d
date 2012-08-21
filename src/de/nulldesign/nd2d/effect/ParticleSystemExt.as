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
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.effect.modifier.AlphaModifier;
	import de.nulldesign.nd2d.effect.modifier.ColorModifier;
	import de.nulldesign.nd2d.effect.modifier.SizeModifier;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.display3D.Context3D;
	import flash.utils.getTimer;

	public class ParticleSystemExt extends Node2D
	{
		protected var _particles:Vector.<ParticleExt>;
		protected var _emitter:ParticleEmitterBase;
		protected var _material:ParticleSystemExtMaterial;
		
		protected var _alphaModifier:AlphaModifier = new AlphaModifier();
		protected var _sizeModifier:SizeModifier = new SizeModifier();
		protected var _colorModifier:ColorModifier = new ColorModifier();
		
		protected var _maxCapacity:uint = 0 ;
		protected var _lastIndex:int = -1;
		protected var _emitting:Boolean = false;
		
		public var currentTime:Number = 0 ;
		public var startTime:Number = 0 ;
		
		public function ParticleSystemExt( texture:Texture2D ,maxCapacity:uint ,burstEmitter:BurstEmitter = null)
		{
			_maxCapacity = maxCapacity ;
			init(texture,burstEmitter)
		
		}
		
		protected function init(texture:Texture2D , burst:BurstEmitter):void
		{
			_particles = new Vector.<ParticleExt>(_maxCapacity, true);
			
			for(var i:int = 0 ; i< _maxCapacity ; i ++ )
			{
				_particles[i] = new ParticleExt(i);
			}
			_material = new ParticleSystemExtMaterial(this,texture);
			
			if(burst)
				emitter = burst;
		}
		
		public function get sizeModifier():SizeModifier
		{
			return _sizeModifier;
		}

		public function get alphaModifier():AlphaModifier
		{
			return _alphaModifier;
		}

		public function get colorModifier():ColorModifier
		{
			return _colorModifier;
		}
		
		public function get particles():Vector.<ParticleExt>
		{
			return _particles;
		}
		


		public function get maxCapacity():uint
		{
			return _maxCapacity;
		}
		

		public function set emitter(value : ParticleEmitterBase):void
		{
			_material._programDrity = true;
			if(_emitter)
			{
				_emitter.particleSystem = null ;
			}
			if(value)
			{
				_emitter = value;
				_emitter.particleSystem = this;
			}
		}
		public function get emitter() : ParticleEmitterBase {return _emitter;}
		
		public function generateParticle():ParticleExt
		{
			if(++_lastIndex >= _maxCapacity )
				_lastIndex = 0 ; 
			return _particles[_lastIndex].reset();
		}
		

		public function stop(immediately : Boolean = false) : void
		{
			_emitting = false;
			if(immediately)
			{	
			   for each (var p:ParticleExt in _particles)
			   {
				   p.lifeTime  = 0 ;
				   _material.updateParticleTime(p);
			   }
			}
		}
		
		public function start() : void 
		{
			_emitting = true;
			startTime = getTimer();
		}
		

		public function uploadParticle(newParticle:ParticleExt):void
		{
			_material.updateParticle(newParticle);
		}
		
		override protected function step(elapsed:Number):void 
		{
			currentTime  = (getTimer() - startTime) * 0.001; 
			
			if(_emitting)
			{
				if(_emitter)
					_emitter.update(elapsed);
				
				if(_colorModifier.haveFrames() || _alphaModifier.haveFrames())
				{
					updateAffectors();
				}
			}
		}
		
		private function updateAffectors():void
		{
			
			var past:Number;
			var percent:Number;
			
			for each(var p:ParticleExt in _particles)
			{
				past = currentTime - p.startTime ; 
				if(past >= p.lifeTime) //die
					continue;
				
				percent = past / p.lifeTime;
				_colorModifier.modify(p,percent,_material);
                _alphaModifier.modify(p,percent,_material);
			}
			
		}		
		
		override public function handleDeviceLoss():void 
		{
			super.handleDeviceLoss();
			_material.handleDeviceLoss();
		}
		
		override protected function draw(context:Context3D, camera:Camera2D):void
		{
			if(_maxCapacity <= 0 )
				return;
			
			_material.blendMode = blendMode;
			_material.modelMatrix = worldModelMatrix;
			_material.viewProjectionMatrix = camera.getViewProjectionMatrix(false);
			_material.render(context, null, 0,_maxCapacity * 2); //dont use facelist
		}
		
		override public function dispose():void 
		{
			if(_material)
			{
				_material.dispose();
				_material = null;
			}
			super.dispose();
		}
	}
}