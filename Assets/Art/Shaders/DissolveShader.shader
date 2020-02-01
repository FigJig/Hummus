// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hummus/DissolveShader"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_TextureToDissolve("Texture To Dissolve", 2D) = "white" {}
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_DissolveValue("Dissolve Value", Range( 0 , 1)) = 1
		_DissolveDelay("Dissolve Delay", Range( -1 , 0)) = 1
		_DissolveClamp("Dissolve Clamp", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _TextureToDissolve;
			uniform float _DissolveDelay;
			uniform float _DissolveValue;
			uniform sampler2D _DissolveTexture;
			uniform float4 _DissolveTexture_ST;
			uniform float4 _TextureToDissolve_ST;
			uniform float _DissolveClamp;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv012 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float lerpResult46 = lerp( _DissolveDelay , 1.0 , _DissolveValue);
				float2 uv_DissolveTexture = IN.texcoord.xy * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
				float4 tex2DNode4 = tex2D( _DissolveTexture, uv_DissolveTexture );
				float smoothstepResult31 = smoothstep( lerpResult46 , 1.0 , tex2DNode4.r);
				float2 appendResult49 = (float2(( uv012.x - smoothstepResult31 ) , uv012.y));
				float4 tex2DNode24 = tex2D( _TextureToDissolve, appendResult49 );
				float2 uv_TextureToDissolve = IN.texcoord.xy * _TextureToDissolve_ST.xy + _TextureToDissolve_ST.zw;
				float lerpResult5 = lerp( 0.0 , tex2D( _TextureToDissolve, uv_TextureToDissolve ).a , step( tex2DNode4.r , max( _DissolveValue , _DissolveClamp ) ));
				float4 appendResult48 = (float4(tex2DNode24.r , tex2DNode24.g , tex2DNode24.b , lerpResult5));
				
				fixed4 c = appendResult48;
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
658;73;892;938;2510.263;389.5853;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;54;-2768,240;Inherit;False;Property;_DissolveDelay;Dissolve Delay;3;0;Create;True;0;0;False;0;1;-0.3;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2768,336;Inherit;False;Property;_DissolveValue;Dissolve Value;2;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-2768,32;Inherit;True;Property;_DissolveTexture;Dissolve Texture;1;0;Create;True;0;0;False;0;-1;39f9d8f00052cdc40bd1651fcc2621f6;39f9d8f00052cdc40bd1651fcc2621f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;46;-2400,240;Inherit;False;3;0;FLOAT;-0.3;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2768,-256;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;57;-2288,160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;31;-2208,64;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-2768,432;Inherit;False;Property;_DissolveClamp;Dissolve Clamp;4;0;Create;True;0;0;False;0;0;0.13;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;51;-2400,368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-2224,304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-1712,-240;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-2768,-480;Inherit;True;Property;_TextureToDissolve;Texture To Dissolve;0;0;Create;True;0;0;False;0;None;44882186cc6b7014aa91c820e12d9eca;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;6;-1168,0;Inherit;True;Property;_Rosette;Rosette;0;0;Create;True;0;0;False;0;-1;44882186cc6b7014aa91c820e12d9eca;44882186cc6b7014aa91c820e12d9eca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1536,-208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;3;-1904,336;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-832,160;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1200,-240;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-1904,64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-577.4652,-152.1054;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RoundOpNode;61;-1728,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-256,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/DissolveShader;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;46;0;54;0
WireConnection;46;2;7;0
WireConnection;57;0;4;1
WireConnection;31;0;4;1
WireConnection;31;1;46;0
WireConnection;51;0;7;0
WireConnection;51;1;53;0
WireConnection;58;0;57;0
WireConnection;32;0;12;1
WireConnection;32;1;31;0
WireConnection;6;0;23;0
WireConnection;49;0;32;0
WireConnection;49;1;12;2
WireConnection;3;0;58;0
WireConnection;3;1;51;0
WireConnection;5;1;6;4
WireConnection;5;2;3;0
WireConnection;24;0;23;0
WireConnection;24;1;49;0
WireConnection;59;0;31;0
WireConnection;48;0;24;1
WireConnection;48;1;24;2
WireConnection;48;2;24;3
WireConnection;48;3;5;0
WireConnection;61;0;59;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=50AEA625D39A80C36F9DE3A62A8C3C5A7575945A