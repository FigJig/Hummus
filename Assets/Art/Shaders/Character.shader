// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hummus/Character"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_SpriteTexture("Sprite Texture", 2D) = "white" {}
		_SheetCoordinates("SheetCoordinates", Vector) = (3,3,0,0)
		_AnimSpeed("AnimSpeed", Float) = 1

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
			uniform sampler2D _SpriteTexture;
			uniform float2 _SheetCoordinates;
			uniform float _AnimSpeed;

			
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
				float2 uv029 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles1 = _SheetCoordinates.x * _SheetCoordinates.y;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset1 = 1.0f / _SheetCoordinates.x;
				float fbrowsoffset1 = 1.0f / _SheetCoordinates.y;
				// Speed of animation
				float fbspeed1 = _Time.y * 0.0;
				// UV Tiling (col and row offset)
				float2 fbtiling1 = float2(fbcolsoffset1, fbrowsoffset1);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex1 = round( fmod( fbspeed1 + floor( _AnimSpeed ), fbtotaltiles1) );
				fbcurrenttileindex1 += ( fbcurrenttileindex1 < 0) ? fbtotaltiles1 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox1 = round ( fmod ( fbcurrenttileindex1, _SheetCoordinates.x ) );
				// Multiply Offset X by coloffset
				float fboffsetx1 = fblinearindextox1 * fbcolsoffset1;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy1 = round( fmod( ( fbcurrenttileindex1 - fblinearindextox1 ) / _SheetCoordinates.x, _SheetCoordinates.y ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy1 = (int)(_SheetCoordinates.y-1) - fblinearindextoy1;
				// Multiply Offset Y by rowoffset
				float fboffsety1 = fblinearindextoy1 * fbrowsoffset1;
				// UV Offset
				float2 fboffset1 = float2(fboffsetx1, fboffsety1);
				// Flipbook UV
				half2 fbuv1 = uv029 * fbtiling1 + fboffset1;
				// *** END Flipbook UV Animation vars ***
				
				fixed4 c = tex2D( _SpriteTexture, fbuv1 );
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
0;0;1920;1029;1768.295;523.1133;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;7;-1200,272;Inherit;False;Property;_AnimSpeed;AnimSpeed;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-928,0;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;6;-992,144;Inherit;False;Property;_SheetCoordinates;SheetCoordinates;1;0;Create;True;0;0;False;0;3,3;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;19;-992,368;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;41;-992,272;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1;-640,32;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;2;-352,0;Inherit;True;Property;_SpriteTexture;Sprite Texture;0;0;Create;True;0;0;False;0;-1;2559c24af2a9a9e409a90d223f9399cf;2559c24af2a9a9e409a90d223f9399cf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;40;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/Character;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;41;0;7;0
WireConnection;1;0;29;0
WireConnection;1;1;6;1
WireConnection;1;2;6;2
WireConnection;1;4;41;0
WireConnection;1;5;19;0
WireConnection;2;1;1;0
WireConnection;40;0;2;0
ASEEND*/
//CHKSM=ADC6C85D0604D3C22EF775A2595134793552FF1B