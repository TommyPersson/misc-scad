use <./bin_base.scad>
use <./plate_base.scad>
use <./bin_stacking_lip.scad>

$fn = 50;

translate([0, 0]) {
    gf_combined_bin_bases(2, 3, lowered = true);

    gf_stacked_plate_base(2, 3);
}


translate([120, 0]) {
    gf_combined_bin_bases(2, 3, lowered = true);

    gf_body(2, 3, 3);
    
    gf_wall(2, 3, 6);

    #gf_stacking_lip(2, 3, 6);
}