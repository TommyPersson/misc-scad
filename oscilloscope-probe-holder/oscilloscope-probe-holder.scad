use <../utils/misc.scad>

$fn = 50;

wall_width = 30;
wall_height = 60;
wall_thickness = 3;
probe_neck_width = 7;
grip_width = 7;
grip_thickness = 3;
grip_length = 20;
grip_finger_angle = 45;
grip_finger_length = 10;

oscilloscope_probe_holder();

module oscilloscope_probe_holder() {
    // left grip
    translate([0, probe_neck_width/2]) {
        grip();
    }

    // right grip
    translate([0, -probe_neck_width/2*3]) {
        grip();
    }

    // wall
    translate([0, -wall_width/2]) {
        rotate(270, [0, 1, 0]) {
            linear_extrude(wall_thickness) {
                rounded_rectangle(wall_height, wall_width, 2);
            }
        }
    }
}

module grip() {
    linear_extrude(grip_thickness) {
        square([grip_length, grip_width]);
    }

    translate([grip_length, 0]) {
        rotate(-grip_finger_angle, [0, 1, 0]) {
            linear_extrude(grip_thickness) {
                square([grip_finger_length, grip_width]);
            }
        }
    }
}