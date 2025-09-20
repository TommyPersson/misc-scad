include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>
use <../utils/gridfinity/bin_stacking_lip.scad>

tool_slot_width = 100;
tool_slot_depth = 5;
tool_slot_height = 100;

gf_columns = 1;
gf_rows = 3;

gf_size = gf_get_plate_size(gf_columns, gf_rows);

gridfinity_radius_tool_holder();

module gridfinity_radius_tool_holder() {
    difference() {
        translate([-gf_size.x / 2, -gf_size.y / 2]) {
            gf_combined_bin_bases(gf_columns, gf_rows);
            gf_body(gf_columns, gf_rows, 5);
            gf_stacking_lip(gf_columns, gf_rows, 5);
        }

        #union() {
            translate([-tool_slot_depth / 2, -tool_slot_width / 2]) {
                translate([tool_slot_depth * 1.5, 0]) {
                    cube([tool_slot_depth, tool_slot_width, tool_slot_height]);
                }
                translate([-tool_slot_depth * 1.5, 0]) {
                    cube([tool_slot_depth, tool_slot_width, tool_slot_height]);
                }
            }
        }
    }
}

