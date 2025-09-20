use <../utils/skadis/constants.scad>
use <../utils/misc.scad>
include <../skadis-hook-adapter/skadis-mount-back-wall.scad>

variant = "top"; // [top,bottom]

back_wall_height = 40;
back_wall_depth = 6;
fillet_radius = 2;

num_slots = 5;
slot_width = 6;
slot_spacing = 5;
slot_depth = 45;

back_wall_width = (num_slots + 1) * (slot_width + slot_spacing) - slot_width;

base_thickness = 6;
front_wall_thickness = 6;

$fn = 360;

skadis_ruler_stand();

module skadis_ruler_stand() {
    skadis_mount_back_wall(back_wall_width, back_wall_height, back_wall_depth, fillet_radius);

    for (n = [0 : num_slots]) {
        x_offset = n * (slot_width + slot_spacing) - back_wall_width / 2;
        thickness = (variant == "bottom") ? base_thickness * 2 : base_thickness;
        translate([x_offset, 0, thickness]) {
            rotate(-90, [1, 0, 0]) {
                linear_extrude(slot_depth) {
                    rounded_rectangle(slot_spacing, thickness, fillet_radius);
                }
            }
        }
    }

    if (variant == "bottom") {
        translate([-back_wall_width / 2, 0, base_thickness]) {
            rotate(-90, [1, 0, 0]) {
                linear_extrude(slot_depth) {
                    rounded_rectangle(back_wall_width, base_thickness, fillet_radius);
                }
            }
        }
    }
}
