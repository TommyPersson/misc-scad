use <./bin_base.scad>
use <./functions.scad>
use <../misc.scad>


include <./constants.scad>

module gf_stacked_plate_base(num_columns, num_rows, rounded = true) {
    difference() {
        _plate_hull(num_columns, num_rows, rounded);
        _cell_cut_outs(num_columns, num_rows);
    }
}

module _plate_hull(num_columns, num_rows, rounded) {
    linear_extrude(GF_HEIGHT_PLATE) {
        size = gf_get_plate_size(num_columns, num_rows);

        if (rounded) {
            rounded_rectangle(size.x, size.y, GF_BIN_CORNER_RADIUS);
        } else {
            square([size.x, size.y]);
        }
    }
}

module _cell_cut_outs(num_columns, num_rows) {
    points = [
        for (c = [0 : num_columns - 1]) for (r = [0 : num_rows - 1])
            [c, r]
        ];

    for (p = points) {
        x = p.x * GF_WIDTH - GF_WIDTH_TOLERANCE / 2;
        y = p.y * GF_WIDTH - GF_WIDTH_TOLERANCE / 2;

        translate([x, y]) {
            scale = GF_WIDTH / (GF_WIDTH - GF_WIDTH_TOLERANCE);
            scale(scale) {
                bin_base(centered = false);
            }
        }
    }
}
