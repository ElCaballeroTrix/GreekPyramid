shader_type canvas_item;

uniform float onoff=1;
uniform float intensity=3;
void vertex(){
	VERTEX.y+= cos(TIME*2.0)*cos(TIME*2.0)*intensity*onoff;
}