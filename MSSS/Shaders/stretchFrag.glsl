#version 330 core

float scale = 1.0;

in Vertex {
	vec3 worldPos;
} IN;

out vec4 fragColor;

//��������ļ���ǳ���Ч�����Լ���ÿ֡�߶ȱ�������
//����ռ����������ռ䵼�������˾ֲ�����ľ�ȷ���ƣ�Ȼ���䷴ת��ֱ�ӳ���ģ����ȡ�������Ҫһ����������ֵ���ŵ�[0,1]��Χ��
vec2 computeStretchMap(vec3 worldPos, float scale) {      
    vec3 derivu = dFdx(worldPos);
    vec3 derivv = dFdy(worldPos);
	
    float stretchU = scale / length( derivu );
    float stretchV = scale / length( derivv );
	
    return vec2( stretchU, stretchV ); // two component texture color
}

void main(void) {
	vec2 outColour = computeStretchMap(IN.worldPos, scale);
	fragColor = vec4(outColour.xy, 0.0, 1.0);
}