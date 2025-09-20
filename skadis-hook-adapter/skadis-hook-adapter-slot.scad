include <../utils/skadis/constants.scad>

$fn = 100;

module skadis_hook_adapter_slot(
height,
base_tolerance = 0.5,
screw_hole_diameter = 3.5,
screw_hole_depth = 10
) {
    inner_width = SKADIS_HOOK_ADAPTER_INNER_WIDTH + base_tolerance;
    outer_width = SKADIS_HOOK_ADAPTER_OUTER_WIDTH + base_tolerance;
    inner_depth = SKADIS_HOOK_ADAPTER_INNER_DEPTH + base_tolerance;
    outer_depth = SKADIS_HOOK_ADAPTER_OUTER_DEPTH + base_tolerance / 2;

    combined_depth = inner_depth + outer_depth;

    difference() {
        linear_extrude(height) {
            translate([-outer_width / 2, 0]) {
                square([outer_width, outer_depth]);
            }
            translate([-inner_width / 2, outer_depth]) {
                square([inner_width, inner_depth]);
            }
        }

        // triangular top on cut outs to make printing easier
        #translate([-inner_width / 2, combined_depth, height - combined_depth]) {
            rotate(-90, [0, 1, 0]) {
                rotate(180, [1, 0, 0]) {
                    linear_extrude(inner_width) {
                        polygon(points = [
                                [0, 0],
                                [combined_depth, 0],
                                [combined_depth, combined_depth],
                            ]);
                    }
                }
            }
        }
    }


    // screw hole
    #translate([0, combined_depth + 10, height - 10]) {
        rotate(90, [1, 0, 0]) {
            linear_extrude(10) {
                circle(d = screw_hole_diameter);
            }
        }
    }
}

//skadis_hook_adapter_slot(50);