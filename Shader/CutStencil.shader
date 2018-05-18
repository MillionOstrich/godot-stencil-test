shader_type spatial;
render_mode unshaded, cull_disabled, depth_test_disable;

stencil front {
	test always;
	pass decr_wrap;
}
stencil back {
	test always;
	pass incr_wrap;
}

uniform vec3 cut_position = vec3(0,7,0);
uniform vec3 cut_normal = vec3(0,1,0);
uniform float cut_size = 1;
varying vec3 world_position;

void vertex() {
	world_position = (WORLD_MATRIX * vec4(VERTEX,1)).xyz;
}

void fragment() {
	float cut_middle = dot(cut_position, cut_normal);
	float current = dot(world_position, cut_normal);
	if(abs(current - cut_middle) < cut_size) 
		discard;
}

