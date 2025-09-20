use <../utils/misc.scad>
include <./shared_variables.scad>

nameplate("Tommy P");

module nameplate(string, halign) {
    base();
    name_text(string, halign);
    borders();
}

module name_text(string, halign) {
    color("gray") {
        offset_x = halign == "center" ? base_center.x : text_inset_x;

        translate([offset_x, base_center.y, base_thickness]) {
            linear_extrude(2) {
                text(string, text_size, "PxPlus IBM VGA8", valign = "center", halign = halign);
            }
        }
    }
}

module base() {
    difference() {
        color("white") {
            linear_extrude(base_thickness) {
                square([base_width, base_height]);
            }
        }

        magnet_cutouts();
    }
}

module borders() {
    color("gray") {
        translate([0, 0, base_thickness]) {
            linear_extrude(border_height) {
                // bottom
                square([base_width, border_width]);

                // top
                translate([0, base_height - border_width]) {
                    square([base_width, border_width]);

                }
            }
        }
    }
}

module magnet_cutouts() {
    far_offset_y = base_height - magnet_inset;

    // near left
    translate([0, magnet_inset, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }

    // far left
    translate([0, far_offset_y, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }

    // near right
    #translate([base_width - magnet_depth, magnet_inset, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }

    // far right
    #translate([base_width - magnet_depth, far_offset_y, magnet_inset])
        rotate(90, [0, 0, 1])
            rotate(90, [1, 0, 0])
                linear_extrude(magnet_depth) {
                    tear_drop_circle(d = magnet_diameter);
                }
}