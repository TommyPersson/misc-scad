distance_between_spines = 150;
height_spines = 40;
spine_diameter = 21;
spine_radius = spine_diameter / 2;
margin = 40;
stand_thickness = 20;

model();

module model() {
    difference() {
        stand();
        spine_front();
        spine_back();
    }
}

module stand() {
    translate([0, 0]) {
        linear_extrude(stand_thickness) {
            width = margin * 2 + distance_between_spines;
            height = height_spines + margin;
            square([width, height]);
        }
    }
}

module spine_front() {
    translate([margin, height_spines + spine_radius]) {
        spine();
    }
}

module spine_back() {
    translate([margin + distance_between_spines, height_spines + spine_radius]) {
        spine();
    }
}

module spine() {
    linear_extrude(stand_thickness) {
        circle(d=spine_diameter);
    }
}