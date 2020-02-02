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
		_TextureObject("Texture Object", 2D) = "white" {}
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_DissolveValue("Dissolve Value", Range( 0 , 1)) = 1
		_DissolveClamp("Dissolve Clamp", Range( 0 , 1)) = 0
		_DissolveDelay("Dissolve Delay", Range( -1 , 0)) = 1
		[Toggle]_IsHorizontalDissolve("Is Horizontal Dissolve", Float) = 0
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
			uniform sampler2D _TextureObject;
			uniform float _IsHorizontalDissolve;
			uniform float _DissolveDelay;
			uniform float _DissolveValue;
			uniform float _DissolveClamp;
			uniform sampler2D _DissolveTexture;
			uniform float4 _DissolveTexture_ST;

			
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
				float temp_output_51_0 = max( _DissolveValue , _DissolveClamp );
				float lerpResult46 = lerp( _DissolveDelay , 1.0 , temp_output_51_0);
				float2 uv_DissolveTexture = IN.texcoord.xy * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
				float4 tex2DNode4 = tex2D( _DissolveTexture, uv_DissolveTexture );
				float smoothstepResult31 = smoothstep( lerpResult46 , 1.0 , tex2DNode4.r);
				float temp_output_62_0 = ( round( ( smoothstepResult31 * 12.0 ) ) / 12.0 );
				float2 appendResult49 = (float2(( uv012.x - temp_output_62_0 ) , uv012.y));
				float2 appendResult69 = (float2(uv012.x , ( uv012.y - temp_output_62_0 )));
				float4 tex2DNode24 = tex2D( _TextureObject, (( _IsHorizontalDissolve )?( appendResult69 ):( appendResult49 )) );
				float lerpResult5 = lerp( 0.0 , tex2DNode24.a , step( tex2DNode4.r , temp_output_51_0 ));
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
62;283;1920;971;1871.124;316.8934;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;53;-3648,400;Inherit;False;Property;_DissolveClamp;Dissolve Clamp;3;0;Create;True;0;0;False;0;0;0.145;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3648,304;Inherit;False;Property;_DissolveValue;Dissolve Value;2;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3488,208;Inherit;False;Property;_DissolveDelay;Dissolve Delay;4;0;Create;True;0;0;False;0;1;-0.3;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;51;-3312,352;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3488,0;Inherit;True;Property;_DissolveTexture;Dissolve Texture;1;0;Create;True;0;0;False;0;-1;39f9d8f00052cdc40bd1651fcc2621f6;39f9d8f00052cdc40bd1651fcc2621f6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;46;-3120,208;Inherit;False;3;0;FLOAT;-0.3;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;57;-3008,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2864,256;Inherit;False;Constant;_RoundValue;Round Value;5;0;Create;True;0;0;False;0;12;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;31;-2928,32;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-2944,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2624,32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;3;-2624,304;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RoundOpNode;61;-2448,32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;-1360,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2448,-240;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;71;-1296,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-2272,32;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-1952,-32;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;70;-1168,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-1952,-240;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;77;-1104,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1763.125,-41.71628;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1776,-208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;64;-1552,-144;Inherit;False;Property;_IsHorizontalDissolve;Is Horizontal Dissolve;5;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;76;-976,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;72;-912,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1200,-240;Inherit;True;Property;_TextureObject;Texture Object;0;0;Create;True;0;0;False;0;-1;None;44882186cc6b7014aa91c820e12d9eca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;5;-832,64;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-560,0;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-256,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/DissolveShader;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;51;0;7;0
WireConnection;51;1;53;0
WireConnection;46;0;54;0
WireConnection;46;2;51;0
WireConnection;57;0;4;1
WireConnection;31;0;4;1
WireConnection;31;1;46;0
WireConnection;58;0;57;0
WireConnection;59;0;31;0
WireConnection;59;1;63;0
WireConnection;3;0;58;0
WireConnection;3;1;51;0
WireConnection;61;0;59;0
WireConnection;73;0;3;0
WireConnection;71;0;73;0
WireConnection;62;0;61;0
WireConnection;62;1;63;0
WireConnection;67;0;12;2
WireConnection;67;1;62;0
WireConnection;70;0;71;0
WireConnection;32;0;12;1
WireConnection;32;1;62;0
WireConnection;77;0;70;0
WireConnection;69;0;12;1
WireConnection;69;1;67;0
WireConnection;49;0;32;0
WireConnection;49;1;12;2
WireConnection;64;0;49;0
WireConnection;64;1;69;0
WireConnection;76;0;77;0
WireConnection;72;0;76;0
WireConnection;24;1;64;0
WireConnection;5;1;24;4
WireConnection;5;2;72;0
WireConnection;48;0;24;1
WireConnection;48;1;24;2
WireConnection;48;2;24;3
WireConnection;48;3;5;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=3D77BB5A83EF94F93211179A617E1659F78111EC