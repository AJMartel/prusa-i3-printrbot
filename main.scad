//cube([20,20,10]);

rod_size = 6;
rod_nut_size = 12; //12 for M6, 15 for M8
bearing_size = 12.5; //12.5 for LM6UU, 15.5 for LM8UU,LM8SUU
bearing_length = 19.5; //19.5 for LM6UU, 17.5 for LM8SUU, 24.5 for LM8UU
yz_motor_distance = 25;
motor_screw_spacing = 26; //26 for NEMA14, 31 for NEMA17
motor_casing = 38; //38 for NEMA14, 45 for NEMA17
end_height = 55; //measure the height of your motor casing and add 4mm. Suggestion: 40 for NEMA14, 55 for NEMA17
bed_mount_height = 16;
//x_rod_spacing = motor_screw_spacing + 3 + rod_size;
x_rod_spacing = 30;
x_carriage_width = 70;
carriage_extruder_offset = 5;
pulley_size = 20;
idler_pulley_width = 10;
gusset_size = 15;
m3_size = 3;
m3_nut_size = 6;
m4_size = 4;
motor_shaft_size = 5;

wall_width = 3;

bed_width = 100;
bed_cavity_width = bed_width + (12 * 2);

z_clamp_width = wall_width + rod_size + wall_width + wall_width;
overall_width = bed_cavity_width + (z_clamp_width * 2) + (motor_casing * 2);

echo(overall_width);

/*
translate([0,motor_casing + wall_width + 1,0]) cube([overall_width / 2, 1, motor_casing + wall_width]);
translate([0,motor_casing + wall_width + 2,0]) cube([bed_cavity_width / 2, 1, motor_casing + wall_width]);
translate([bed_cavity_width / 2, motor_casing + wall_width + 3,0]) cube([1, 1, motor_casing + wall_width]);
*/

da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

full();
module full() {
  rotate([90,0,0]) base();
  % bed();
  //y_corners();
}

//base();
module base() {
  union(){
    mirror([1,0,0]) half();
    half();
  }
}

//half();
module half() {
  difference() {
    linear_extrude(height=motor_casing + wall_width) polygon(points=[
      [0,motor_casing + wall_width],
      [overall_width / 2, motor_casing + wall_width],
      [overall_width / 2, motor_casing],
      [(overall_width / 2) - motor_casing, 0],
      [0,0],
    ]);

    // motor mount
    translate([overall_width / 2 - motor_casing, 0, 0]) union() {
      translate([0, 0, wall_width]) cube([motor_casing,motor_casing,motor_casing + 1]);
      translate([0, motor_casing + (wall_width * 1.5), wall_width]) motor_mount();
    }

    // bed cavity
    translate([0,0,0]) bed_cavity();

    // y axis
    y_axis();

    // z axis
    translate([(bed_cavity_width / 2) + wall_width + (rod_size / 2),0, wall_width + motor_casing / 2])
      rotate([90,180/8,0])
      cylinder(r = rod_size * da8, h = 200, $fn = 8, center = true);
  }
}

module bed() {
  translate([-(bed_width /2), -(bed_width / 2 + motor_casing / 2), motor_casing]) cube([bed_width, bed_width, wall_width]);
}

//y_axis();
module y_axis() {
  threaded_y_offset = rod_size + rod_size / 2;
  y_cavity_bottom = threaded_y_offset + rod_size / 2 + rod_size;

  // rods
  translate([bed_width / 2 - 20, 11, 0])
    rotate([0,0,180/8])
    cylinder(r = rod_size * da8, h = 200, $fn = 8, center = true);

  // bed cavity
  translate([0,0,-(motor_casing / 2)])
  linear_extrude(height=motor_casing * 2) polygon(points=[
    // top left clockwise

    // top
    [-1, motor_casing + wall_width + 1],
    [bed_cavity_width / 2 - 1, motor_casing + wall_width],

    // bottom
    [bed_cavity_width / 2 - 1, y_cavity_bottom],
    [-1, y_cavity_bottom],
  ]);
}

//y_corners();
module y_corners() {
  difference() {
    cube([rod_size*2,rod_size*2,rod_size*5]);

    // bottom threaded
    translate([rod_size,rod_size,rod_size])
      rotate([90,180/8,90])
      //cylinder(r = rod_size * da8, h = 200, $fn = 8, center = true);
      cylinder(r = rod_size/2, h = 200, $fn = 30, center = true);

    // connection to base
    translate([rod_size,rod_size,rod_size*2])
      rotate([90,180/8,0])
      //cylinder(r = rod_size * da8, h = 200, $fn = 8, center = true);
      cylinder(r = rod_size/2, h = 200, $fn = 30, center = true);

    // top threaded
    translate([rod_size,rod_size,rod_size*3])
      rotate([90,180/8,90])
      //cylinder(r = rod_size * da8, h = 200, $fn = 8, center = true);
      cylinder(r = rod_size/2, h = 200, $fn = 30, center = true);
  }
}

//motor_mount();
module motor_mount() {
  rotate([90,0,0])
  linear_extrude(height=wall_width * 2) {
    translate([motor_casing / 2, motor_casing / 2, 0]) {
      circle(motor_screw_spacing / 2);

      for(x = [1, -1])
        for(y = [1, -1])
        translate([x * motor_screw_spacing / 2, y * motor_screw_spacing / 2, 0])
        circle(m3_size * da6, $fn = 6);

      translate([-(motor_screw_spacing / 3),-(motor_screw_spacing / 3),0])
        square([motor_casing, motor_casing]);
    }
  }
}
