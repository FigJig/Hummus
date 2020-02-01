// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hummus/OutlinedSprite"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_OutlinedTexture("Outlined Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,1,0.07855153,1)
		[Toggle]_OutlineSwitch("OutlineSwitch", Float) = 1
		_FlashSpeed("FlashSpeed", Float) = 0
		_InteractiveColor("Interactive Color", Color) = (0.5019608,0.5019608,0.5019608,0.5019608)

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
			#include "UnityShaderVariables.cginc"


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
			uniform float _OutlineSwitch;
			uniform sampler2D _OutlinedTexture;
			uniform float4 _OutlinedTexture_ST;
			uniform float4 _OutlineColor;
			uniform float _FlashSpeed;
			uniform float4 _InteractiveColor;
			uniform float4 _OutlinedTexture_TexelSize;

			
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
				float2 uv0_OutlinedTexture = IN.texcoord.xy * _OutlinedTexture_ST.xy + _OutlinedTexture_ST.zw;
				float4 tex2DNode69 = tex2D( _OutlinedTexture, uv0_OutlinedTexture );
				float mulTime124 = _Time.y * _FlashSpeed;
				float4 lerpResult113 = lerp( float4( 0,0,0,0 ) , _OutlineColor , (0.8 + (sin( mulTime124 ) - -1.0) * (1.0 - 0.8) / (1.0 - -1.0)));
				float4 lerpResult161 = lerp( tex2DNode69 , ( tex2DNode69.a * _InteractiveColor ) , _InteractiveColor.a);
				float2 temp_output_32_0_g29 = uv0_OutlinedTexture;
				float4 tex2DNode22_g29 = tex2D( _OutlinedTexture, temp_output_32_0_g29 );
				float2 appendResult5_g29 = (float2(_OutlinedTexture_TexelSize.x , 0.0));
				float2 appendResult6_g29 = (float2(0.0 , _OutlinedTexture_TexelSize.y));
				float4 lerpResult39_g29 = lerp( lerpResult113 , lerpResult161 , step( 0.0 , ( tex2DNode22_g29.a - max( max( tex2D( _OutlinedTexture, ( temp_output_32_0_g29 + appendResult5_g29 ) ).a , tex2D( _OutlinedTexture, ( temp_output_32_0_g29 - appendResult5_g29 ) ).a ) , max( tex2D( _OutlinedTexture, ( temp_output_32_0_g29 + appendResult6_g29 ) ).a , tex2D( _OutlinedTexture, ( temp_output_32_0_g29 - appendResult6_g29 ) ).a ) ) ) ));
				
				fixed4 c = (( _OutlineSwitch )?( lerpResult39_g29 ):( tex2DNode69 ));
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
71;719;1920;1029;2608.731;95.7597;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;119;-2528,-48;Inherit;False;1649.841;576.4795;;12;165;69;158;161;164;163;162;146;157;68;65;166;Outline calculations;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;122;-2640,-544;Inherit;False;1083.8;439;;6;117;92;125;124;113;121;Outline color and flashing;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-2496,0;Inherit;True;Property;_OutlinedTexture;Outlined Texture;2;0;Create;True;0;0;False;0;None;44882186cc6b7014aa91c820e12d9eca;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2608,-288;Inherit;False;Property;_FlashSpeed;FlashSpeed;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;157;-1952,32;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;124;-2400,-288;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-2176,96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;146;-1904,48;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SinOpNode;125;-2192,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-1840,112;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;162;-1776,320;Inherit;False;Property;_InteractiveColor;Interactive Color;6;0;Create;True;0;0;False;0;0.5019608,0.5019608,0.5019608,0.5019608;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-1520,256;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;92;-2048,-496;Inherit;False;Property;_OutlineColor;Outline Color;3;0;Create;True;0;0;False;0;0,1,0.07855153,1;0,1,0.07855153,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;163;-1792,48;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;117;-2032,-288;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.8;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;113;-1728,-496;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;158;-1952,32;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;160;-624,144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;164;-1744,48;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;161;-1328,192;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;159;-576,144;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;165;-1168,0;Inherit;False;Outline2D;0;;29;c67b2c9f1f918d840b11b72b724b0848;0;4;2;SAMPLER2D;0;False;32;FLOAT2;0,0;False;25;COLOR;0,0,0,0;False;40;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;112;-480,0;Inherit;False;Property;_OutlineSwitch;OutlineSwitch;4;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;64;-176,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/OutlinedSprite;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;157;0;65;0
WireConnection;124;0;121;0
WireConnection;68;2;65;0
WireConnection;146;0;157;0
WireConnection;125;0;124;0
WireConnection;69;0;146;0
WireConnection;69;1;68;0
WireConnection;166;0;69;4
WireConnection;166;1;162;0
WireConnection;163;0;68;0
WireConnection;117;0;125;0
WireConnection;113;1;92;0
WireConnection;113;2;117;0
WireConnection;158;0;65;0
WireConnection;160;0;69;0
WireConnection;164;0;163;0
WireConnection;161;0;69;0
WireConnection;161;1;166;0
WireConnection;161;2;162;4
WireConnection;159;0;160;0
WireConnection;165;2;158;0
WireConnection;165;32;164;0
WireConnection;165;25;113;0
WireConnection;165;40;161;0
WireConnection;112;0;159;0
WireConnection;112;1;165;0
WireConnection;64;0;112;0
ASEEND*/
//CHKSM=A5731F6342C901E6B427108B3DA4449B7EA8693B