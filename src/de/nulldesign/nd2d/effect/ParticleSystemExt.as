package de.nulldesign.nd2d.effect
{
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.effect.ParticleEmitterBase;
	import de.nulldesign.nd2d.effect.ParticleSystemExtMaterial;
	import de.nulldesign.nd2d.effect.modifier.AlphaModifier;
	import de.nulldesign.nd2d.effect.modifier.ColorModifier;
	import de.nulldesign.nd2d.effect.modifier.SizeModifier;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.utils.NumberUtil;
	import de.nulldesign.nd2d.utils.VectorUtil;
	
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
		
		//////////////////////////////
		// affectors
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
		////////////////////////////////////////
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
		

		
		
		
		
		public function stop(immediately : Boolean) : void
		{
			_emitting = false;
			if(immediately)
			{	
				for(var i:int = 0 ; i< _maxCapacity ; i++)
				{
//					_particles[i].die();
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

			
			if(_emitter && _emitting)
				_emitter.update(elapsed);
			
//			if(_colorAffector.keyframeCount > 0)
//			{
//			}
			
				updateAffectors();
			

		}
		
		private function updateAffectors():void
		{
			
			var past:Number;
			var fi1:uint ,fi2:uint; //index
			var percent:Number ,f1Percent:Number ,f2Percent:Number;
			
			for each(var p:ParticleExt in _particles)
			{
				past = currentTime - p.startTime ; 
				if(past >= p.lifeTime) //die
					continue;
				
				percent = past / p.lifeTime;
				_colorModifier.modify(p,percent,_material);

				if(_alphaModifier.keyframeCount > 1)
				{
					fi1 = 0 ;
					fi2 = fi1 + 4;
					while(fi2 < _alphaModifier._alphaVector.length)
					{
						
						f1Percent = _alphaModifier._alphaVector[fi1];
						f2Percent = _alphaModifier._alphaVector[fi2];
						if(percent >= f1Percent && percent < f2Percent)
						{
							_material.updateParticleAlpha(
								p.index,
								_alphaModifier._alphaVector[fi1+1],
								_alphaModifier._alphaVector[fi2+1],
								f1Percent,f2Percent
							)
							break ;
						}
						fi1 = fi2;
						fi2 = fi1 + 4;
					}
				}

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