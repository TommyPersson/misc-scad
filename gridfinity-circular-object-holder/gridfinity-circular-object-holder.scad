include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>
use <../utils/gridfinity/bin_stacking_lip.scad>

$fn = 360;

hold_diameter = 68;
spine_diameter = 15;
spine_height = 80;
wall_height = 20;
wall_thickness = 5;
base_height_gfus = 2;

outer_diameter = hold_diameter + wall_thickness;
gridfinity_num_cells = ceil(outer_diameter / GF_WIDTH);

gridfinity_dimension = [gridfinity_num_cells, gridfinity_num_cells];
gridfinity_size = gf_get_plate_size(gridfinity_dimension.x, gridfinity_dimension.y);

model();

module model() {
    center = [gridfinity_size.x / 2, gridfinity_size.y / 2];
    translate(center) {
        difference() {
            union() {
                translate(center * -1) {
                    gf_body(gridfinity_dimension.x, gridfinity_dimension.y, base_height_gfus);
                }
                linear_extrude(wall_height) {
                    circle(d = hold_diameter + wall_thickness);
                }
            }
            linear_extrude(wall_height) {
                circle(d = hold_diameter);
            }
        }

        if (spine_diameter > 0) {
            linear_extrude(spine_height) {
                circle(d = spine_diameter);
            }
        }
    }

    gridfinity_base(gridfinity_dimension);
}

module gridfinity_base(dimension) {
    gf_combined_bin_bases(dimension.x, dimension.y);
    gf_stacking_lip(dimension.x, dimension.y, base_height_gfus);
}