package de.nulldesign.nd2d.effect.modifier
{
	import de.nulldesign.nd2d.effect.ParticleExt;
	import de.nulldesign.nd2d.effect.ParticleSystemExtMaterial;

	public class ModifierBase
	{
		public static const GPU_MAX_FRAMES:uint = 4;
		public function ModifierBase()
		{
		}
		public function modify(particle:ParticleExt , particleLifePercent:Number , material:ParticleSystemExtMaterial):void
		{
			
		}
	}
}