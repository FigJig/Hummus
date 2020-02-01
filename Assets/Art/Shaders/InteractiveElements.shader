// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Hummus/InteractiveElements"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_SheetCoordinates("SheetCoordinates", Vector) = (3,3,0,0)
		_AnimLerp("AnimLerp", Range( 0 , 1)) = 1
		_SpriteTexture("Sprite Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,1,0.07855153,1)
		[Toggle]_OutlineSwitch("OutlineSwitch", Float) = 1
		_FlashSpeed("FlashSpeed", Float) = 0

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
			uniform sampler2D _SpriteTexture;
			uniform float4 _SpriteTexture_ST;
			uniform float2 _SheetCoordinates;
			uniform float _AnimLerp;
			uniform float4 _OutlineColor;
			uniform float _FlashSpeed;
			uniform float4 _SpriteTexture_TexelSize;

			
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
				float2 uv0_SpriteTexture = IN.texcoord.xy * _SpriteTexture_ST.xy + _SpriteTexture_ST.zw;
				float lerpResult5_g27 = lerp( 0.0 , ( ( _SheetCoordinates.x * _SheetCoordinates.y ) - 1.0 ) , _AnimLerp);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles6_g27 = _SheetCoordinates.x * _SheetCoordinates.y;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset6_g27 = 1.0f / _SheetCoordinates.x;
				float fbrowsoffset6_g27 = 1.0f / _SheetCoordinates.y;
				// Speed of animation
				float fbspeed6_g27 = _Time[ 1 ] * 0.0;
				// UV Tiling (col and row offset)
				float2 fbtiling6_g27 = float2(fbcolsoffset6_g27, fbrowsoffset6_g27);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex6_g27 = round( fmod( fbspeed6_g27 + lerpResult5_g27, fbtotaltiles6_g27) );
				fbcurrenttileindex6_g27 += ( fbcurrenttileindex6_g27 < 0) ? fbtotaltiles6_g27 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox6_g27 = round ( fmod ( fbcurrenttileindex6_g27, _SheetCoordinates.x ) );
				// Multiply Offset X by coloffset
				float fboffsetx6_g27 = fblinearindextox6_g27 * fbcolsoffset6_g27;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy6_g27 = round( fmod( ( fbcurrenttileindex6_g27 - fblinearindextox6_g27 ) / _SheetCoordinates.x, _SheetCoordinates.y ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy6_g27 = (int)(_SheetCoordinates.y-1) - fblinearindextoy6_g27;
				// Multiply Offset Y by rowoffset
				float fboffsety6_g27 = fblinearindextoy6_g27 * fbrowsoffset6_g27;
				// UV Offset
				float2 fboffset6_g27 = float2(fboffsetx6_g27, fboffsety6_g27);
				// Flipbook UV
				half2 fbuv6_g27 = uv0_SpriteTexture * fbtiling6_g27 + fboffset6_g27;
				// *** END Flipbook UV Animation vars ***
				float2 temp_output_155_0 = fbuv6_g27;
				float4 tex2DNode69 = tex2D( _SpriteTexture, temp_output_155_0 );
				float mulTime124 = _Time.y * _FlashSpeed;
				float4 lerpResult113 = lerp( float4( 0,0,0,0 ) , _OutlineColor , (0.8 + (sin( mulTime124 ) - -1.0) * (1.0 - 0.8) / (1.0 - -1.0)));
				float2 temp_output_32_0_g28 = temp_output_155_0;
				float4 tex2DNode22_g28 = tex2D( _SpriteTexture, temp_output_32_0_g28 );
				float2 appendResult5_g28 = (float2(_SpriteTexture_TexelSize.x , 0.0));
				float2 appendResult6_g28 = (float2(0.0 , _SpriteTexture_TexelSize.y));
				float4 lerpResult39_g28 = lerp( lerpResult113 , tex2DNode69 , step( 0.0 , ( tex2DNode22_g28.a - max( max( tex2D( _SpriteTexture, ( temp_output_32_0_g28 + appendResult5_g28 ) ).a , tex2D( _SpriteTexture, ( temp_output_32_0_g28 - appendResult5_g28 ) ).a ) , max( tex2D( _SpriteTexture, ( temp_output_32_0_g28 + appendResult6_g28 ) ).a , tex2D( _SpriteTexture, ( temp_output_32_0_g28 - appendResult6_g28 ) ).a ) ) ) ));
				
				fixed4 c = (( _OutlineSwitch )?( lerpResult39_g28 ):( tex2DNode69 ));
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
244;659;1920;1029;3359.844;617.9141;2.145343;True;True
Node;AmplifyShaderEditor.CommentaryNode;122;-2128,-544;Inherit;False;1083.8;439;;6;117;92;125;124;113;121;Outline color and flashing;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2096,-288;Inherit;False;Property;_FlashSpeed;FlashSpeed;8;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;119;-2528,-48;Inherit;False;1900.105;418.0935;;4;69;146;68;65;Outline calculations;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;124;-1888,-288;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-2480,0;Inherit;True;Property;_SpriteTexture;Sprite Texture;5;0;Create;True;0;0;False;0;None;119448290009f554eb771cd22f734cad;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SinOpNode;125;-1680,-288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;68;-2176,96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;117;-1520,-288;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.8;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;92;-1536,-496;Inherit;False;Property;_OutlineColor;Outline Color;6;0;Create;True;0;0;False;0;0,1,0.07855153,1;0,1,0.1240954,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;146;-1408,48;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;155;-1840,96;Inherit;False;SpritesheetAnimationLerp;2;;27;5d3010d9275652445a7065dd821b424a;0;1;9;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;113;-1216,-496;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;69;-1296,160;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;156;-944,0;Inherit;False;Outline2D;0;;28;c67b2c9f1f918d840b11b72b724b0848;0;4;2;SAMPLER2D;0;False;32;FLOAT2;0,0;False;25;COLOR;0,0,0,0;False;40;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;112;-480,0;Inherit;False;Property;_OutlineSwitch;OutlineSwitch;7;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;64;-176,0;Float;False;True;-1;2;ASEMaterialInspector;0;6;Hummus/InteractiveElements;0f8ba0101102bb14ebf021ddadce9b49;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;124;0;121;0
WireConnection;125;0;124;0
WireConnection;68;2;65;0
WireConnection;117;0;125;0
WireConnection;146;0;65;0
WireConnection;155;9;68;0
WireConnection;113;1;92;0
WireConnection;113;2;117;0
WireConnection;69;0;146;0
WireConnection;69;1;155;0
WireConnection;156;2;65;0
WireConnection;156;32;155;0
WireConnection;156;25;113;0
WireConnection;156;40;69;0
WireConnection;112;0;69;0
WireConnection;112;1;156;0
WireConnection;64;0;112;0
ASEEND*/
//CHKSM=9BACFBF3D093178EE1837F9509B598F4347506F8