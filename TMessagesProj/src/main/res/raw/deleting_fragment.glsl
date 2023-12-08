#version 300 es

precision highp float;

uniform sampler2D uTexture;

in float alpha;
in vec2 outTexturePosition;
out vec4 fragColor;

void main() {
  vec4 color = texture(uTexture, vec2(outTexturePosition.x, outTexturePosition.y));
  if (color.w > alpha) {
    color.w = alpha;
  }

  fragColor = color;
}
