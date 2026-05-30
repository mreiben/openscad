// Modular Wind-Up Mini Golf System
// PART 1: Core Track System (Tiles & Walls)

/* [Tile Dimensions] */
tile_size = 200;
tile_thickness = 8;

/* [Wall Height Setting] */
wall_height = 16; 

/* [Pegboard Settings] */
peg_spacing = 25;
peg_diameter = 5.5; 
peg_chamfer = 1.0;

/* [Wall Tracks (Dovetail)] */
track_inset = 8; 
track_top_width = 4;
track_bottom_width = 7;
track_depth = 3.5;

/* [Interlocking Tabs (Puzzle Joints)] */
tab_base = 14;
tab_end = 20;
tab_length = 8;
clearance = 0.2; 

$fn = 60; 

// ==========================================
// RENDER SELECTION
// Uncomment the piece you want to export
// ==========================================

// --- TILES ---
connecting_tile();
// left_corner_tile();
// right_corner_tile();

// --- WALLS ---
// straight_wall();
// corner_wall(); 

// ==========================================
// TILE MODULES
// ==========================================

module connecting_tile() {
    difference() {
        union() {
            translate([-tile_size/2, -tile_size/2, 0])
                cube([tile_size, tile_size, tile_thickness]);
            translate([0, tile_size/2, 0]) rotate([0, 0, 90]) dovetail_tab();
        }
        translate([0, -tile_size/2, -1]) 
            rotate([0, 0, -90]) dovetail_cutout(tolerance=clearance);
        track_left();
        track_right();
        pegboard_grid();
    }
}

module left_corner_tile() {
    difference() {
        union() {
            translate([-tile_size/2, -tile_size/2, 0])
                cube([tile_size, tile_size, tile_thickness]);
            translate([-tile_size/2, 0, 0]) rotate([0, 0, 180]) dovetail_tab();
        }
        translate([0, -tile_size/2, -1]) 
            rotate([0, 0, -90]) dovetail_cutout(tolerance=clearance);
        track_top();
        track_right();
        pegboard_grid();
    }
}

module right_corner_tile() {
    difference() {
        union() {
            translate([-tile_size/2, -tile_size/2, 0])
                cube([tile_size, tile_size, tile_thickness]);
            translate([tile_size/2, 0, 0]) dovetail_tab();
        }
        translate([0, -tile_size/2, -1]) 
            rotate([0, 0, -90]) dovetail_cutout(tolerance=clearance);
        track_top();
        track_left();
        pegboard_grid();
    }
}

// ==========================================
// WALL MODULES
// ==========================================

module straight_wall() {
    build_wall(tile_size);
}

module corner_wall() {
    safe_length = tile_size - track_inset - (track_bottom_width / 2) - 1; 
    build_wall(safe_length);
}

module build_wall(wall_length) {
    wall_thickness = track_top_width + 1;
    union() {
        translate([-wall_length/2, -wall_thickness/2, 0])
            cube([wall_length, wall_thickness, wall_height]);
        c = 0.15; 
        translate([-wall_length/2, 0, 0]) 
        rotate([0, 90, 0])
        linear_extrude(wall_length)
        polygon([
            [0, -track_top_width/2 + c],
            [0, track_top_width/2 - c],
            [track_depth - c, track_bottom_width/2 - c], 
            [track_depth - c, -track_bottom_width/2 + c]
        ]);
    }
}

// ==========================================
// TOOLING & JOINERY MODULES
// ==========================================

module dovetail_tab() {
    linear_extrude(height = tile_thickness) {
        polygon([
            [0, -tab_base/2],
            [tab_length, -tab_end/2],
            [tab_length, tab_end/2],
            [0, tab_base/2]
        ]);
    }
}

module dovetail_cutout(tolerance=0) {
    linear_extrude(height = tile_thickness + 2) {
        polygon([
            [0.1, -(tab_base/2 + tolerance)],
            [-tab_length - tolerance, -(tab_end/2 + tolerance)],
            [-tab_length - tolerance, (tab_end/2 + tolerance)],
            [0.1, (tab_base/2 + tolerance)]
        ]);
    }
}

module track_x() {
    translate([-tile_size/2 - 2, 0, tile_thickness]) 
    rotate([0, 90, 0])
    linear_extrude(tile_size + 4) 
    polygon([
        [0, -track_top_width/2],
        [0, track_top_width/2],
        [track_depth, track_bottom_width/2], 
        [track_depth, -track_bottom_width/2] 
    ]);
}

module track_top() { translate([0, tile_size/2 - track_inset, 0]) track_x(); }
module track_bottom() { translate([0, -tile_size/2 + track_inset, 0]) track_x(); }
module track_left() { translate([-tile_size/2 + track_inset, 0, 0]) rotate([0, 0, 90]) track_x(); }
module track_right() { translate([tile_size/2 - track_inset, 0, 0]) rotate([0, 0, 90]) track_x(); }

module pegboard_grid() {
    steps = [-3, -2, -1, 0, 1, 2, 3];
    for (x = steps) {
        for (y = steps) {
            translate([x * peg_spacing, y * peg_spacing, 0]) {
                translate([0, 0, -1])
                    cylinder(h = tile_thickness + 2, d = peg_diameter);
                translate([0, 0, tile_thickness - peg_chamfer + 0.01])
                    cylinder(h = peg_chamfer, d1 = peg_diameter, d2 = peg_diameter + (peg_chamfer*2));
            }
        }
    }
}