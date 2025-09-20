include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>

$fn = 360;

spool_diameter = 68;
spool_spine_diameter = 15;
spool_spine_height = 80;
wall_height = 40;
wall_thickness = 5;
base_height_gfus = 2;

outer_diameter = spool_diameter + wall_thickness;
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
                    circle(d = spool_diameter + wall_thickness);
                }
            }
            linear_extrude(wall_height) {
                circle(d = spool_diameter);
            }
        }

        linear_extrude(spool_spine_height) {
            circle(d = spool_spine_diameter);
        }
    }

    gridfinity_base(gridfinity_dimension);
}

module gridfinity_base(dimension) {
    gf_combined_bin_bases(dimension.x, dimension.y);
}