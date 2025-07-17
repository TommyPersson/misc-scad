plate_width = 100;

frame_wall_width = 5;
frame_wall_thickness = 2.5;
frame_base_thickness = 5;
frame_base_plate_hole_margin = 20;

magnet_hole_diameter = 5.4;
magnet_hole_depth = 3;
magnet_hole_inset = 10;

num_rows = 2;
num_columns = 2;

plate_points = [
    for (c = [0 : num_columns - 1])
        for (r = [0 : num_rows - 1])
            [c, r]
];

plate_safety_margin = 0.4;
plate_width_with_safety = plate_width + plate_safety_margin;
frame_width = (plate_width_with_safety * num_columns) + (frame_wall_width * (num_columns + 1));
frame_height = (plate_width_with_safety * num_rows) + (frame_wall_width * (num_rows + 1));

$fn = 50;

model();

module model() {
    translate([0, 0, 0]) {
        frame_base();
    }
    translate([0, 0, frame_base_thickness]) {
        frame_walls();
    }
}

module frame_walls() {
    difference() {
        linear_extrude(frame_wall_thickness) {
            square([frame_width, frame_height]);
        }

        union() {
            for (p = plate_points) {
                origin = get_plate_origin(p);

                linear_extrude(frame_wall_thickness + 0.1)
                    translate([origin.x + frame_wall_width, origin.y + frame_wall_width])
                        square([plate_width_with_safety, plate_width_with_safety]);
            }
        }
    }
}

module frame_base() {
    difference() {
        difference() {
            linear_extrude(frame_base_thickness)
                square([frame_width, frame_height]);
            frame_base_openings();
        }
        frame_base_magnet_holes();
        frame_base_back_holes();
    }
}

module frame_base_openings() {
    inset = frame_wall_width + frame_base_plate_hole_margin;
    plate_hole_width = plate_width_with_safety - (frame_base_plate_hole_margin * 2);

    for (p = plate_points) {
        origin = get_plate_origin(p);

        linear_extrude(frame_base_thickness + 0.1)
            translate([origin.x + inset, origin.y + inset])
                square([plate_hole_width, plate_hole_width]);
    }
}

module frame_base_magnet_holes() {
    holes = [
        [frame_wall_width + (plate_width_with_safety / 2), frame_wall_width + magnet_hole_inset],
        [frame_wall_width + (plate_width_with_safety / 2), plate_width_with_safety - magnet_hole_inset + frame_wall_width],
        [magnet_hole_inset + frame_wall_width, frame_wall_width + (plate_width_with_safety / 2)],
        [plate_width_with_safety - magnet_hole_inset + frame_wall_width, frame_wall_width + (plate_width_with_safety / 2)],
    ];
    
    for (p = plate_points) {
        origin = get_plate_origin(p);

        z = frame_base_thickness - magnet_hole_depth;

        translate([0, 0, z])
            linear_extrude(magnet_hole_depth) {
                for (h = holes) {
                    translate([origin.x + h.x, origin.y + h.y])
                        circle(d = magnet_hole_diameter);    
                }
            }
    }
}

module frame_base_back_holes() {
    for (x = [0 : num_columns - 2]) {
        linear_extrude(2) {
            width = 19;
            height = frame_height - frame_wall_width*2;

            offset_x = ((x + 1) * (plate_width_with_safety + frame_wall_width)) - (width / 2) - (frame_wall_width/2) + frame_wall_width;
            offset_y = frame_wall_width;

            translate([offset_x, offset_y])
                square([width, height]);
        }
    }
    for (y = [0 : num_rows - 2]) {
        linear_extrude(2) {
            width = frame_width - frame_wall_width*2 ;
            height = 19;

            offset_x = frame_wall_width;
            offset_y = ((y + 1) * (plate_width_with_safety + frame_wall_width)) - (height / 2) - (frame_wall_width/2) + frame_wall_width;

            translate([offset_x, offset_y])
                square([width, height]);
        }
    }
}

function get_plate_origin(frame) = let(
    origin_x = frame.x * (plate_width_with_safety + frame_wall_width),
    origin_y = frame.y * (plate_width_with_safety + frame_wall_width)
) [origin_x, origin_y];