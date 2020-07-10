varying vec4 vpos;
 
 
#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    vpos = vertex_position;
    return transform_projection * vertex_position;
}
#endif
 
#ifdef PIXEL


vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  return pixel + (color * color.a) * pixel.a;
}
#endif