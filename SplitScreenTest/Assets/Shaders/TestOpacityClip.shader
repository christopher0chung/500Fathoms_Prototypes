// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Test Opacity Clip"
{
	Properties
	{
		[HideInInspector] _VTInfoBlock( "VT( auto )", Vector ) = ( 0, 0, 0, 0 )
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_Albedo("Albedo", 2D) = "white" {}
		_TextureOpacity("Texture Opacity", 2D) = "white" {}
		_2ndNoiseTexture("2nd Noise Texture", 2D) = "white" {}
		_NoiseTexture("Noise Texture", 2D) = "white" {}
		_Falloff("Falloff", Range( 0 , 0.5)) = 1
		_NoiseCutoff("Noise Cutoff", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "Amplify" = "True"  "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _TextureOpacity;
		uniform float4 _TextureOpacity_ST;
		uniform float _Falloff;
		uniform float _NoiseCutoff;
		uniform sampler2D _NoiseTexture;
		uniform float4 _NoiseTexture_ST;
		uniform sampler2D _2ndNoiseTexture;
		uniform float4 _2ndNoiseTexture_ST;
		uniform float _Cutoff = 0.5;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Emission = tex2D( _Albedo, uv_Albedo ).rgb;
			o.Alpha = 1;
			float2 uv_TextureOpacity = i.uv_texcoord * _TextureOpacity_ST.xy + _TextureOpacity_ST.zw;
			float2 uv_NoiseTexture = i.uv_texcoord * _NoiseTexture_ST.xy + _NoiseTexture_ST.zw;
			float mulTime87 = _Time.y * -0.1;
			float cos62 = cos( mulTime87 );
			float sin62 = sin( mulTime87 );
			float2 rotator62 = mul( uv_NoiseTexture - float2( 0.3,0.3 ) , float2x2( cos62 , -sin62 , sin62 , cos62 )) + float2( 0.3,0.3 );
			float2 uv_2ndNoiseTexture = i.uv_texcoord * _2ndNoiseTexture_ST.xy + _2ndNoiseTexture_ST.zw;
			float mulTime88 = _Time.y * 0.1;
			float cos48 = cos( mulTime88 );
			float sin48 = sin( mulTime88 );
			float2 rotator48 = mul( uv_2ndNoiseTexture - float2( 0.7,0.7 ) , float2x2( cos48 , -sin48 , sin48 , cos48 )) + float2( 0.7,0.7 );
			float4 lerpResult90 = lerp( tex2D( _NoiseTexture, rotator62 ) , tex2D( _NoiseTexture, rotator48 ) , 0.5);
			clip( ( ( tex2D( _TextureOpacity, uv_TextureOpacity ) + _Falloff ) * ( _NoiseCutoff + lerpResult90 ) ).r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15201
1267;92;480;655;889.4553;-426.3368;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;79;-2237.58,1306.453;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;-0.1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-2212.136,1836.156;Float;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;False;0;0.1;-10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VirtualTextureObject;84;-2133.015,1410.813;Float;True;Property;_2ndNoiseTexture;2nd Noise Texture;3;0;Create;True;0;0;False;0;None;1209f00aab2177745ae45b7aa855bcb4;False;white;Auto;Unity5;0;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.VirtualTextureObject;25;-2139.858,929.9999;Float;True;Property;_NoiseTexture;Noise Texture;4;0;Create;True;0;0;False;0;None;3e3e36f3a548a1d41bdb94b086e9539d;False;white;Auto;Unity5;0;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-1861.849,1058.444;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;87;-2072.582,1306.021;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;76;-1789.336,1688.481;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;0.7,0.7;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-1855.006,1539.257;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;88;-2033.098,1804.547;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;59;-1807.165,1190.861;Float;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;0.3,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;48;-1489.33,1771.302;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;62;-1512.606,1233.127;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-984.0989,1393.48;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-1094.552,956.7733;Float;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-1092.393,1155.069;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VirtualTextureObject;7;-1427.978,236.6189;Float;True;Property;_TextureOpacity;Texture Opacity;2;0;Create;True;0;0;False;0;None;8d4816a897370344584b304647ce2709;False;white;Auto;Unity5;0;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;90;-767.1249,961.3063;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-901.842,650.1557;Float;False;Property;_NoiseCutoff;Noise Cutoff;6;0;Create;True;0;0;False;0;0;0.6163136;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;23;-1174.759,242.9241;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1999.779,496.4697;Float;True;Property;_Falloff;Falloff;5;0;Create;True;0;0;False;0;1;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.VirtualTextureObject;9;-1036.446,-189.4659;Float;True;Property;_Albedo;Albedo;1;1;[HDR];Create;True;0;0;False;0;None;e0de4819ba5cd50429968f508f5fa86c;False;white;Auto;Unity5;0;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-471.1333,217.6446;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-491.4565,957.7487;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-783.8815,-184.6022;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-179.2142,231.9136;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;18;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Test Opacity Clip;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;0;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;-1;False;-1;-1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;0;False;-1;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;2;25;0
WireConnection;87;0;79;0
WireConnection;85;2;84;0
WireConnection;88;0;83;0
WireConnection;48;0;85;0
WireConnection;48;1;76;0
WireConnection;48;2;88;0
WireConnection;62;0;41;0
WireConnection;62;1;59;0
WireConnection;62;2;87;0
WireConnection;66;0;25;0
WireConnection;66;1;62;0
WireConnection;26;0;25;0
WireConnection;26;1;48;0
WireConnection;90;0;66;0
WireConnection;90;1;26;0
WireConnection;90;2;91;0
WireConnection;23;0;7;0
WireConnection;22;0;23;0
WireConnection;22;1;12;0
WireConnection;92;0;70;0
WireConnection;92;1;90;0
WireConnection;24;0;9;0
WireConnection;27;0;22;0
WireConnection;27;1;92;0
WireConnection;18;2;24;0
WireConnection;18;10;27;0
ASEEND*/
//CHKSM=3C027E1567458F9512B780CE8557E4208D78E1C3