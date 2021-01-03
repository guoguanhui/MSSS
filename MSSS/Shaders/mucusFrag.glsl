#version 330 core

uniform sampler2D texture_diffuse1;

in vec2 TexCoords;
in vec3 normalDirection;
in vec3 tangentDirection;
in vec3 WorldPos;

uniform vec3 lightPosition;
uniform vec3 lightColor;
uniform vec3 camPos;
out vec4 FragColor;

void main(void) {
	//���ʵ�����
	float _AlphaX=0.2f;
	float _AlphaY=0.2f;
	vec4 _Color=vec4(1,1,1,1); 
	vec4 _SpecColor=vec4(1,1,1,1);

	vec3 viewDirection = normalize(camPos - vec3(WorldPos));
    vec3 lightDirection;
    float attenuation;

	vec3 vertexToLightSource = vec3(lightPosition - WorldPos);
	float distance = length(vertexToLightSource);
	attenuation = 1.0 / distance; // linear attenuation 
	lightDirection = normalize(vertexToLightSource);
            
    vec3 halfwayVector = normalize(lightDirection + viewDirection);
	vec3 binormalDirection = cross(normalDirection, tangentDirection);
    float dotLN = dot(lightDirection, normalDirection); // compute this dot product only once
    
	//������
	//vec3 ambientLighting = vec3(gl_LightModel.ambient) * vec3(_Color);
	vec3 ambientLighting= vec3(texture(texture_diffuse1, TexCoords));
	
	//������
    vec3 diffuseReflection = attenuation * vec3(lightColor) * vec3(_Color) * max(0.0, dotLN);
            
	//���淴��
    vec3 specularReflection;
    if (dotLN < 0.0) // light source on the wrong side?
    {
        specularReflection = vec3(0.0, 0.0, 0.0);  // no specular reflection
    }
    else // light source on the right side
    {
        float dotHN = dot(halfwayVector, normalDirection);
        float dotVN = dot(viewDirection, normalDirection);
        float dotHTAlphaX = dot(halfwayVector, tangentDirection) / _AlphaX;
        float dotHBAlphaY = dot(halfwayVector, binormalDirection) / _AlphaY;

        specularReflection = attenuation * vec3(_SpecColor) * sqrt(max(0.0, dotLN / dotVN)) * exp(-2.0 * (dotHTAlphaX * dotHTAlphaX + dotHBAlphaY * dotHBAlphaY) / (1.0 + dotHN));
    }
	vec4 texColor = texture(texture_diffuse1, TexCoords);//������ʱ��ȡalphaͨ��ֵ���ж�����С��ĳ��ֵ����͸������ɫ�����������ʹ�ù���ģ�͵���ɫ
	
	if(texColor.a < 0.2)//0.5
       FragColor = texture(texture_diffuse1, TexCoords);
	else
		FragColor = vec4(ambientLighting + diffuseReflection + specularReflection, 0.5);//0.5
   
	
	//���ӹ��յȣ���Ҫ���յĻ�����ע��
    FragColor = texture(texture_diffuse1, TexCoords);
}