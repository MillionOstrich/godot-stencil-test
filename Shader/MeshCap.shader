shader_type spatial;
render_mode diffuse_toon, depth_draw_alpha_prepass;

stencil {
	value 0;
	test less;
}

uniform vec4 albedo : hint_color;
uniform float specular;

void fragment() {
	ALBEDO = albedo.rgb;
	SPECULAR = specular;
}
