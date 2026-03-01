shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  float d = pow(UV.x - 0.5, 2) + pow(UV.y - 0.5, 2);
	if (d > 0.25) COLOR.a = 0.0;
  else {
    COLOR.a = 0.15 * sin(TIME * 3.0) * (1.0 * sin(UV.x * 5.0 + UV.y *5.0)) + 0.4;
    if (UV.y < 0.2 || UV.y > 0.8) COLOR.rgb = vec3(85.0/255.0, 205.0/255.0, 252.0/255.0);
  
    else if (UV.y < 0.4 || UV.y > 0.6) COLOR.rgb = vec3(247.0/255.0, 168.0/255.0, 184.0/255.0);
    
  }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
