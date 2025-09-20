use <./frame.scad>
use <./nameplate.scad>
include <./shared_variables.scad>

names = [
        [0, "First A"],
        [1, "Second B"],
        [2, "Third C"],
        [3, "Fourth D"]
    ];

num_names = len(names);

frame(num_names);

translate([60, 0]) {
    for (namePair = names) {
        index = namePair[0];
        name = namePair[1];

        offset_y = index * (base_height + 40);

        translate([0, offset_y]) {
            nameplate(name, "center");
        }
    }
}