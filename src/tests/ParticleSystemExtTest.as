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
package tests {
	
	import de.nulldesign.nd2d.display.Scene2D;
	import de.nulldesign.nd2d.effect.BurstEmitter;
	import de.nulldesign.nd2d.effect.ParticleSystemExt;
	import de.nulldesign.nd2d.effect.RectEmitter;
	import de.nulldesign.nd2d.materials.BlendModePresets;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.events.MouseEvent;
	
	public class ParticleSystemExtTest extends Scene2D {
		
		[Embed(source="/assets/crate.jpg")]
		private var particleClass:Class;
		
		private var particles:ParticleSystemExt;
		private var emitter:RectEmitter;
		private var emitter2:RectEmitter;
		private var burstEmitter:BurstEmitter
		
		
		/**
		 *  Mouse click to change the emitter at runtime
		 */
		public function ParticleSystemExtTest() {
			
			emitter = new RectEmitter();
			emitter.rectFrom.setTo(-500,250,0); 
			emitter.rectTo.setTo(500,300,0);// emit rect pos is from (-500,250) to (500,300)
			emitter.directionTo.y = -1      // up direction
			emitter.vel = 100;           
			emitter.velVariance = 200;      // particle speed  from 100 to 300
			emitter.size = 5
			emitter.sizeVariance = 25;      // particle size from 5 to 30
			emitter.rot = 0;
			emitter.rotVariance = 360;      // particle init rotation will be  0~ 360
			emitter.emitPeriod = 0;         // 0 means emitting all the time
			emitter.emitRate = 100;         // 100 particles per second
			emitter.startAlpha = 1;
			emitter.endAlpha = 0;
			
			emitter2 = new RectEmitter();
			emitter2.color = 0x000000;
			emitter2.colorVariance = 0xffffff;
			emitter2.directionFrom.setTo(-500,0,0);
			emitter2.directionTo.setTo(500,0,0);
			emitter2.emitPeriod = 5; // every 5 seconds emit once
			emitter2.emitTime = 2;   // emit duction is 2 seconds ,so there's 3 seconds intervial stop emit.
			emitter2.emitRate = 100;
			emitter2.rectFrom.setTo(-200,-200,0);
			emitter2.rectTo.setTo(200,200,0)
			emitter2.size = 15;
			emitter2.sizeVariance = 15;
			emitter2.vel = 200;
			emitter2.rotVel = 300;  
			emitter2.rotVariance = 600; //rotate 300~900 degress per second
			emitter2.startAlpha = 0.1 ;
			emitter2.endAlpha = 1;
			emitter2.lifeTime = 3;
			emitter2.lifeTimeVariance = 1;
			
			burstEmitter = new BurstEmitter(); // BurstEmitter emit all particles in particleSystem at once
			burstEmitter.minStartPosition.x = -500;
			burstEmitter.maxStartPosition.x = 500;
			burstEmitter.startColor = 0x00FF00;
			burstEmitter.startColorVariance = 0x0000FF;
			burstEmitter.endColor = 0xAAFF33;
			burstEmitter.endColorVariance = 0xFF9966;
			burstEmitter.minStartSize = 1;
			burstEmitter.maxStartSize = 3;
			burstEmitter.minEndSize = 70;
			burstEmitter.maxEndSize = 80;
			burstEmitter.minLife = 1;
			burstEmitter.maxLife = 5;
			burstEmitter.rot = 60; //initial degrees
			burstEmitter.rotVel = 270;  
			burstEmitter.rotVelVariance = 90 // rotate 270~360 degrees every second.
				
			particles = new ParticleSystemExt(Texture2D.textureFromBitmapData(new particleClass().bitmapData) ,500);
			particles.emitter = emitter;
			particles.blendMode = BlendModePresets.ADD_PREMULTIPLIED_ALPHA;
			addChild(particles);
			
			
			/**
			 *    Modifiers is to modify particles's appearance based on the life percent of the particle.
			 *    just uncommit bottom lines to see them.
			 */
			
			//green to red ,then to blue
//			particles.colorModifier.addKeyFrame(0,  0,1,0); 
//			particles.colorModifier.addKeyFrame(0.5,1,0,0); 
//			particles.colorModifier.addKeyFrame(1,0,0,1); 
			
//			particles.alphaModifier.addKeyFrame(0,1);
//			particles.alphaModifier.addKeyFrame(0.5,0);
//			particles.alphaModifier.addKeyFrame(1,1);
			
//			particles.sizeModifier.addKeyFrame(0,10,10);
//			particles.sizeModifier.addKeyFrame(0.6,200,200);
//			particles.sizeModifier.addKeyFrame(1,50,50);
			
			
			particles.start();
			
			
			
			addEventListener(MouseEvent.CLICK , onMouseClick);
		}
		
		protected var state:uint = 0;
		protected var initModifiers:Boolean = false
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