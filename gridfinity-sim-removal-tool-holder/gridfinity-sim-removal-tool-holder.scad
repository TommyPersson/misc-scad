include <../utils/gridfinity/constants.scad>
use <../utils/gridfinity/functions.scad>
use <../utils/gridfinity/bin_base.scad>
use <../utils/misc.scad>

$fn = 360;

base_tolerance = 0.75;
tool_pin_thickness = 0.75;
tool_pin_height = 10;
tool_body_max_width = 15;
tool_body_height = 23;
tool_total_height = tool_pin_height + tool_body_height;
tool_pin_slot_thickness = tool_pin_thickness + base_tolerance;
tool_pin_slot_height = tool_pin_height + 2;


gridfinity_size = gf_get_plate_size(1, 1);

model();

module model() {
    bin_center = [-gridfinity_size.x / 2, -gridfinity_size.y / 2];

    difference() {
        translate(bin_center) {
            gf_combined_bin_bases(1, 1);
            gf_body(1, 1, 2);
        }

        union() {
            translate([0, 0, 7]) {
                rotate(90, [1, 0, 0]) {
                    #tool_outline();
                }
            }

            translate([0, 0, 2 * GF_HEIGHT_1U - 2]) {
                linear_extrude(2) {
                    rounded_rectangle(tool_body_max_width + 5, tool_pin_slot_thickness + 5, 2, center = true);
                }
            }
        }
    }

}

module tool_outline() {
    translate([0, 0, -tool_pin_slot_thickness/2]) {
        linear_extrude(tool_pin_slot_thickness) {
            translate([-tool_body_max_width / 2, 0]) {
                square([tool_body_max_width, tool_body_height]);
            }

            translate([-tool_pin_slot_thickness / 2, -tool_pin_slot_height]) {
                square([tool_pin_slot_thickness, tool_pin_slot_height]);
            }
        }
    }
}

