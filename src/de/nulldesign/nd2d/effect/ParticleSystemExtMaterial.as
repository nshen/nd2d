package de.nulldesign.nd2d.effect
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import de.nulldesign.nd2d.effect.affector.AffectorBase;
	import de.nulldesign.nd2d.effect.affector.AlphaAffector;
	import de.nulldesign.nd2d.effect.affector.SizeAffector;
	import de.nulldesign.nd2d.geom.Face;
	import de.nulldesign.nd2d.materials.AMaterial;
	import de.nulldesign.nd2d.materials.shader.ShaderCache;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	public class ParticleSystemExtMaterial extends AMaterial
	{
		
		// index buffer
		protected var _indexBuffer:IndexBuffer3D;
		protected var _indexBufferDirty:Boolean;
		
		// vertextBuffers
		protected var _vertexBuffer:VertexBuffer3D ;		// va0 (x,y,z)
		protected var _vertexBuffer1:VertexBuffer3D;		// va1(u,v,sizeX,sizeY) 
		protected var _vertexBuffer2:VertexBuffer3D;		// va2(startTime, lifetime, rot, rotv)
		protected var _vertexBuffer3:VertexBuffer3D;		// va3(Vx, Vy, Vz)
		protected var _vertexBuffer4:VertexBuffer3D;        // va4(r,g,b,a)
		
		// dirty flags
		protected var _vertexBufferDirty:Boolean;
		protected var _vertexBufferDirty1:Boolean;
		protected var _vertexBufferDirty2:Boolean;
		protected var _vertexBufferDirty3:Boolean;
		protected var _vertexBufferDirty4:Boolean;
		protected var _programDrity:Boolean = true ;
		
		private var _vertexData0 : Vector.<Number>;			// vertex
		private var _vertexData1 : Vector.<Number>;			// vertex1
		private var _vertexData2 : Vector.<Number>;			// vertex2
		private var _vertexData3 : Vector.<Number>;			// vertex3
		private var _vertexData4 : Vector.<Number>;			// vertex4
		
		private var _indexData : Vector.<uint>;				// index
		
		private var _particleSystem:ParticleSystemExt;
		private var _maxVertexNum:uint = 0 ;
		private var _maxIndexNum:uint = 0 ;
		
		
		protected var _texture:Texture2D;
		
			
		public function ParticleSystemExtMaterial(ps:ParticleSystemExt ,texture:Texture2D)
		{
			_particleSystem = ps;
			_texture = texture;
			
			_maxVertexNum = _particleSystem.maxCapacity * 4 ;        // one particle have four vertex
			_maxIndexNum = _particleSystem.maxCapacity * 6;			// six index
			
			_vertexData0 = new Vector.<Number>(_maxVertexNum * 3, true);	// (x,y,z)
			_vertexData1 = new Vector.<Number>(_maxVertexNum * 4, true); // ( u, v, sizeX, sizeY )
			_vertexData2 = new Vector.<Number>(_maxVertexNum * 4, true); //(passtime, lifetime, rot, rotv)
			_vertexData3 = new Vector.<Number>(_maxVertexNum * 4, true); //(Vx, Vy, Vz)
			_vertexData4 = new Vector.<Number>(_maxVertexNum * 4, true);// (r, g, b, a)
			
			_indexData = new Vector.<uint>(_maxIndexNum, true); 
			for(var index:int = 0 ; index < _particleSystem.maxCapacity ; index++)
			{
				_indexData[index *6] = index *4;			// 0 1 2
				_indexData[index *6+1] = index *4+1;
				_indexData[index *6+2] = index *4+2;
				_indexData[index *6+3] = index *4;			// 0 2 3
				_indexData[index *6+4] = index *4+2;
				_indexData[index *6+5] = index *4+3;
			}
			_indexBufferDirty = true ;
		}
		

		
		private static var tmpVec3 : Vector3D = new Vector3D;
		
		public function uploadParticle(newParticle:ParticleExt ):void
		{
			var index:int = newParticle.index;
			
			_vertexData0[index*12+0] = newParticle.pos.x;
			_vertexData0[index*12+1] = newParticle.pos.y;
			_vertexData0[index*12+2] = newParticle.pos.z;
			
			_vertexData0[index*12+3] = newParticle.pos.x;
			_vertexData0[index*12+4] = newParticle.pos.y;
			_vertexData0[index*12+5] = newParticle.pos.z;
			
			_vertexData0[index*12+6] = newParticle.pos.x;
			_vertexData0[index*12+7] = newParticle.pos.y;
			_vertexData0[index*12+8] = newParticle.pos.z;
			
			_vertexData0[index*12+9] = newParticle.pos.x;
			_vertexData0[index*12+10] = newParticle.pos.y;
			_vertexData0[index*12+11] = newParticle.pos.z;
			
			_vertexBufferDirty = true ;
			
			// va1 uv and size
			_vertexData1[index*16] = 0;
			_vertexData1[index*16+1] = 0;
			_vertexData1[index*16+2] = -newParticle.sizeX/2;
			_vertexData1[index*16+3] = newParticle.sizeY/2;
			
			_vertexData1[index*16+4] = 1;
			_vertexData1[index*16+5] = 0;
			_vertexData1[index*16+6] = newParticle.sizeX/2;
			_vertexData1[index*16+7] = newParticle.sizeY/2;
			
			_vertexData1[index*16+8] = 1;
			_vertexData1[index*16+9] = 1;
			_vertexData1[index*16+10] = newParticle.sizeX/2;
			_vertexData1[index*16+11] = -newParticle.sizeY/2;
			
			_vertexData1[index*16+12] = 0;
			_vertexData1[index*16+13] = 1;
			_vertexData1[index*16+14] = -newParticle.sizeX/2;
			_vertexData1[index*16+15] = -newParticle.sizeY/2;
			
			_vertexBufferDirty1 = true;
			
			
			// va2  (startTime , lifeTime ,rot,rotVel)
//			var liftTime : int = newParticle.pastTime + newParticle.remainTime
			_vertexData2[index*16] = newParticle.startTime;
			_vertexData2[index*16+1] = newParticle.lifeTime;
			_vertexData2[index*16+2] = newParticle.rot;
			_vertexData2[index*16+3] = newParticle.rotVel;
			
			_vertexData2[index*16+4] = newParticle.startTime;
			_vertexData2[index*16+5] = newParticle.lifeTime;
			_vertexData2[index*16+6] = newParticle.rot;
			_vertexData2[index*16+7] = newParticle.rotVel;
			
			_vertexData2[index*16+8] = newParticle.startTime;
			_vertexData2[index*16+9] = newParticle.lifeTime;
			_vertexData2[index*16+10] = newParticle.rot;
			_vertexData2[index*16+11] = newParticle.rotVel;
			
			_vertexData2[index*16+12] = newParticle.startTime;
			_vertexData2[index*16+13] = newParticle.lifeTime;
			_vertexData2[index*16+14] = newParticle.rot;
			_vertexData2[index*16+15] = newParticle.rotVel;
			
			_vertexBufferDirty2 = true;
			
			// va3 particle velocity
			tmpVec3.copyFrom(newParticle.dir);
			tmpVec3.scaleBy(newParticle.vel);
			
			_vertexData3[index*16] = tmpVec3.x;
			_vertexData3[index*16+1] = tmpVec3.y;
			_vertexData3[index*16+2] = tmpVec3.z;
			_vertexData3[index*16+3] = 0;
			
			_vertexData3[index*16+4] = tmpVec3.x;
			_vertexData3[index*16+5] = tmpVec3.y;
			_vertexData3[index*16+6] = tmpVec3.z;
			_vertexData3[index*16+7] = 0;
			
			_vertexData3[index*16+8] = tmpVec3.x;
			_vertexData3[index*16+9] = tmpVec3.y;
			_vertexData3[index*16+10] = tmpVec3.z;
			_vertexData3[index*16+11] = 0;
			
			_vertexData3[index*16+12] = tmpVec3.x;
			_vertexData3[index*16+13] = tmpVec3.y;
			_vertexData3[index*16+14] = tmpVec3.z;
			_vertexData3[index*16+15] = 0;
			
			_vertexBufferDirty3 = true;
			
			// va4 粒子颜色
			_vertexData4[index*16] = newParticle.r;
			_vertexData4[index*16+1] = newParticle.g;
			_vertexData4[index*16+2] = newParticle.b;
			_vertexData4[index*16+3] = newParticle.alpha;
			
			_vertexData4[index*16+4] = newParticle.r;
			_vertexData4[index*16+5] = newParticle.g;
			_vertexData4[index*16+6] = newParticle.b;
			_vertexData4[index*16+7] = newParticle.alpha;
			
			_vertexData4[index*16+8] = newParticle.r;
			_vertexData4[index*16+9] = newParticle.g;
			_vertexData4[index*16+10] = newParticle.b;
			_vertexData4[index*16+11] = newParticle.alpha;
			
			_vertexData4[index*16+12] = newParticle.r;
			_vertexData4[index*16+13] = newParticle.g;
			_vertexData4[index*16+14] = newParticle.b;
			_vertexData4[index*16+15] = newParticle.alpha;
			
			_vertexBufferDirty4 = true;
			
	
		}
		
		override public function render(context:Context3D, faceList:Vector.<Face>, startTri:uint, numTris:uint):void
		{
			
			generateBufferData(context, faceList);
			prepareForRender(context);
			context.drawTriangles(_indexBuffer);
			clearAfterRender(context);
			
		}
		override protected function generateBufferData(context:Context3D, faceList:Vector.<Face>):void
		{
			
//			var _particles : Vector.<ParticleExt> = _particleSystem.particles;
//			var p:ParticleExt;
//			for(var i:int = 0; i < _particleSystem.maxCapacity; i++)
//			{
//				p = _particles[i];				
//				_vertexData2[i*16] =  p.startTime;
//				_vertexData2[i*16+4] =  p.startTime;
//				_vertexData2[i*16+8] =  p.startTime;
//				_vertexData2[i*16+12] =  p.startTime;
//			}
//			_vertexBufferDirty2 = true ;
//			
//			trace(_particles[0].pastTime , _particleSystem.currentTime - _particles[0].startTime)
//			
			
			if (_vertexBufferDirty || !_vertexBuffer) 
			{
				_vertexBuffer ||= context.createVertexBuffer(_maxVertexNum, 3);
				_vertexBuffer.uploadFromVector(_vertexData0, 0, _maxVertexNum);
				_vertexBufferDirty = false;
			}
			
			if (_vertexBufferDirty1 || !_vertexBuffer1) 
			{
				_vertexBuffer1 ||= context.createVertexBuffer(_maxVertexNum, 4);
				_vertexBuffer1.uploadFromVector( _vertexData1, 0, _maxVertexNum);
				_vertexBufferDirty1 = false;
			}
			
			if (_vertexBufferDirty2 || !_vertexBuffer2) 
			{
				_vertexBuffer2 ||= context.createVertexBuffer(_maxVertexNum, 4);
				_vertexBuffer2.uploadFromVector( _vertexData2, 0, _maxVertexNum);
				_vertexBufferDirty2 = false;
			}
			
			if (_vertexBufferDirty3 || !_vertexBuffer3) 
			{
				_vertexBuffer3 ||= context.createVertexBuffer(_maxVertexNum, 4);
				_vertexBuffer3.uploadFromVector( _vertexData3, 0, _maxVertexNum);
				_vertexBufferDirty3 = false;
			}			
			
			if (_vertexBufferDirty4 || !_vertexBuffer4) 
			{
				_vertexBuffer4 ||= context.createVertexBuffer(_maxVertexNum, 4);
				_vertexBuffer4.uploadFromVector( _vertexData4, 0, _maxVertexNum);
				_vertexBufferDirty4 = false;
			}			
			
			if (_indexBufferDirty || !_indexBuffer) 
			{
				_indexBuffer ||= context.createIndexBuffer(_maxIndexNum);
				_indexBuffer.uploadFromVector(_indexData, 0, _maxIndexNum);
				numTris = int( _particleSystem.maxCapacity * 0.5);
				_indexBufferDirty = false;
			}
			
			if(_programDrity)
			{
				initProgram(context);
				_programDrity = false ;
			}
		}
		
		
		/**
		 * va0		(x,y,z)
		 * va1		(u,v,sizeX,sizeY)
		 * va2		(passtime, lifetime, rot, rotv)
		 * va3		(Vx,Vy,Vz)
		 * va4		(r,g,b,a) 
		 * 
		 * vt0     (passtime / lifetime,null,null,null)
		 * vt1     (cos*x,sin*y,cos*y,sin*x)
		 * vt2     
		 * vt3
		 * vt4
		 * vt5
		 * vt6
		 * vt7
		 */		
		private  function getVertexShader():String
		{
			var vc1:uint;
			var vc2:uint;
			var vci:uint;
			
			
			AGAL.init();
			AGAL.sub("vt0","vc4.w","va2.x");
			AGAL.div("vt0.x" , "vt0.x" , "va2.y");  
			AGAL.sat("vt0.x","vt0.x");// vt0.x =  passtime / lifetime
			
			//sizeAffector: vc 16 , 17 , 18 , 19 [x,y,0,percent]
			if(_particleSystem.sizeAffector.bufferData.length > 4) // 2 frames at least
			{
				//todo:clear vt8
				vc1 = 16;
				AGAL.mov("vt4","vc4.x") //clear
				for(vci = 0 ; vci < AffectorBase.GPU_MAX_FRAMES - 1 ; vci++,vc1++)
				{
					vc2 = vc1 + 1 ;
					AGAL.sge("vt6.x","vt0.x","vc"+vc1+".w"); 
					AGAL.slt("vt6.y","vt0.x","vc"+vc2+".w"); 
					AGAL.mul("vt6.x","vt6.x","vt6.y"); //   (>= frame1 && < frame2)? 1 : 0
					
					AGAL.sub("vt7.x","vt0.x","vc"+vc1+".w"); // p - frame1
					AGAL.mov("vt7.y","vc"+vc2+".w");
					AGAL.sub("vt7.y","vt7.y","vc"+vc1+".w"); // frame2 - frame1
					AGAL.div("vt7.x","vt7.x","vt7.y"); //  weight : vt7.x =  (p - frame1) / (frame2 - frame1)
					
					
					AGAL.mov("vt3.xy","vc"+vc1+".xy");
					AGAL.lerp("vt1.xy","vt3.xy" , "vc"+vc2+".xy","vt7.x");
					
					
					//if
					AGAL.mul("vt1.xy","vt1.xy","vt6.xx");
					AGAL.add("vt4.xy","vt4.xy","vt1.xy");
				}
				
				AGAL.mov("vt7.xy","va1.zw");
				AGAL.abs("vt7.zw","vt7.xy");
				AGAL.div("vt7.xy","vt7.xy","vt7.zw"); // +1 or -1
				
				AGAL.mul("vt7.xy","vt7.xy","vt4.xy"); 
				AGAL.div("vt7.xy","vt7.xy","vc4.zz"); // x,y/2
			}else
			{
				AGAL.mov("vt7.xy","va1.zw"); //vt8 (sizeX,sizeY)
			}
			
			
			
			///////////// rotate
			AGAL.mul("vt3.x","vt0.w","va2.w"); // passTime * rotV 
			AGAL.add("vt3.x","vt3.x","va2.z"); // rot + rotV * passTime
			//new Vector2D( (cos*x) - (sin*y) , (cos*y) + (sin*x) );
			AGAL.sin("vt3.y","vt3.x");
			AGAL.cos("vt3.z","vt3.x");
			AGAL.mul("vt1.x","vt3.z","vt7.x"); // cos*x
			AGAL.mul("vt1.y","vt3.y","vt7.y"); // sin*y
			AGAL.mul("vt1.z","vt3.z","vt7.y"); // cos*y
			AGAL.mul("vt1.w","vt3.y","vt7.x"); // sin*x
			
			AGAL.sub("vt0.y","vt1.x","vt1.y"); //(cos*x) - (sin*y)  
			AGAL.add("vt0.z","vt1.z","vt1.w"); //(cos*y) + (sin*x) 
			
			AGAL.mov("vt2","va0");
			AGAL.add("vt2.xy","va0.xy","vt0.yz"); //vt2 : pos after rotate
			
			// move
			AGAL.mul("vt4.xyz","vt0.www","va3.xyz"); // passTime * V
			AGAL.add("vt2.xy","vt2.xy","vt4.xy"); //vt2 = p + v
			
			AGAL.m44("vt5","vt2","vc0");
			
			AGAL.slt("vt0.x","vt0.w","va2.y"); // if (die) vt0.x =0
			AGAL.mul("op","vt5","vt0.x");
			
			AGAL.sub("v3","vt0.x","vc4.y");
			AGAL.mov("v1","va1"); //uv
			
			
			 
			AGAL.mov("v0","va4"); //color
			
//			var vc1:uint;
//			var vc2:uint;
//			var vci:uint;
//			if(_particleSystem.alphaEffector.bufferData.length > 0)
//			{
//				vc1 = 10;
//				for(vci = 0 ; vci < EffectorBase.GPU_MAX_FRAMES - 1 ; vci++,vc1++)
//				{
//					vc2 = vc1 + 1 ;
//					AGAL.sge("vt6.x","vt0.x","vc"+vc1+".w");
//					AGAL.slt("vt6.y","vt0.x","vc"+vc2+".w");
//					AGAL.mul("vt6.x","vt6.x","vt6.y"); // in
//				}
//				
//			}
			
			

			
			return AGAL.code
		}
		private function getFragmentShader():String
		{
			AGAL.init();
		
			AGAL.kil("v3.x");
			AGAL.tex("ft0","v1","fs0","2d","repeat","nomip");
	      
			AGAL.mul("ft0","ft0","v0.xyz");
			AGAL.mul("ft0","ft0","v0.w");
			AGAL.mov("oc","ft0");
			
			return AGAL.code;
		}
		
		protected var shader:Program3D;
		override protected function initProgram(context:Context3D):void
		{
//			shaderData = ShaderCache.getInstance().getShader(context, this, getVertexShader(), getFragmentShader(), 0, _texture.textureOptions, 0);
			
			//dont use custom texOptions ?
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,getVertexShader());
			
			var colorFragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			colorFragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, getFragmentShader());
			
			shader ||= context.createProgram();
			shader.upload(vertexShaderAssembler.agalcode, colorFragmentShaderAssembler.agalcode);
			
		}
		

		
		private var _commonConst4 : Vector.<Number> = Vector.<Number>([0, 1, 2, 100]);	
		
		override protected function prepareForRender(context:Context3D):void
		{
	
			context.setProgram(shader);
			context.setBlendFactors(blendMode.src, blendMode.dst);
			
			context.setTextureAt(0, _texture.getTexture(context));//fs0

			context.setVertexBufferAt(0,_vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3); //va0 (x,y,z)
			context.setVertexBufferAt(1,_vertexBuffer1,0,Context3DVertexBufferFormat.FLOAT_4);//va1 ( u, v, sizeX, sizeY )
			context.setVertexBufferAt(2,_vertexBuffer2,0,Context3DVertexBufferFormat.FLOAT_4); //va2  (pastTime , lifeTime ,rot,rotVel)
			context.setVertexBufferAt(3,_vertexBuffer3,0,Context3DVertexBufferFormat.FLOAT_4); //va3 V (x,y,z)
			context.setVertexBufferAt(4,_vertexBuffer4,0,Context3DVertexBufferFormat.FLOAT_4); //va4 (r, g, b, a)
			
			refreshClipspaceMatrix();
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, clipSpaceMatrix, true); //vc0~3
			_commonConst4[3] = _particleSystem.currentTime
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,_commonConst4,1);//vc4
			
			prepareAffector(context);
			
		}
		
		private function prepareAffector(context:Context3D):void
		{
//			var alphaEffector:AlphaAffector = _particleSystem.alphaEffector; //vc10~12
//			if(alphaEffector.keyframeCount >0)
//			{
//				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10,alphaEffector.bufferData, alphaEffector.keyframeCount);
//			}
			
			var sizeEffector:SizeAffector = _particleSystem.sizeAffector; // vc 16 , 17 , 18 , 19
			if(sizeEffector.keyframeCount > 0 )
			{
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,16,sizeEffector.bufferData,sizeEffector.keyframeCount);
			}
			
		}
		
		override protected function clearAfterRender(context:Context3D):void
		{
			context.setVertexBufferAt(0,null);
			context.setVertexBufferAt(1,null);
			context.setVertexBufferAt(2,null);
			context.setVertexBufferAt(3,null);
			context.setVertexBufferAt(4,null);
			context.setTextureAt(0, null);
		}
			
		
		override public function handleDeviceLoss():void 
		{
			super.handleDeviceLoss();
			_programDrity = true;
			_indexBuffer = null;
			
			_vertexBuffer = null;
			_vertexBuffer1 = null;
			_vertexBuffer2 = null;
			_vertexBuffer3 = null;
			_vertexBuffer4 = null;
		}
		
		override public function dispose():void
		{
			super.dispose()
			if(_indexBuffer)
			{
				_indexBuffer.dispose();
				_indexBuffer = null ;
			}
			if(_vertexBuffer)
			{
				_vertexBuffer.dispose();
				_vertexBuffer = null ;
			}
			if(_vertexBuffer1)
			{
				_vertexBuffer1.dispose();
				_vertexBuffer1 = null ;
			}
			if(_vertexBuffer2)
			{
				_vertexBuffer2.dispose();
				_vertexBuffer2 = null ;
			}
			if(_vertexBuffer3)
			{
				_vertexBuffer3.dispose();
				_vertexBuffer3 = null ;
			}
			if(_vertexBuffer4)
			{
				_vertexBuffer4.dispose();
				_vertexBuffer4 = null ;
			}
		}
	}
}