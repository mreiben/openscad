// Modular Wind-Up Mini Golf System
// PART 3: Bridge Obstacle

/* [Core Tolerances] */
tile_thickness = 8;
peg_diameter = 5.5; 

$fn = 60; 

// ==========================================
// RENDER SELECTION
// ==========================================
bridge_obstacle();

// ==========================================
// BRIDGE OBSTACLE MODULE
// ==========================================

module bridge_obstacle() {
  // Bridge geometry
  bridge_len = 180;  // Length remains 180mm to maximize slope length
  path_w = 40;       // Path width for the golf ball
  rail_w = 4;        // Width of guard rails on each side
  total_w = path_w + 2 * rail_w; // Total width: 48mm
  deck_h = 10;       // Reduced deck height to 10mm for a incredibly gentle and smooth roll-over!
  rail_h = 4;        // Height of rails above deck surface
  
  // Tolerances
  c_hole = 0.2;      // Tolerance for connector peg holes

  // Reorient the entire assembly so:
  // - The bridge length is along the Y-axis (north-south track flow)
  // - The bridge width is along the X-axis (east-west)
  // - The height goes vertically along the Z-axis
  rotate([90, 0, 90]) {
    difference() {
      // ----------------------------------------------------
      // 1. SOLID BRIDGE FOUNDATION (manifold base)
      // ----------------------------------------------------
      linear_extrude(height=total_w, center=true)
        polygon([
          [-bridge_len/2, 0],
          [-20, deck_h + rail_h],
          [20, deck_h + rail_h],
          [bridge_len/2, 0]
        ]);
      
      // ----------------------------------------------------
      // 2. SUBTRACTIONS & CUTOUTS
      // ----------------------------------------------------
      
      // A. The flat bottom tunnel arch underneath the bridge
      cylinder(h=total_w + 2, r=6, center=true);
      
      // B. The recessed ball rolling path of width path_w
      linear_extrude(height=path_w, center=true)
        polygon([
          [-(bridge_len/2 + 5), 0.5],
          [-20, deck_h],
          [20, deck_h],
          [(bridge_len/2 + 5), 0.5],
          [(bridge_len/2 + 5), deck_h + rail_h + 10],
          [-(bridge_len/2 + 5), deck_h + rail_h + 10]
        ]);
      
      // C. 3D Printing Material Relief Pockets (Hollowed Underside)
      // - Removes unnecessary plastic to save ~50% filament and printing time.
      // - Leaves 3mm thick outer side walls and a 3mm thick walkway floor.
      // - Leaves a solid 12mm central spine (rib) along z = 0 to house the peg holes securely.
      // - No supports needed since the ceiling slopes gently at a printable angle.
      for (z_offset = [-13.5, 13.5]) {
        // Left ramp relief pockets (from x = -70 to x = -12)
        translate([0, 0, z_offset])
          linear_extrude(height=15, center=true)
            polygon([
              [-70, -0.1],
              [-20, deck_h - 3],
              [-12, deck_h - 3],
              [-12, -0.1]
            ]);
        
        // Right ramp relief pockets (from x = 12 to x = 70)
        translate([0, 0, z_offset])
          linear_extrude(height=15, center=true)
            polygon([
              [12, -0.1],
              [12, deck_h - 3],
              [20, deck_h - 3],
              [70, -0.1]
            ]);
      }
      
      // D. Pegboard Connector Holes (on flat bottom along centerline)
      // - Placed at x = -25 and x = 25 in bridge space (translates to y = -25 and y = 25 in tile space)
      // - Fully enclosed by the 12mm central spine, leaving 3.15mm of solid wall on all sides!
      for (x_pos = [-25, 25]) {
        translate([x_pos, -0.1, 0])
          rotate([-90, 0, 0])
            cylinder(h=6.1, d=peg_diameter + c_hole);
      }
    }
  }
}
