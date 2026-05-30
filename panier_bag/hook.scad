$fn = 60; 

// --- PARAMETERS ---
width = 30;        
height = 55;       
depth = 26;        
rail_dia = 10.5;   
bolt_dia = 5.5;    
corner_rad = 4;    
bolt_spread = 15;  

left_bolt = (width / 2) - (bolt_spread / 2);
right_bolt = (width / 2) + (bolt_spread / 2);

difference() {
    // 1. Main Hook Body
    hull() {
        cube([width, 8, 1]);
        cube([width, 8, height - corner_rad]); 
        translate([0, corner_rad, height - corner_rad]) rotate([0, 90, 0]) cylinder(h = width, r = corner_rad);
        translate([0, depth - corner_rad, height - corner_rad]) rotate([0, 90, 0]) cylinder(h = width, r = corner_rad);
        translate([0, depth - 3, 25]) rotate([0, 90, 0]) cylinder(h = width, r = 3);
    }

    // 2. Rack Rail Capture Void
    translate([-1, 14, 42]) rotate([0, 90, 0]) cylinder(h = width + 2, d = rail_dia);

    // 3. Hook Throat 
    translate([-1, 14 - (rail_dia/2), 0]) cube([width + 2, rail_dia, 42]);

    // 4. Left Bolt Hardware (Mount, Counterbore, Tool Access)
    translate([left_bolt, 16, 22.5]) rotate([90, 0, 0]) cylinder(h = 30, d = bolt_dia);
    translate([left_bolt, 8, 22.5]) rotate([90, 0, 0]) cylinder(h = 10, d = 10);
    translate([left_bolt, 30, 22.5]) rotate([90, 0, 0]) cylinder(h = 20, d = 8);

    // 5. Right Bolt Hardware
    translate([right_bolt, 16, 22.5]) rotate([90, 0, 0]) cylinder(h = 30, d = bolt_dia);
    translate([right_bolt, 8, 22.5]) rotate([90, 0, 0]) cylinder(h = 10, d = 10);
    translate([right_bolt, 30, 22.5]) rotate([90, 0, 0]) cylinder(h = 20, d = 8);
        
    // 6. Centered Quick-Release Gate Pivot
    translate([-1, 13, height - 4]) rotate([0, 90, 0]) cylinder(h = width + 2, d = 3.4);
    
    // 7. Bungee Anchor Hole
    translate([-1, 4, 4]) rotate([0, 90, 0]) cylinder(h = width + 2, d = 3);
}