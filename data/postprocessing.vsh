uniform mat4 projection;
uniform mat4 modelview;

attribute vec4 texCoord;
attribute vec4 position;
attribute vec4 color;
attribute vec2 offset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	gl_Position = projection * modelview * position;
	
	vertColor = color;
	vertTexCoord = texCoord;
}