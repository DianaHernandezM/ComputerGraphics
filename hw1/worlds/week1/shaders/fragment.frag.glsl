#version 300 es
precision highp float;

uniform float uTime;   // TIME, IN SECONDS
in vec3 vPos;     // -1 < vPos.x < +1
// -1 < vPos.y < +1
//      vPos.z == 0

out vec4 fragColor; 
 
void main() {

  // HERE YOU CAN WRITE ANY CODE TO
  // DEFINE A COLOR FOR THIS FRAGMENT

  float red   = max(0., vPos.x);
  float green = max(0.1, vPos.y);
  float blue  = max(0.5, sin(13.5 * uTime));
  
  // R,G,B EACH RANGE FROM 0.0 TO 1.0  
  vec3 color = vec3(red, green, blue);
    
  // THIS LINE OUTPUTS THE FRAGMENT COLOR
vec3 locvpos = vPos;

vec4 v4 = vec4(vec3(vec2(uTime), .2), 0.5);
vec2 v2 = v4.yy;
locvpos.x += sin(noise(vec3(uTime)));
if ( locvpos.x < 0.0) {
  fragColor = vec4(vec3(1.0), 1.0);
} else {
fragColor = vec4(vec3(1.0, 0.0, 0.0), 1.0);
}
}