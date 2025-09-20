use <../utils/skadis/constants.scad>
use <../utils/misc.scad>
include <../skadis-hook-adapter/skadis-hook-adapter-slot.scad>

base_height = 7;
back_wall_width = SKADIS_HOLE_TO_HOLE_DISTANCE * 2;
back_wall_height = 50;
back_wall_depth = 6;
front_wall_height = 10;
front_wall_depth = 6;
mount_depth = 40;
mount_width = 35;
fillet_radius = 2;

total_depth = back_wall_depth + mount_depth + front_wall_depth;
hook_adapter_slot_height = back_wall_height - 10;

skadis_xbox_controller_mount();

$fn = 360;

module skadis_xbox_controller_mount() {
    difference() {

        translate([-mount_width / 2, 0]) {
            // back wall
            translate([-back_wall_width / 2 + mount_width / 2, back_wall_depth]) {
                rotate(90, [1, 0, 0]) {
                    linear_extrude(back_wall_depth) {
                        rounded_rectangle(back_wall_width, back_wall_height + base_height, fillet_radius);
                    }
                }
            }

            // main mount
            rotate(90, [1, 0, 0]) {
                linear_extrude(mount_depth) {
                    rounded_rectangle(mount_width, base_height, fillet_radius);
                }
            }

            // front wall
            translate([0, -mount_depth]) {
                rotate(90, [1, 0, 0]) {
                    linear_extrude(front_wall_depth) {
                        rounded_rectangle(mount_width, front_wall_height + base_height, fillet_radius);
                    }
                }
            }
        }

        translate([0, back_wall_depth]) {
            rotate(180) {
                translate([-SKADIS_HOLE_TO_HOLE_DISTANCE / 2, 0, 0]) {
                    #skadis_hook_adapter_slot(back_wall_height);
                }
                translate([SKADIS_HOLE_TO_HOLE_DISTANCE / 2, 0, 0]) {
                    #skadis_hook_adapter_slot(back_wall_height);
                }
            }
        }
    }
}
