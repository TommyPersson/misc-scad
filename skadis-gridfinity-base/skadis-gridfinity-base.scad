use <../utils/gridfinity/plate_base.scad>
use <../utils/gridfinity/functions.scad>
include <../utils/gridfinity/constants.scad>
include <../utils/skadis/constants.scad>

use <../skadis-hook-adapter/skadis-hook-adapter-slot.scad>

$fn = 50;

num_columns = 5;
num_rows = 2;
gf_base_margin = 2;
base_floor_thickness = 2;
gf_plate_size = gf_get_plate_size(num_columns, num_rows);
side_wall_thickness = 2;
back_wall_thickness = 6;
wall_height = 50;
adapter_top = wall_height - 5;

total_width = side_wall_thickness * 2 + gf_plate_size.x + gf_base_margin * 2;

hook_adapter_outer_width = SKADIS_HOOK_ADAPTER_INNER_WIDTH;
hook_adapter_inner_width = SKADIS_HOOK_ADAPTER_OUTER_WIDTH;
hook_adapter_tolerance = 0.5;
hook_adapter_center_distance = SKADIS_HOLE_TO_HOLE_DISTANCE;

hook_adapter_screw_hole_height = adapter_top - 10;
hook_adapter_screw_hole_diameter = 3.5;

model();

module model() {
    base();
    side_walls();
    back_wall();
}

module base() {
    translate([gf_base_margin, gf_base_margin, base_floor_thickness]) {
        gf_stacked_plate_base(num_columns, num_rows, rounded = false);
    }

    // base floor
    translate([-side_wall_thickness, 0, 0]) {
        linear_extrude(base_floor_thickness) {
            width = gf_plate_size.x + side_wall_thickness * 2 + gf_base_margin * 2;
            depth = gf_plate_size.y + gf_base_margin * 2;
            square([width, depth]);
        }
    }

    // base walls
    translate([0, 0, base_floor_thickness]) {
        linear_extrude(GF_HEIGHT_PLATE) {
            size = gf_plate_size;
            difference() {
                // base walls
                square([size.x + gf_base_margin * 2, size.y + gf_base_margin * 2]);
                // base cut-out
                translate([gf_base_margin, gf_base_margin]) {
                    square(size);
                }
            }
        }
    }
}

module side_walls() {
    points = [
            [0, 0],
            [0, gf_plate_size.y + gf_base_margin * 2],
            [GF_HEIGHT_PLATE + base_floor_thickness, gf_plate_size.y + gf_base_margin * 2],
            [wall_height, GF_HEIGHT_PLATE + base_floor_thickness],
            [wall_height, 0]
        ];

    rotate(-90, [0, 1, 0]) {
        linear_extrude(side_wall_thickness) {
            polygon(points);
        }
        offset = -gf_plate_size.x - side_wall_thickness - gf_base_margin * 2;
        translate([0, 0, offset]) {
            linear_extrude(side_wall_thickness) {
                polygon(points);
            }
        }
    }
}

module back_wall() {
    difference() {
        translate([-side_wall_thickness, -back_wall_thickness]) {
            linear_extrude(wall_height) {
                width = gf_plate_size.x + side_wall_thickness * 2 + gf_base_margin * 2;
                height = back_wall_thickness;
                square([width, height]);
            }
        }

        hook_adapter_cut_outs();
    }
}

module hook_adapter_cut_outs() {
    num_hooks = num_columns;
    even = num_hooks % 2 == 0;
    center = gf_base_margin + gf_plate_size.x / 2;
    left_most = center - (num_hooks / 2) * hook_adapter_center_distance - hook_adapter_center_distance / 2;

    translate([left_most, -back_wall_thickness]) {
        for (n = [1 : num_hooks]) {
            x = n * hook_adapter_center_distance;
            translate([x, 0]) {
                #skadis_hook_adapter_slot(height = adapter_top);
            }
        }
    }
}
