shader_type canvas_item;
render_mode unshaded;


void fragment(){
	COLOR=texture(TEXTURE,UV);
	float luminosidad=COLOR.r * 0.2126 + COLOR.g * 0.7152 + COLOR.b * 0.0722;
	COLOR.rgb=vec3(luminosidad);
}