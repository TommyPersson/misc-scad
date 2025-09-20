include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>

$fn = 360;

pen_diameter = 8;
pen_radius = pen_diameter / 2;
pen_spacing = 0;
pen_length = 170;
pen_count = 10;
pen_margin = 10;
pen_slot_cutoff_height = pen_radius / 2;

side_margin = 2;
front_margin = 10;
back_margin = 10;

total_pen_width = (pen_diameter * pen_count) + (pen_spacing * (pen_count - 1));
minimum_width = total_pen_width + (side_margin * 2);
minimum_length = pen_length + front_margin + back_margin;

base_height_gfus = 1;
base_height = GF_HEIGHT_1U * base_height_gfus;

gridfinity_dimension = gf_get_minimum_dimensions(minimum_width, minimum_length);
gridfinity_size = gf_get_plate_size(gridfinity_dimension.x, gridfinity_dimension.y);

model();

module model() {
    center = [gridfinity_size.x / 2, gridfinity_size.y / 2];
    difference() {
        union() {
            gf_body(gridfinity_dimension.x, gridfinity_dimension.y, base_height_gfus);
        }
        union() {
            translate([center.x - (total_pen_width / 2) + pen_radius, 0, base_height - pen_radius]) {
                translate([-pen_radius, back_margin, pen_slot_cutoff_height]) {
                    linear_extrude(pen_diameter) {
                        square([total_pen_width, pen_length + pen_margin]);
                    }
                }

                for (n = [0 : pen_count - 1]) {
                    x = (n * pen_diameter) + (n * pen_spacing);
                    z = pen_diameter / 2;
                    translate([x, back_margin, z]) {
                        rotate(-90, [1, 0, 0]) {
                            linear_extrude(pen_length + pen_margin) {
                                circle(d = pen_diameter);
                            }
                        }
                    }
                }
            }
        }
    }

    gridfinity_base(gridfinity_dimension);
}

module gridfinity_base(dimension) {
    gf_combined_bin_bases(dimension.x, dimension.y);
}