use <../utils/misc.scad>
use <../utils/skadis/constants.scad>
include <../skadis-hook-adapter/skadis-hook-adapter-slot.scad>

mount_radius = 80;
mount_height = 40;
mount_depth = 50;
mount_back_wall_depth = 6;
mount_back_wall_width = 140;
mount_back_wall_height = 50;
mount_front_wall_depth = 6;
mount_front_wall_height = 6;

total_depth = mount_back_wall_depth + mount_depth + mount_front_wall_depth;
hook_adapter_slot_height = mount_back_wall_height - 10;

bounding_box = [
    130,
    total_depth,
    mount_back_wall_height
    ];

skadis_headpone_mount();

$fn = 360;

module skadis_headpone_mount() {
    intersection() {
        union() {
            difference() {
                union() {
                    // main body
                    rotate(90, [1, 0, 0]) {
                        linear_extrude(mount_depth) {
                            circle_segment(mount_radius, mount_height);
                        }
                    }

                    // back wall
                    translate([-mount_back_wall_width / 2, -mount_back_wall_depth]) {
                        linear_extrude(mount_back_wall_height) {
                            square([mount_back_wall_width, mount_back_wall_depth]);
                        }
                    }
                }

                // hook slots
                rotate(180) {
                    translate([0, 0]) {
                        #skadis_hook_adapter_slot(hook_adapter_slot_height, screw_hole_diameter = 0);
                    }
                    translate([-SKADIS_HOLE_TO_HOLE_DISTANCE, 0]) {
                        #skadis_hook_adapter_slot(hook_adapter_slot_height, screw_hole_diameter = 0);
                    }
                    translate([+SKADIS_HOLE_TO_HOLE_DISTANCE, 0]) {
                        #skadis_hook_adapter_slot(hook_adapter_slot_height, screw_hole_diameter = 0);
                    }
                }
            }

            // front wall
            translate([0, -mount_depth]) {
                rotate(90, [1, 0, 0]) {
                    linear_extrude(mount_front_wall_depth) {
                        circle_segment(mount_radius, mount_height - mount_front_wall_height);
                    }
                }
            }
        }

        // bounding box
        translate([-bounding_box.x/2, -bounding_box.y]) {
            #cube(bounding_box);
        }
    }
}