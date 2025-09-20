include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>
use <../utils/gridfinity/bin_stacking_lip.scad>
use <../utils/misc.scad>

// TODO
// * Higher walls between spools (would need more spacing than 2mm?)
// * Screw hole to be able to fasten the spine?

$fn = 360;

num_spools = 6;

base_tolerance = 0.5;


spool_diameter = 56;
spool_thickness = 33;
spool_margin = 10;
spool_base_offset = 20;
spool_spacing = 2;

spine_height = 40;
base_margin = 20;

wire_ring_width = 15;
wire_ring_thickness = 5;
wire_ring_hole_diameter = 5;

spine_diameter = 16;
spine_leg_top_width = spine_diameter + 5;
spine_leg_bottom_width = spine_leg_top_width + 20;
spine_leg_thickness = 10;
spine_legs_inset = 10;

base_height_gfus = 2;

combined_spool_width = (num_spools * (spool_thickness + spool_spacing)) - spool_spacing;
min_base_width = (base_margin * 2) + combined_spool_width;

gf_dimension = gf_get_minimum_dimensions(min_base_width, spool_diameter);
gf_size = gf_get_plate_size(gf_dimension.x, gf_dimension.y);
center = [gf_size.x / 2, gf_size.y / 2];


model();

module model() {
    difference() {
        translate([-center.x, -center.y]) {
            gf_body(gf_dimension.x, gf_dimension.y, base_height_gfus);
            gf_combined_bin_bases(gf_dimension.x, gf_dimension.y);
            gf_stacking_lip(gf_dimension.x, gf_dimension.y, base_height_gfus);
        }

        spool_cut_outs();
    }

    wire_rings();
    spine_legs();
}

module spine_legs() {
    x_offset = gf_size.x / 2 - spine_legs_inset;
    translate([-x_offset, 0]) {
        rotate(90, [0, 0, 1]) {
            spine_leg();
        }
    }

    translate([x_offset, 0]) {
        rotate(-90, [0, 0, 1]) {
            spine_leg();
        }
    }
}


module spine_leg() {
    translate([0, -spine_leg_thickness / 2, spine_height]) {
        rotate(-90, [1, 0, 0]) {
            difference() {
                union() {
                    linear_extrude(spine_leg_thickness) {
                        circle(d = spine_leg_top_width);
                        bottom_x_offset = spine_leg_bottom_width - spine_leg_top_width;
                        polygon([
                                [-spine_leg_bottom_width / 2, spine_height],
                                [spine_leg_bottom_width / 2, spine_height],
                                [spine_leg_top_width / 2, 0],
                                [-spine_leg_top_width / 2, 0],
                            ]);
                    }
                }

                // cut out
                union() {
                    linear_extrude(spine_leg_thickness / 2) {
                        diameter = spine_diameter + base_tolerance;
                        circle(d = diameter);
                        translate([-diameter / 2, -diameter]) {
                            square([diameter, diameter]);
                        }
                    }
                }
            }
        }
    }
}

module wire_rings() {
    x_offset = spool_thickness / 2 - combined_spool_width / 2;
    y_offset = -(gf_size.y / 2) + 5;
    z_offset = base_height_gfus * GF_HEIGHT_1U + wire_ring_width / 2;
    translate([x_offset, y_offset, z_offset]) {
        for (n = [1 : num_spools]) {
            x_offset = (n - 1) * (spool_thickness + spool_spacing);
            translate([x_offset, 0]) {
                wire_ring();
            }
        }
    }
}

module wire_ring() {
    translate([0, wire_ring_thickness / 2, 0]) {
        rotate(90, [1, 0, 0]) {
            difference() {
                translate([-wire_ring_width / 2, -wire_ring_width / 2]) {
                    linear_extrude(wire_ring_thickness) {
                        rounded_rectangle(wire_ring_width, wire_ring_width, 2);
                        square([wire_ring_width, wire_ring_width / 2]);
                    }
                }

                linear_extrude(wire_ring_thickness) {
                    circle(d = wire_ring_hole_diameter);
                }
            }
        }
    }
}

module spool_cut_outs() {
    x_offset = spool_thickness / 2 - combined_spool_width / 2;
    z_offset = spine_height;
    translate([x_offset, 0, z_offset]) {
        for (n = [1 : num_spools]) {
            x_offset = (n - 1) * (spool_thickness + spool_spacing);
            translate([x_offset, 0]) {
                #spool_cut_out();
            }
        }
    }
}

module spool_cut_out() {
    thickness = spool_thickness + base_tolerance;
    diameter = spool_diameter + spool_margin;

    translate([-thickness / 2, 0]) {
        rotate(90, [0, 1, 0]) {
            linear_extrude(thickness) {
                circle(d = diameter);
            }
        }
    }
}

module spine() {

}