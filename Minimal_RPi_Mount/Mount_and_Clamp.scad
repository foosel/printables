// rpi mount
width = 55;
length = 64;
height = 1.5;
height_spacer = 5;
id = 3;
od = 6.2;
middle = 15;

ir=id/2.0;
or=od/2.0;
$fn = 32;

// clamp
clamp_clearance = 0.7;
clamp_width = (width - 2 * od - middle) / 2 - 2;
clamp_length = 70;
clamp_side_a = 6 + clamp_clearance;
clamp_hook_a = 15;
clamp_side_b = height + clamp_clearance;
clamp_hook_b = od;
clamp_height = 1.2;

module spacer(h) {
    difference() {
        cylinder(r=or, h=h);
        translate([0,0,-0.1]) cylinder(r=ir, h=h+0.2);
    }
}

module plate() {
    inner_width = width - 1.5*od;
    inner_length = length - 1.5*od;

    translate([-or, or, 0])
    rotate([0,0,90])
    union() {
        difference() {
            union() {
                hull() {
                    cylinder(r=or, h=height);
                    translate([width - 2*or, 0, 0]) cylinder(r=or, h=height);
                    translate([width - 2*or, length - 2*or, 0]) cylinder(r=or, h=height);
                    translate([0, length - 2*or, 0]) cylinder(r=or, h=height);
                }

                // spacer
                cylinder(r=or, h=height_spacer);
                translate([width - 2*or, 0, 0]) cylinder(r=or, h=height_spacer);
                translate([width - 2*or, length - 2*or, 0]) cylinder(r=or, h=height_spacer);
                translate([0, length - 2*or, 0]) cylinder(r=or, h=height_spacer);
            }

            // holes
            translate([0, 0, -0.1]) cylinder(r=ir, h=height_spacer+0.2);
            translate([width - 2*or, 0, -0.1]) cylinder(r=ir, h=height_spacer+0.2);
            translate([width - 2*or, length - 2*or, -0.1]) cylinder(r=ir, h=height_spacer+0.2);
            translate([0, length - 2*or, -0.1]) cylinder(r=ir, h=height_spacer+0.2);

            // space
            translate([1.5*or, 1.5*or, -0.1]) {
                hull() {
                    cylinder(r=or, h=height+0.2);
                    translate([inner_width - 2*or, 0, 0]) cylinder(r=or, h=height+0.2);
                    translate([inner_width - 2*or, inner_length - 2*or, 0]) cylinder(r=or, h=height+0.2);
                    translate([0, inner_length - 2*or, 0]) cylinder(r=or, h=height+0.2);
                }
            }
        }

        translate([(width / 2 - or) - middle / 2, 0, 0]) cube([middle, length - or, height]);
    }
}

module clamp() {
    translate([0,0,clamp_width])
    rotate([0,90,90])
    union() {
        cube([clamp_width, clamp_length, clamp_height]);

        // hook side a
        cube([clamp_width, clamp_height, clamp_side_a + 2*clamp_height]);
        translate([0, 0, clamp_side_a + clamp_height]) cube([clamp_width, clamp_hook_a + clamp_height, clamp_height]);

        // hook side b
        translate([0, clamp_length - clamp_height, - clamp_side_b - clamp_height]) cube([clamp_width, clamp_height, clamp_side_b + 2*clamp_height]);
        translate([0, clamp_length - clamp_height - clamp_hook_b, - clamp_side_b - clamp_height]) cube([clamp_width, clamp_hook_b + clamp_height, clamp_height]);
    }

}

module two_clamps() {
    y_shift = - clamp_side_a - 2 * clamp_height - 3;
    translate([0,y_shift,0]) clamp();
    translate([0,2*y_shift,0]) clamp();
}

// to fit on 10x10 print bed, build only plate
// or two_clamps a time

plate();
two_clamps();
