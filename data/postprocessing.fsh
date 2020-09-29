#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	gl_FragColor = texture(texture, vertTexCoord.st);
	gl_FragColor = vec4(0, 0, 0, 1);
}