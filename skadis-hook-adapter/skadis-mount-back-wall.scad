include <../utils/skadis/constants.scad>
use <./skadis-hook-adapter-slot.scad>

module skadis_mount_back_wall(width, height, thickness = 6, fillet_radius = 2) {

    num_hook_slots = floor((width + SKADIS_HOOK_ADAPTER_INNER_WIDTH * 2) / SKADIS_HOLE_TO_HOLE_DISTANCE);
    even = (num_hook_slots % 2) == 0;

    difference() {
        // main wall
        translate([-width / 2, 0]) {
            rotate(90, [1, 0, 0]) {
                linear_extrude(thickness) {
                    if (fillet_radius > 0) {
                        rounded_rectangle(width, height, fillet_radius);
                    } else {
                        square([width, height]);
                    }
                }
            }
        }

        // adapter slots
        total_slots_widths = (num_hook_slots - 1) * SKADIS_HOLE_TO_HOLE_DISTANCE;
        offset_x = (-total_slots_widths / 2);
        translate([offset_x, -thickness]) {
            for (n = [0 : num_hook_slots - 1]) {
                translate([n * SKADIS_HOLE_TO_HOLE_DISTANCE, 0]) {
                    #skadis_hook_adapter_slot(height - 10);
                }
            }
        }
    }
}