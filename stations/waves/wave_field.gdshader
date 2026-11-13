shader_type spatial;
render_mode cull_back, diffuse_burley, specular_schlick_ggx;

// Surface height and color both come from the same two-source superposition.
uniform vec2 field_cm = vec2(40.0, 28.0);
uniform vec2 s1_cm = vec2(6.0, 8.0);
uniform vec2 s2_cm = vec2(6.0, 20.0);
uniform float k = 3.14;
uniform float omega = 37.7;
uniform float t = 0.0;
uniform float two = 1.0;

varying float wave_value;
varying float nodal_envelope;

void vertex() {
	vec2 p = UV * field_cm;
	float r1 = distance(p, s1_cm);
	float r2 = distance(p, s2_cm);
	float first = cos(k * r1 - omega * t);
	float second = two * cos(k * r2 - omega * t);
	wave_value = first + second;
	nodal_envelope = mix(1.0, abs(cos(0.5 * k * (r2 - r1))), two);
	VERTEX.y += 0.045 * wave_value / (1.0 + two);
}

void fragment() {
	float normalized_height = wave_value / (1.0 + two);
	// One quiet water tone; height varies brightness, the node line marks cancellation.
	float nodes = (1.0 - smoothstep(0.035, 0.16, nodal_envelope)) * two;
	vec3 water = vec3(0.12, 0.25, 0.29);
	ALBEDO = water * (1.0 + 0.22 * normalized_height) + vec3(0.025) * nodes;
	EMISSION = vec3(0.0);
	METALLIC = 0.02;
	ROUGHNESS = 0.78;
}
