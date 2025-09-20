include <../utils/skadis/constants.scad>

height = 10;
hook_width = SKADIS_HOLE_WIDTH - 0.5;
hook_height = SKADIS_HOLE_HEIGHT;
neck_width = hook_width;
neck_length = SKADIS_HOLE_DEPTH;
adapter_base_depth = SKADIS_HOOK_ADAPTER_INNER_DEPTH + SKADIS_HOOK_ADAPTER_OUTER_DEPTH;
adapter_width = SKADIS_HOOK_ADAPTER_INNER_WIDTH;

hook_type = "straight"; // [straight, twist]

model();

$fn = 100;

module model() {
    depth0 = 0;
    depth1 = depth0 + SKADIS_HOOK_ADAPTER_INNER_DEPTH;
    depth2 = depth1 + SKADIS_HOOK_ADAPTER_OUTER_DEPTH;
    depth3 = depth2 + neck_length;

    // base
    difference() {
        linear_extrude(height) {
            translate([-SKADIS_HOOK_ADAPTER_INNER_WIDTH / 2, depth0]) {
                square([SKADIS_HOOK_ADAPTER_INNER_WIDTH, SKADIS_HOOK_ADAPTER_INNER_DEPTH]);
            }
            translate([-SKADIS_HOOK_ADAPTER_OUTER_WIDTH / 2, depth1]) {
                square([SKADIS_HOOK_ADAPTER_OUTER_WIDTH, SKADIS_HOOK_ADAPTER_OUTER_DEPTH]);
            }
        }

        // chamfer
        translate([-adapter_width / 2, adapter_base_depth, 0]) {
            rotate(-90, [0, 1, 0]) {
                rotate(180, [1, 0, 0]) {
                    linear_extrude(adapter_width) {
                        polygon([[0, 0], [0, adapter_base_depth], [adapter_base_depth, adapter_base_depth]]);
                    }
                }
            }
        }
    }

    // hook neck
    translate([0, depth2, hook_width / 2]) {
        rotate(-90, [1, 0, 0]) {
            linear_extrude(neck_length + hook_width / 2) {
                circle(d = hook_width);
            }
        }
    }

    // hook end
    if (hook_type == "straight") {
        translate([0, depth3 + hook_width / 2, hook_width / 2]) {
            hull() {
                translate([0, 0, 0]) {
                    sphere(d = hook_width);
                }
                translate([0, 0, hook_height - hook_width]) {
                    sphere(d = hook_width);
                }
            }
        }
    }

    if (hook_type == "twist") {
        translate([0, depth3 + hook_width / 2, hook_width / 2]) {
            hull() {
                translate([hook_width, 0]) {
                    sphere(d = hook_width);
                }
                translate([-hook_width, 0]) {
                    sphere(d = hook_width);
                }
            }
        }
    }
}