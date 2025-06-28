Shader "Lidar" {
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                float2 scrPos : TEXCOORD0;
            };

            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                float4 screenPos = ComputeScreenPos(o.pos);
                o.scrPos = screenPos.xy / screenPos.w;
                return o;
            }

            half4 frag(v2f i) : SV_Target {
                float depth = 1 - Linear01Depth(tex2D(_CameraDepthTexture, i.scrPos).r);
                // hack to get around depth buffer's near clip plane
                if (depth == 0)
                {
                    depth = 1;
                }

                half4 color;
                color.r = depth;
                color.g = depth;
                color.b = depth;
                color.a = 1;

                return color;
                // return half4(1, 1, 1, 1);
                // return half4(1, 1, 1, 1) / (length(i.pos) / 1000);
            }
            ENDCG
        }
    }
}