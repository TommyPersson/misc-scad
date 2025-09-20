use <../misc.scad>
use <./functions.scad>
include <./constants.scad>


angle = 45;

height_level_1 = 0.8;
height_level_2 = 1.8;
height_level_3 = 2.15;
height_level_4 = GF_HEIGHT_1U - height_level_1 - height_level_2 - height_level_3;

inner_width = 35.6;
middle_width = inner_width + 0.8 * 2;
outer_width = middle_width + 2.15 * 2;

radius_outer = GF_BIN_CORNER_RADIUS;
radius_middle = 3.2 / 2;
radius_inner = 1.6 / 2;

module gf_combined_bin_bases(num_columns, num_rows, lowered = true) {
    points = [
        for (c = [0 : num_columns - 1]) for (r = [0 : num_rows - 1])
            [c, r]
        ];

    offset_x = -GF_WIDTH_TOLERANCE;
    offset_y = -GF_WIDTH_TOLERANCE;
    offset_z = lowered ? -GF_HEIGHT_1U : 0;

    translate([offset_x, offset_y, offset_z]) {
        for (p = points) {
            cx = p.x * GF_WIDTH + GF_WIDTH / 2 + GF_WIDTH_TOLERANCE / 2;
            cy = p.y * GF_WIDTH + GF_WIDTH / 2 + GF_WIDTH_TOLERANCE / 2;

            translate([cx, cy]) {
                bin_base();
            }
        }

        bin_floor(num_columns, num_rows);
    }
}

module gf_body(num_columns, num_rows, u_height) {
    linear_extrude(u_height * GF_HEIGHT_1U) {
        size = gf_get_plate_size(num_columns, num_rows);
        rounded_rectangle(size.x, size.y, radius_outer);
    }
}

module gf_wall(num_columns, num_rows, u_height) {
    wall_thickness = 0.95;

    linear_extrude(u_height * GF_HEIGHT_1U) {
        size = gf_get_plate_size(num_columns, num_rows);
        difference() {
            rounded_rectangle(size.x, size.y, radius_outer);
            translate([wall_thickness, wall_thickness]) {
                rounded_rectangle(size.x - wall_thickness*2, size.y - wall_thickness*2, radius_outer);
            }
        }
    }
}

module bin_floor(num_columns, num_rows) {
    offset_z = height_level_1 + height_level_2 + height_level_3;
    sx = (GF_WIDTH * num_columns) - GF_WIDTH_TOLERANCE;
    sy = (GF_WIDTH * num_rows) - GF_WIDTH_TOLERANCE;
    translate([GF_WIDTH_TOLERANCE / 2, GF_WIDTH_TOLERANCE / 2, offset_z]) {
        linear_extrude(height_level_4) {
            translate([GF_WIDTH_TOLERANCE / 2, GF_WIDTH_TOLERANCE / 2]) {
                rounded_rectangle(sx, sy, radius_outer);
            }
        }
    }
}

module bin_base(centered = true) {
    translation = centered ? [0, 0, 0] : [outer_width / 2, outer_width / 2, 0];
    translate(translation) {
        level_1();
        level_2();
        level_3();
        level_4();
    }
}

module level_1() {
    offset_z = 0;
    t = (inner_width / 2) - radius_inner;
    hull() {
        for (p = [[-t, -t], [-t, t], [t, -t], [t, t]]) {
            translate([p.x, p.y, offset_z]) {
                cylinder(h = height_level_1, r1 = radius_inner, r2 = radius_middle);
            }
        }
    }
}

module level_2() {
    offset_z = height_level_1;
    translate([0, 0, offset_z]) {
        linear_extrude(height_level_2) {
            translate([-middle_width / 2, -middle_width / 2]) {
                rounded_rectangle(middle_width, middle_width, radius_middle);
            }
        }
    }
}

module level_3() {
    offset_z = height_level_1 + height_level_2;
    t = (outer_width / 2) - radius_outer;
    hull() {
        for (p = [[-t, -t], [-t, t], [t, -t], [t, t]]) {
            translate([p.x, p.y, offset_z]) {
                cylinder(h = height_level_3, r1 = radius_middle, r2 = radius_outer);
            }
        }
    }
}

module level_4() {
    offset_z = height_level_1 + height_level_2 + height_level_3;
    translate([0, 0, offset_z]) {
        linear_extrude(height_level_4) {
            translate([-outer_width / 2, -outer_width / 2]) {
                rounded_rectangle(outer_width, outer_width, radius_outer);
            }
        }
    }
}
