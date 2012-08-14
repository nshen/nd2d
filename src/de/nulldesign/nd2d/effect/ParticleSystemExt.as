package de.nulldesign.nd2d.effect
{
	import de.nulldesign.nd2d.display.Camera2D;
	import de.nulldesign.nd2d.display.Node2D;
	import de.nulldesign.nd2d.effect.ParticleEmitterBase;
	import de.nulldesign.nd2d.effect.ParticleSystemExtMaterial;
	import de.nulldesign.nd2d.effect.affector.AlphaAffector;
	import de.nulldesign.nd2d.effect.affector.SizeAffector;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.utils.NumberUtil;
	
	import flash.display3D.Context3D;
	import flash.utils.getTimer;

	public class ParticleSystemExt extends Node2D
	{
		protected var _particles:Vector.<ParticleExt>;
		protected var _emitter:ParticleEmitterBase;
		protected var _material:ParticleSystemExtMaterial;
		protected var _preset:ParticleSystemExtPreset;
		
		protected var _alphaAffector:AlphaAffector = new AlphaAffector();
		protected var _sizeAffector:SizeAffector = new SizeAffector();
		
		protected var _maxCapacity:uint = 0 ;
		protected var _lastIndex:int = -1;
		protected var _emitting:Boolean = false;
		
		public var currentTime:Number = 0 ;
		public var startTime:Number = 0 ;
		
		public function ParticleSystemExt( texture:Texture2D ,maxCapacity:uint ,preset:ParticleSystemExtPreset = null)
		{
			_maxCapacity = maxCapacity ;
			_preset = preset;
			init(texture)
		
		}
		
		protected function init(texture:Texture2D):void
		{
			_particles = new Vector.<ParticleExt>(_maxCapacity, true);
			for(var i:int = 0 ; i < _maxCapacity ; i ++ )
			{
				_particles[i] = new ParticleExt(i);
				if(_preset)
				{
					presetParticle(_particles[i]);
				}
			}
			_material = new ParticleSystemExtMaterial(this,texture);
			
		}
		
		public function get sizeAffector():SizeAffector
		{
			return _sizeAffector;
		}

		public function get alphaAffector():AlphaAffector
		{
			return _alphaAffector;
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
			if(_emitter)
			{
				_emitter.particleSystem = null ;
			}
			_emitter = value;
			_emitter.particleSystem = this;
		}
		public function get emitter() : ParticleEmitterBase {return _emitter;}
		
		public function generateParticle():ParticleExt
		{
			if(++_lastIndex >= _maxCapacity )
				_lastIndex = 0 ; 
			return _particles[_lastIndex].reset();
		}
		
		protected function presetParticle(p:ParticleExt):void
		{
//			p.pos.x = NumberUtil.rndMinMax(_preset.minStartPosition.x, _preset.maxStartPosition.x);
//			p.pos.y = NumberUtil.rndMinMax(_preset.minStartPosition.y, _preset.maxStartPosition.y);
//			
//			p.vel = NumberUtil.rndMinMax(_preset.minSpeed, _preset.maxSpeed);
//			var angle:Number = NumberUtil.rndMinMax(VectorUtil.deg2rad(_preset.minEmitAngle),VectorUtil.deg2rad(_preset.maxEmitAngle));
//			p.dir.setTo(Math.cos(angle),Math.sin(angle),0);
//			
//			p.startColor = _preset.startColor + _preset.startColorVariance * Math.random();
//			p.endColor = _preset.endColor + _preset.endColorVariance * Math.random();
//			
//			p.startAlpha = _preset.startAlpha;
//			p.endAlpha = _preset.endAlpha;
//			
//			p.startSizeX = NumberUtil.rndMinMax(_preset.minStartSizeX, _preset.maxStartSizeX);
//			p.endSizeX = NumberUtil.rndMinMax(_preset.minEndSizeX, _preset.maxEndSizeX);
//			p.startSizeY = NumberUtil.rndMinMax(_preset.minStartSizeY, _preset.maxStartSizeY);
//			p.endSizeY = NumberUtil.rndMinMax(_preset.minEndSizeY, _preset.maxEndSizeY);
//			
//			p.startTime = _preset.spawnDelay * p.index;
//			p.lifeTime  = NumberUtil.rndMinMax(_preset.minLife, _preset.maxLife);
//			
//			p.rotVel = _preset.rotVel + _preset.rotVelRange * Math.random();
			
			_material.updateParticle(p);
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