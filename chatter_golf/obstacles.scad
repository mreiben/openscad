// Modular Wind-Up Mini Golf System
// PART 2: Obstacles & Accessories

/* [Core Tolerances] */
tile_thickness = 8;
peg_diameter = 5.5; 

$fn = 60; 

// ==========================================
// RENDER SELECTION
// Uncomment the piece you want to export
// ==========================================

// --- OBSTACLES (Moving Hazards) ---
turnstile_base();
// turnstile_rotor();        // TIP: Print this upside-down in your slicer!

// --- OBSTACLES (Directional Plug-in Holes) ---
// plug_hole_1_ramp();       
// plug_hole_2_ramp_thru();  
// plug_hole_2_ramp_turn();  
// plug_hole_3_ramp();       
// plug_hole_4_ramp();       

// --- ACCESSORIES ---
// connector_peg();          

// ==========================================
// TURNSTILE MODULES
// ==========================================

module turnstile_base() {
    base_length = 70;
    base_width = 20;
    base_height = 10;
    axle_diameter = 8;
    axle_height = 30; 
    c_hole = 0.2; 
    
    difference() {
        union() {
            translate([0, 0, base_height/2]) 
                cube([base_length, base_width, base_height], center=true);
            translate([0, 0, base_height]) 
                cylinder(h=axle_height, d=axle_diameter);
            translate([0, 0, base_height])
                cylinder(h=2, d1=axle_diameter + 6, d2=axle_diameter);
        }
        
        for (x = [-25, 25]) {
            translate([x, 0, -0.1])
                cylinder(h=8.1, d=peg_diameter + c_hole);
        }
    }
}

module turnstile_rotor() {
    clearance = 0.6; 
    hub_d = 16;
    hub_h = 32; 
    arm_length = 80; 
    arm_thickness = 6;
    arm_height = 12; 

    difference() {
        union() {
            cylinder(h=hub_h, d=hub_d);
            translate([0, 0, hub_h - arm_height]) {
                for (r = [0, 90, 180, 270]) {
                    rotate([0, 0, r])
                        translate([hub_d/2 - 0.5, -arm_thickness/2, 0])
                            cube([arm_length - hub_d/2 + 0.5, arm_thickness, arm_height]);
                }
            }
        }
        translate([0, 0, -1]) 
            cylinder(h=hub_h + 2, d=8 + clearance);
    }
}

// ==========================================
// TARGET HOLE MODULES
// ==========================================

module plug_hole_1_ramp()      { build_directional_hole([1, 0, 0, 0]); }
module plug_hole_2_ramp_thru() { build_directional_hole([1, 0, 1, 0]); }
module plug_hole_2_ramp_turn() { build_directional_hole([1, 1, 0, 0]); }
module plug_hole_3_ramp()      { build_directional_hole([1, 1, 0, 1]); }
module plug_hole_4_ramp()      { build_directional_hole([1, 1, 1, 1]); }

module build_directional_hole(ramps) {
    height = 10;
    hole_diameter = 85; 
    c_hole = 0.2; 
    
    core_size = 115; 
    t_front = -core_size/2;
    t_right =  core_size/2;
    t_back  =  core_size/2;
    t_left  = -core_size/2;
    
    ramp_run = 35;
    b_front = ramps[0] ? t_front - ramp_run : t_front;
    b_right = ramps[1] ? t_right + ramp_run : t_right;
    b_back  = ramps[2] ? t_back  + ramp_run : t_back;
    b_left  = ramps[3] ? t_left  - ramp_run : t_left;
    
    difference() {
        hull() {
            translate([0, 0, 0.1])
                linear_extrude(0.2, center=true)
                polygon([
                    [b_left, b_front],
                    [b_right, b_front],
                    [b_right, b_back],
                    [b_left, b_back]
                ]);
            translate([0, 0, height - 0.1])
                linear_extrude(0.2, center=true)
                polygon([
                    [t_left, t_front],
                    [t_right, t_front],
                    [t_right, t_back],
                    [t_left, t_back]
                ]);
        }
        
        translate([0, 0, -1])
            cylinder(h=height + 2, d=hole_diameter);

        peg_spread = 50;
        steps = [-peg_spread, 0, peg_spread];
        for(x = steps) {
            for(y = steps) {
                if (x != 0 || y != 0) {
                    translate([x, y, -0.1])
                        cylinder(h=8.1, d=peg_diameter + c_hole);
                }
            }
        }
    }
}

// ==========================================
// ACCESSORY MODULES
// ==========================================

module connector_peg() {
    c = 0.15;
    d = peg_diameter - c;
    h = 15;
    chamf = 1; 
    
    union() {
        translate([0, 0, chamf]) 
            cylinder(h = h - 2*chamf, d = d);
        cylinder(h = chamf, d1 = d - 2*chamf, d2 = d);
        translate([0, 0, h - chamf]) 
            cylinder(h = chamf, d1 = d, d2 = d - 2*chamf);
    }
}