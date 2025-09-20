use <../utils/misc.scad>
include <./shared_variables.scad>

frame_width = base_height / 2;
frame_thickness = base_thickness + border_height;

frame_section(num_units = 4);

module frame(num_units) {
    for (i = [0 : num_units - 1]) {
        offset_y = i * base_height;
        translate([0, offset_y]) {
            frame_section();
        }
    }
}

module frame_section() {
    difference() {
        frame_section_base();

        union() {
            magnet_cutouts();
            #frame_taper_cutout();
        }
    }
}

module frame_section_base() {
    color("white") {
        linear_extrude(frame_thickness) {
            square([frame_width, base_height]);
        }
    }
}

module frame_taper_cutout() {
    points = [
            [frame_width / 2, frame_thickness],
            [frame_width, frame_thickness],
            [frame_width, frame_thickness / 2]
        ];


    translate([0, base_height]) {
        rotate(90, [1, 0, 0]) {
            linear_extrude(base_height) {
                polygon(points);
            }
        }
    }
}

module magnet_cutouts() {
    far_offset_y = base_height - magnet_inset;

    translate([0, magnet_inset, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }

    translate([0, far_offset_y, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }
}