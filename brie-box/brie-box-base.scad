include <../utils/misc.scad>

$fn = 360;

inner_diameter = 160;
outer_diameter = 180;
handle_length = 10;
layer_height = 4;
handle_thickness = 4;
handle_connection_angle = 20;
fillet_radius = 1;


solid();

module solid() {
    points = [
            [0, layer_height * 3],
            [0, 0],
            [inner_diameter / 2, 0],
            [inner_diameter / 2, layer_height],
            [outer_diameter / 2 - fillet_radius, layer_height],
            [outer_diameter / 2 - fillet_radius, layer_height * 2],
            [inner_diameter / 2, layer_height * 2],
            [inner_diameter / 2, layer_height * 3]
        ];

    rotate_extrude(360) {
        polygon(points = points);
        outer_fillet();
        handle_ring_with_fillet();
    }
    handle_connections();
}

module outer_fillet() {
    translate([outer_diameter / 2 - handle_thickness, layer_height * 1]) {
        rounded_rectangle(handle_thickness, handle_thickness, fillet_radius);
    }
}

module handle_ring_with_fillet() {
    translate([outer_diameter / 2 + handle_length, layer_height]) {
        rounded_rectangle(handle_thickness, handle_thickness, fillet_radius);
    }
}

module handle_connections() {
    rotations = [0, 90, 180, 270];
    for (r = rotations) {
        rotate(90, [0, 1, 0]) {
            rotate(r - handle_connection_angle / 2, [1, 0, 0]) {
                translate([-handle_thickness / 2 - layer_height/2 - layer_height, -handle_thickness / 2, 0]) {
                    #linear_extrude(outer_diameter / 2 + handle_length + fillet_radius) {
                        rounded_rectangle(handle_thickness, handle_thickness, fillet_radius);
                    }
                }
            }
            rotate(r + handle_connection_angle / 2, [1, 0, 0]) {
                translate([-handle_thickness / 2 - layer_height/2 - layer_height, -handle_thickness / 2, 0]) {
                    #linear_extrude(outer_diameter / 2 + handle_length + fillet_radius) {
                        rounded_rectangle(handle_thickness, handle_thickness, fillet_radius);
                    }
                }
            }
        }
        rotate(r - handle_connection_angle / 2) {
            rotate_extrude(handle_connection_angle) {
                translate([0, layer_height]) {
                    square([outer_diameter / 2 + handle_length + fillet_radius, layer_height]);
                }
            }
        }
    }
}