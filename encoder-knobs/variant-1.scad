h1 = 7; // The thickest bottom part
d1 = 7; // Diameter of the bottom part
h2 = 3; // Height until the flattened section
d2 = 6; // (max) Diameter of the rest of the spine
h3 = 10.5; // Height of the rest of the spine
flat_spine_width = 4.5; // The width where the top of the spine is flattened

knob_height = 20;
knob_diameter = 25;
knob_y_offset = 1;

skirt_height = 4;
skirt_thickness = 3;

top_chamfer = 2;

spine_cutout_scale = 1.05;

$fn = 50;

model();

module model() {
    difference() {
        #encoder_body();
        translate([0, 0, 2]) {
            encoder_spine_cutout();
        }
    }
}

module encoder_body() {
    difference() {
        union() {
            translate([0, 0, knob_y_offset]) {
                linear_extrude(skirt_height) {
                    difference() {
                        circle(d = knob_diameter);
                        circle(d = knob_diameter - skirt_thickness);
                    }
                }
            }

            translate([0, 0, knob_y_offset + skirt_height]) {
                union() {
                    linear_extrude(knob_height - skirt_height) {
                        circle(d = knob_diameter);
                    }


                    translate([0, 0, knob_height - skirt_height]) {
                        cylinder(h = top_chamfer, d1 = knob_diameter, d2 = knob_diameter - top_chamfer * 2);
                    }
                }
            }

        }

        union() {
            for (a = [0 : 30 : 360]) {
                x = cos(a) * (knob_diameter / 2 + 1);
                y = sin(a) * (knob_diameter / 2 + 1);

                translate([x, y]) {
                    linear_extrude(knob_height + top_chamfer + skirt_height) {
                        circle(2);
                    }
                }
            }
        }
    }
}

module encoder_spine_cutout() {
    scale([spine_cutout_scale, spine_cutout_scale]) {
        linear_extrude(h1) {
            circle(d = d1);
        }

        translate([0, 0, h1]) {
            linear_extrude(h2) {
                circle(d = d2);
            }
        }

        translate([0, 0, h1 + h2]) {
            linear_extrude(h3) {
                intersection() {
                    circle(d = d2);
                    translate([-(d2 - flat_spine_width), -d2 / 2]) {
                        square([flat_spine_width, d2]);
                    }
                }
            }
        }
    }
}