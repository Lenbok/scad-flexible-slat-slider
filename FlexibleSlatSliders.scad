$fa = 1;
$fs = $preview ? 5 : 1;

slatwidth = 53;
slatthickness = 8.5;

// Inner hole size
depth = slatthickness * 2 + 1;
width = slatwidth + 1;

// Outer dimensions
depth2 = 22;
width2 = width + 10;
height = 36;

wthickness = (width2 - width) / 2;

module profile(grip = true) {
    off = width * 1.4;
    for (i = [0, 1]) mirror([i, 0]) 
        translate([width / 2 + wthickness / 2, height / 2])
            circle(r = wthickness / 2);
    difference() {
        union() {
            translate([-width2 / 2, -height / 2]) roundedsquare([width2, height - 5], r = 1);
            translate([-width2 / 2, 5 - height / 2]) square([width2, height - 5]);
        }
        for (i = [-1, 1])
            translate([i * (off + width2 / 2 - 2), 0]) {
                difference() {
                    circle(r = off);
                    if (grip) {
                        for (c = [-1, 1], a = [0:1.5:12])
                        rotate([0, 0, c * a]) mirror([i == 1 ? 1 : 0, 0]) translate([off, 0, 0]) rotate([0, 0, 30]) circle(r = 0.6, $fn = 6);
                    }
                }
            }
    }
}

module binder() {
    gripinset = 2.5;
    chamfer = true;
    difference() {
        rotate([90, 0, 0]) translate([0, height / 2, -depth2 / 2]) {
            chamfer_extrude(height = gripinset, center = false, convexity = 3, faces = [chamfer, false]) profile(false);
            translate([0, 0, gripinset]) linear_extrude(height = depth2 - 2 * gripinset, center = false, convexity = 3) profile(true);
            translate([0, 0, depth2 - gripinset]) chamfer_extrude(height = gripinset, center = false, faces = [false, chamfer], convexity = 3) profile(false);
        }
        translate([0, 0, height / 2])  roundedcube([width, depth, height + 2], center = true, r = 0.75);
    }
    translate([0, depth / 2 + 0.01, 0])  rotate([90, 0, 0])  hull() {
        translate([0, height - 6 - (9 / 2), 0]) cylinder(r1 = 9 / 2, r2 = 9 / 2 - 0.75, h = 1, center = false);
        translate([-(9 / 2), 0, 0]) cube([8, 1, 1], center = false);
    }
}

//profile();
binder();

// Requires my utility functions in your OpenSCAD lib or as local submodule
// https://github.com/Lenbok/scad-lenbok-utils.git
use<Lenbok_Utils/utils.scad>
