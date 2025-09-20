include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>
use <../utils/gridfinity/bin_stacking_lip.scad>
use <../utils/misc.scad>

$fn = 50;

outline_height = 98;
outline_width = 49.695;
holder_depth = 7.5;

padding = 20;

base_height_gfus = 2;

gf_dimension = gf_get_minimum_dimensions(outline_width + padding, outline_height + padding);
gf_size = gf_get_plate_size(gf_dimension.x, gf_dimension.y);
center = [gf_size.x / 2, gf_size.y / 2];

gridfinity_chip_puller_tool_holder();

module gridfinity_chip_puller_tool_holder() {
    difference() {
        translate([-center.x, -center.y]) {
            gf_body(gf_dimension.x, gf_dimension.y, base_height_gfus);
            gf_combined_bin_bases(gf_dimension.x, gf_dimension.y);
            gf_stacking_lip(gf_dimension.x, gf_dimension.y, base_height_gfus);
        }

        union() {
            z_offset = base_height_gfus * GF_HEIGHT_1U - holder_depth;
            translate([0, 0, z_offset]) {
                linear_extrude(holder_depth) {
                    the_shape();
                }

            }
        }
    }
}

module the_shape() {
    translate([-outline_width / 2, -outline_height / 2]) {
        import("./chip-puller-outline.svg");
    }
}
