#version 300 es

precision highp float;

layout(location = 0) in vec2 inPosition;
layout(location = 1) in vec2 inVelocity;
layout(location = 2) in float inTime;
layout(location = 3) in float inDuration;

out vec2 outPosition;
out float outTime;
out vec2 outTexturePosition;

out float alpha;

uniform float reset;
uniform float time;
uniform float deltaTime;
uniform vec2 size;
uniform float r;
uniform float seed;
uniform float longevity;

float rand(vec2 n) {
	return fract(sin(dot(n,vec2(12.9898,4.1414-seed*.42)))*4375.5453);
}

void main() {
  vec2 position = inPosition;
  float particleDuration = inDuration;
  float particleTime = inTime + deltaTime * particleDuration / longevity;
  float spacePoints = ((size.x * size.y) / 20000.0) - (5.0 * cos(float(gl_VertexID)));

  float x = float(gl_VertexID) * spacePoints / size.x;

  if (float(gl_VertexID) * spacePoints > size.x) {
      x-= floor(float(gl_VertexID) * spacePoints / size.x);
  }

  float y = floor(float(gl_VertexID) / size.x) * spacePoints / size.y;

  if (y > 1.0) {
     y = 1.0;
  }

  if (x > 1.0) {
       x = 1.0;
   }

  position = size * vec2(x,y);

  if (reset > 0.) {
    particleTime = rand(vec2(-94.3, 83.9) * vec2(gl_VertexID, gl_VertexID));
    particleDuration = .5 + 2. * rand(vec2(gl_VertexID) + seed * 32.4);
  } else if (particleTime >= 1.) {
    particleTime = 0.0;
    particleDuration = .5 + 2. * rand(vec2(gl_VertexID) + position);
  }

  position = fract(position / size) * size;

  outTexturePosition = vec4((position / size * 2.0 - vec2(1.0)), 0.0, 1.0).xy / vec2(2.0, 2.0) + vec2(0.5, 0.5);

  float ind = (cos(float(gl_VertexID)) / 5.0);
  if (ind < 0.0) {
      ind = 0.0;
  }
  float stepMoving = 0.2;
  float liveTime = 1.0;
  float speed = 0.1;
  alpha = 1.0;

  if (time > (liveTime * x) - (liveTime / size.x)) {
     position.y = size.y * (y + ind + ((time - (liveTime * x)) * (1.0 / liveTime)));
     position.x = position.x + (size.x * (cos(float(gl_VertexID) + time) / 20.0));
     alpha = 1.0 - ((position.y / size.y) - (3.0 / position.x));
  }



  outPosition = position;
  outTime = particleTime;

  gl_PointSize = r;
  gl_Position = vec4((position / size * 2.0 - vec2(1.0)), 0.0, 1.0);
}
