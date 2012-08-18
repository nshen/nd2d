/*
* ND2D - A Flash Molehill GPU accelerated 2D engine
*
* Author: Lars Gerckens
* Copyright (c) nulldesign 2011
* Repository URL: http://github.com/nulldesign/nd2d
* Getting started: https://github.com/nulldesign/nd2d/wiki
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

package tests {
	
	import de.nulldesign.nd2d.display.ParticleSystem2D;
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.effect.BurstEmitter;
	import de.nulldesign.nd2d.effect.ParticleSystemExt;
	import de.nulldesign.nd2d.effect.ParticleSystemExtPreset;
	import de.nulldesign.nd2d.effect.RectEmitter;
	import de.nulldesign.nd2d.materials.BlendModePresets;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	import de.nulldesign.nd2d.utils.ParticleSystemPreset;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class ParticleSystemExtTest extends Scene2D {
		
		[Embed(source="/assets/crate.jpg")]
		private var particleClass:Class;
		
		private var particles:ParticleSystemExt;
		private var emitter:RectEmitter;
		private var emitter2:RectEmitter;
		private var burstEmitter:BurstEmitter
		
		
		private var psp:ParticleSystemExtPreset;
		
		public function ParticleSystemExtTest() {
			
			emitter = new RectEmitter();
//			emitter.color = 0x222222;
//			emitter.colorRange = 0xaaaaaa;
			emitter.directionFrom.setTo(-500,0,0);
			emitter.directionTo.setTo(600,0,0);
			emitter.emitPeriod = 5;
			emitter.emitTime = 2;
			emitter.emitRate = 100;
			emitter.rectFrom.setTo(-200,-200,0);
			emitter.rectTo.setTo(200,200,0)
			emitter.sizeX = 10;
			emitter.sizeY = 10;
			emitter.sizeRange = 10;
			emitter.vel = 200;
			emitter.rotVel = 5;
			emitter.rotRange = 10;
			emitter.color = 0xff0000;
			
//			emitter.lifeTime = 0.5
		
			
			
			
			
			emitter2 = new RectEmitter();
			emitter2.color = 0x000000;
			emitter2.colorRange = 0xffffff;
			emitter2.directionFrom.setTo(-500,0,0);
			emitter2.directionTo.setTo(600,0,0);
			emitter2.emitPeriod = 0;
			emitter2.emitTime = 0;
			emitter2.emitRate = 8000;
			emitter2.rectFrom.setTo(-200,-200,0);
			emitter2.rectTo.setTo(200,200,0)
			emitter2.sizeX = 10;
			emitter2.sizeY = 10;
			emitter2.sizeRange = 50
			emitter2.vel = 200;
			emitter2.rotVel = 5;
			emitter2.rotRange = 10;
			
			burstEmitter = new BurstEmitter();
			burstEmitter.minStartPosition.x = -300.0;
			burstEmitter.maxStartPosition.x = 300.0;
			burstEmitter.startColor = 0x00FF00;
			burstEmitter.startColorVariance = 0x0000FF;
			burstEmitter.endColor = 0xAAFF33;
			burstEmitter.endColorVariance = 0xFF9966;
			burstEmitter.minStartSize = 1;
			burstEmitter.maxStartSize = 3;
			burstEmitter.minEndSize = 70;
			burstEmitter.maxEndSize = 80;
			burstEmitter.spawnDelay = 5.0;
			burstEmitter.minLife = 0.1;
			burstEmitter.maxLife = 5;
			
			particles = new ParticleSystemExt(Texture2D.textureFromBitmapData(new particleClass().bitmapData) ,10000);
			particles.emitter = emitter;
//			particles.colorAffector.addKeyFrame(0,  0,1,0);
//			particles.colorAffector.addKeyFrame(0.5,1,0,0);
//			particles.colorAffector.addKeyFrame(1,0,0,1);
			
			addChild(particles);
			
			
//			particles.sizeAffector.addKeyFrame(0,0,0);
//			particles.sizeAffector.addKeyFrame(0.6,50,50);
//			particles.sizeAffector.addKeyFrame(0.5,200,200);
//			particles.sizeAffector.addKeyFrame(1,0,0);
			
			particles.start();
			particles.blendMode = BlendModePresets.ADD_PREMULTIPLIED_ALPHA;
			
			addEventListener(MouseEvent.CLICK , onMouseClick);
		}
		
		protected var state:uint = 0;
		protected function onMouseClick(event:MouseEvent):void
		{
			switch(state)
			{
				case 0:
					particles.emitter = burstEmitter;
					state = 1;
					break;
				case 1:
					particles.emitter = emitter2;
					state = 2;
					break;
				case 2:
					particles.emitter = emitter;
					state = 0;
					break;
			}
		
		}		
		
		
		
		override protected function step(elapsed:Number):void {
			particles.x = stage.stageWidth / 2.0;
			particles.y = stage.stageHeight /2;
		}
	}
}