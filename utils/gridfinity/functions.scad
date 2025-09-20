include <./constants.scad>

function gf_get_plate_size(num_columns, num_rows) =
    [
            num_columns * GF_WIDTH - GF_WIDTH_TOLERANCE,
            num_rows * GF_WIDTH - GF_WIDTH_TOLERANCE,
    ];

function gf_get_minimum_dimensions(width, length) =
    [
    ceil(width / GF_WIDTH),
    ceil(length / GF_WIDTH)
    ];
