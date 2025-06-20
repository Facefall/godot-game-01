shader_type canvas_item;
//render_mode skip_vertex_transform;

uniform float shake_intensity = 0.0;
uniform float shake_speed = 20;

//顶点函数，用于调整每个像素的顶点，产生摇晃效果
void vertex() {
	vec2 shake = vec2(0, 0);
	//godot 中 y值是负值，树在y轴以上
	if(VERTEX.y < 0.0){
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	VERTEX.xy += shake;
}
