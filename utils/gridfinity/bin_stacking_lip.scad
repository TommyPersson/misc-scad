include <./constants.scad>

use <../misc.scad>

height_level_1 = 0.7;
height_level_2 = 1.8;
height_level_3 = 1.9;
total_height = height_level_1 + height_level_2 + height_level_3;

cell_width = 41.5;
middle_width = cell_width - height_level_3 * 2;
bottom_width = middle_width - height_level_1 * 2;

top_radius = 7.5 / 2;
top_radius_adjusted = 7.5 / 2 - 0.35;
middle_radius_adjusted = 3.2 / 2 - 0.1;
bottom_radius = 1.6 / 2;

wall_width = 0.95;

module gf_stacking_lip(num_columns, num_rows, offset_gfus = 0) {

    total_width = cell_width * num_columns + (num_columns - 1) * GF_WIDTH_TOLERANCE;
    total_depth = cell_width * num_rows + (num_rows - 1) * GF_WIDTH_TOLERANCE;

    translate([0, 0, offset_gfus * GF_HEIGHT_1U]) {
        // main lip
        difference() {
            linear_extrude(total_height - 0.5) {
                translate([total_width / 2, total_depth / 2]) {
                    rounded_rectangle(total_width, total_depth, top_radius, center = true);
                }
            }

            _combined_cells_cut_out(num_columns, num_rows);
        }

        // bottom down-chamfer (ugly approximation of a prism-looking thing)
        chamfer_height = height_level_1 + height_level_3;
        translate([total_width / 2, total_depth / 2, -chamfer_height]) {
            difference() {
                linear_extrude(chamfer_height) {
                    rounded_rectangle(total_width, total_depth, top_radius, center = true);
                }

                x = (total_width / 2) - wall_width - chamfer_height + 0.15;
                y = (total_depth / 2) - wall_width - chamfer_height + 0.15;

                hull() {
                    for (p = [[-x, -y], [-x, y], [x, -y], [x, y]]) {
                        translate([p.x, p.y, 0]) {
                            cylinder(h = chamfer_height, r1 = top_radius_adjusted, r2 = bottom_radius);
                        }
                    }
                }
            }
        }
    }
}

module _combined_cells_cut_out(num_columns, num_rows) {
    // paint lots of ovelapping copies to create the final cut out. I couldn't use a simple hull to do it.

    points = [
        for (c = [0 : num_columns - 1]) for (r = [0 : num_rows - 1])
            [c, r]
        ];

    offset_x = -GF_WIDTH_TOLERANCE;
    offset_y = -GF_WIDTH_TOLERANCE;

    translate([offset_x, offset_y, 0]) {
        for (p = points) {
            cx = p.x * GF_WIDTH + GF_WIDTH / 2 + GF_WIDTH_TOLERANCE / 2;
            cy = p.y * GF_WIDTH + GF_WIDTH / 2 + GF_WIDTH_TOLERANCE / 2;

            translate([cx, cy]) {
                _single_cell_cut_out();
            }

            if (p.x < num_columns - 1) {
                translate([cx + cell_width / 2, cy]) {
                    _single_cell_cut_out();
                }
            }

            if (p.y < num_rows - 1) {
                translate([cx, cy + cell_width / 2]) {
                    _single_cell_cut_out();
                }
            }

            if (p.y < num_rows - 1 && p.x < num_columns - 1) {
                translate([cx + cell_width / 2, cy + cell_width / 2]) {
                    _single_cell_cut_out();
                }
            }
        }
    }
}

module _single_cell_cut_out() {
    union() {
        union() {
            // level 1
            offset_z = 0;
            t = (bottom_width / 2) - bottom_radius;
            hull() {
                for (p = [[-t, -t], [-t, t], [t, -t], [t, t]]) {
                    translate([p.x, p.y, offset_z]) {
                        cylinder(h = height_level_1, r1 = bottom_radius, r2 = middle_radius_adjusted);
                    }
                }
            }
        }

        union() {
            // level 2
            offset_z = height_level_1;
            t = (middle_width / 2) - middle_radius_adjusted;
            hull() {
                for (p = [[-t, -t], [-t, t], [t, -t], [t, t]]) {
                    translate([p.x, p.y, offset_z]) {
                        cylinder(h = height_level_2, r1 = middle_radius_adjusted, r2 = middle_radius_adjusted);
                    }
                }
            }
        }

        union() {
            // level 2
            offset_z = height_level_2 + height_level_1;
            t = (cell_width / 2) - top_radius_adjusted;
            hull() {
                for (p = [[-t, -t], [-t, t], [t, -t], [t, t]]) {
                    translate([p.x, p.y, offset_z]) {
                        cylinder(h = height_level_3, r1 = middle_radius_adjusted, r2 = top_radius_adjusted);
                    }
                }
            }
        }
    }
}