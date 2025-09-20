include <../utils/misc.scad>

$fn = 360;

inner_diameter = 162;
inner_radius = inner_diameter / 2;
inner_height = 40;
thickness = 4;
outer_diameter = inner_diameter + thickness;
outer_radius = outer_diameter / 2;
fillet_radius_top = 2;
fillet_radius_bottom = 1;

solid();

module solid() {
    shell();
    handle();
}

module shell() {
    rotate_extrude(360) {
        hull() {
            translate([0, inner_height]) {
                square(thickness);
            }
            translate([inner_radius + thickness / 2, inner_height + thickness / 2]) {
                circle(d = thickness);
            }
        }

        hull() {
            translate([inner_radius + thickness / 2, inner_height + thickness / 2]) {
                circle(d = thickness);
            }
            translate([inner_radius + fillet_radius_bottom, fillet_radius_bottom]) {
                circle(fillet_radius_bottom);
            }
            translate([outer_radius + fillet_radius_bottom, fillet_radius_bottom]) {
                circle(fillet_radius_bottom);
            }
        }
    }
}

module handle() {
    translate([0, 0, inner_height + thickness]) {
        // stick
        translate([0, 0, 0]) {
            linear_extrude(10) {
                circle(d = 15);
            }
        }

        // knob
        translate([0, 0, 10]) {
            rotate_extrude(360) {
                hull() {
                    translate([0, -15/2]) {
                        square([10, 15]);
                    }
                    translate([10, 0]) {
                        circle(d = 15);
                    }
                }
            }
        }
    }
}