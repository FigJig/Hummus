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
		_UVRoundValue("UV Round Value", Float) = 8
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
			uniform float _DissolveDelay;
			uniform float _DissolveValue;
			uniform float _DissolveClamp;
			uniform float _IsHorizontalDissolve;
			uniform float _UVRoundValue;
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
				float2 uv079 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float IsHorizontalDissolveVar95 = (( _IsHorizontalDissolve )?( 1.0 ):( 0.0 ));
				float lerpResult103 = lerp( uv079.y , ( 1.0 - abs( (-1.0 + (uv079.x - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ) , IsHorizontalDissolveVar95);
				float temp_output_6_0_g2 = _UVRoundValue;
				float2 uv_DissolveTexture = IN.texcoord.xy * _DissolveTexture_ST.xy + _DissolveTexture_ST.zw;
				float temp_output_78_0 = ( ( round( ( lerpResult103 * temp_output_6_0_g2 ) ) / temp_output_6_0_g2 ) * tex2D( _DissolveTexture, uv_DissolveTexture ).r );
				float smoothstepResult31 = smoothstep( lerpResult46 , 1.0 , temp_output_78_0);
				float temp_output_6_0_g1 = 12.0;
				float temp_output_82_0 = ( round( ( smoothstepResult31 * temp_output_6_0_g1 ) ) / temp_output_6_0_g1 );
				float2 appendResult49 = (float2(( uv012.x - temp_output_82_0 ) , uv012.y));
				float2 appendResult69 = (float2(uv012.x , ( uv012.y - temp_output_82_0 )));
				float2 lerpResult94 = lerp( appendResult49 , appendResult69 , IsHorizontalDissolveVar95);
				float4 tex2DNode24 = tex2D( _TextureObject, lerpResult94 );
				float lerpResult5 = lerp( 0.0 , tex2DNode24.a , step( temp_output_78_0 , temp_output_51_0 ));
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
171;62;1920;965;4998.835;438.9977;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-4608,-112;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;98;-4320,-208;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;64;-3968,-432;Inherit;False;Property;_IsHorizontalDissolve;Is Horizontal Dissolve;7;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;101;-4128,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;95;-3648,-432;Inherit;False;IsHorizontalDissolveVar;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;-3936,-208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-4080,32;Inherit;False;95;IsHorizontalDissolveVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-3504,96;Inherit;True;Property;_DissolveTexture;Dissolve Texture;3;0;Create;True;0;0;False;0;-1;39f9d8f00052cdc40bd1651fcc2621f6;2727f6231e31c5a438c2d90ae24d6f76;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;81;-3808,112;Inherit;False;Property;_UVRoundValue;UV Round Value;8;0;Create;True;0;0;False;0;8;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;103;-3744,-64;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;83;-3504,-16;Inherit;False;Posterize;1;;2;36f93729c78ffbc4bafcc5d546340c03;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;84;-3200,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3600,416;Inherit;False;Property;_DissolveValue;Dissolve Value;4;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3600,496;Inherit;False;Property;_DissolveClamp;Dissolve Clamp;5;0;Create;True;0;0;False;0;0;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-3104,-16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;58;-2880,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-3408,304;Inherit;False;Property;_DissolveDelay;Dissolve Delay;6;0;Create;True;0;0;False;0;1;-0.321;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;51;-3264,448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-3056,208;Inherit;False;3;0;FLOAT;-0.3;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;3;-2592,304;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;31;-2848,-16;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-2816,208;Inherit;False;Constant;_GlitchPosterize;Glitch Posterize;5;0;Create;True;0;0;False;0;12;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;73;-1520,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-2592,-256;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;71;-1456,336;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;82;-2592,32;Inherit;False;Posterize;1;;1;36f93729c78ffbc4bafcc5d546340c03;0;2;5;FLOAT;0;False;6;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;70;-1328,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;67;-2192,0;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-2192,-240;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1936,-208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;-1936,-48;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;77;-1264,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-2080,112;Inherit;False;95;IsHorizontalDissolveVar;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;-1728,-208;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;76;-1136,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1504,-240;Inherit;True;Property;_TextureObject;Texture Object;0;0;Create;True;0;0;False;0;-1;None;44882186cc6b7014aa91c820e12d9eca;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;72;-1072,240;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-992,64;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-720,0;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-416,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/DissolveShader;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;98;0;79;1
WireConnection;101;0;98;0
WireConnection;95;0;64;0
WireConnection;102;0;101;0
WireConnection;103;0;79;2
WireConnection;103;1;102;0
WireConnection;103;2;97;0
WireConnection;83;5;103;0
WireConnection;83;6;81;0
WireConnection;84;0;4;1
WireConnection;78;0;83;0
WireConnection;78;1;84;0
WireConnection;58;0;78;0
WireConnection;51;0;7;0
WireConnection;51;1;53;0
WireConnection;46;0;54;0
WireConnection;46;2;51;0
WireConnection;3;0;58;0
WireConnection;3;1;51;0
WireConnection;31;0;78;0
WireConnection;31;1;46;0
WireConnection;73;0;3;0
WireConnection;71;0;73;0
WireConnection;82;5;31;0
WireConnection;82;6;63;0
WireConnection;70;0;71;0
WireConnection;67;0;12;2
WireConnection;67;1;82;0
WireConnection;32;0;12;1
WireConnection;32;1;82;0
WireConnection;49;0;32;0
WireConnection;49;1;12;2
WireConnection;69;0;12;1
WireConnection;69;1;67;0
WireConnection;77;0;70;0
WireConnection;94;0;49;0
WireConnection;94;1;69;0
WireConnection;94;2;96;0
WireConnection;76;0;77;0
WireConnection;24;1;94;0
WireConnection;72;0;76;0
WireConnection;5;1;24;4
WireConnection;5;2;72;0
WireConnection;48;0;24;1
WireConnection;48;1;24;2
WireConnection;48;2;24;3
WireConnection;48;3;5;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=07EDEC8339E949567F3CFC9A7DB5C63B24179FAF