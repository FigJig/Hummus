// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hummus/Spritesheet Animation"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_SheetCoordinates1("SheetCoordinates", Vector) = (4,4,0,0)
		_FloatingSpeed("Floating Speed", Float) = 0
		_FloatingStrength("Floating Strength", Float) = 0
		_SpriteTexture("Sprite Texture", 2D) = "white" {}
		_AnimSpeed("Anim Speed", Float) = 1

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
			uniform float _FloatingSpeed;
			uniform float _FloatingStrength;
			uniform sampler2D _SpriteTexture;
			uniform float4 _SpriteTexture_ST;
			uniform float2 _SheetCoordinates1;
			uniform float _AnimSpeed;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				float mulTime162 = _Time.y * _FloatingSpeed;
				float2 appendResult165 = (float2(0.0 , ( sin( mulTime162 ) * _FloatingStrength )));
				
				
				IN.vertex.xyz += float3( appendResult165 ,  0.0 ); 
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
				float2 uv0_SpriteTexture = IN.texcoord.xy * _SpriteTexture_ST.xy + _SpriteTexture_ST.zw;
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles158 = _SheetCoordinates1.x * _SheetCoordinates1.y;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset158 = 1.0f / _SheetCoordinates1.x;
				float fbrowsoffset158 = 1.0f / _SheetCoordinates1.y;
				// Speed of animation
				float fbspeed158 = _Time[ 1 ] * _AnimSpeed;
				// UV Tiling (col and row offset)
				float2 fbtiling158 = float2(fbcolsoffset158, fbrowsoffset158);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex158 = round( fmod( fbspeed158 + 0.0, fbtotaltiles158) );
				fbcurrenttileindex158 += ( fbcurrenttileindex158 < 0) ? fbtotaltiles158 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox158 = round ( fmod ( fbcurrenttileindex158, _SheetCoordinates1.x ) );
				// Multiply Offset X by coloffset
				float fboffsetx158 = fblinearindextox158 * fbcolsoffset158;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy158 = round( fmod( ( fbcurrenttileindex158 - fblinearindextox158 ) / _SheetCoordinates1.x, _SheetCoordinates1.y ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy158 = (int)(_SheetCoordinates1.y-1) - fblinearindextoy158;
				// Multiply Offset Y by rowoffset
				float fboffsety158 = fblinearindextoy158 * fbrowsoffset158;
				// UV Offset
				float2 fboffset158 = float2(fboffsetx158, fboffsety158);
				// Flipbook UV
				half2 fbuv158 = uv0_SpriteTexture * fbtiling158 + fboffset158;
				// *** END Flipbook UV Animation vars ***
				
				fixed4 c = tex2D( _SpriteTexture, fbuv158 );
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
0;64;1920;965;1724;135.6374;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;166;-1280,288;Inherit;False;Property;_FloatingSpeed;Floating Speed;1;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-1728,-160;Inherit;True;Property;_SpriteTexture;Sprite Texture;3;0;Create;True;0;0;False;0;None;1ddf6c62ab61e5f45974e173b1aaae88;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;162;-1040,288;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-1408,-64;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;157;-720,-128;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;159;-1408,64;Inherit;False;Property;_SheetCoordinates1;SheetCoordinates;0;0;Create;False;0;0;False;0;4,4;6,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;160;-1408,192;Inherit;False;Property;_AnimSpeed;Anim Speed;4;0;Create;True;0;0;False;0;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;163;-832,288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-896,416;Inherit;False;Property;_FloatingStrength;Floating Strength;2;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;146;-656,-112;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;158;-1088,16;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-608,288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;-544,0;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;165;-384,272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;64;-176,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/Spritesheet Animation;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;162;0;166;0
WireConnection;68;2;65;0
WireConnection;157;0;65;0
WireConnection;163;0;162;0
WireConnection;146;0;157;0
WireConnection;158;0;68;0
WireConnection;158;1;159;1
WireConnection;158;2;159;2
WireConnection;158;3;160;0
WireConnection;168;0;163;0
WireConnection;168;1;167;0
WireConnection;69;0;146;0
WireConnection;69;1;158;0
WireConnection;165;1;168;0
WireConnection;64;0;69;0
WireConnection;64;1;165;0
ASEEND*/
//CHKSM=FB3EE45CD7473721DFD6BBB7A1FE998F0DED162E