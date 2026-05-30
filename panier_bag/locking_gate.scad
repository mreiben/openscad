// Timbuk2 Custom Tuck - Quick-Release Locking Gate
$fn = 60;

// --- PARAMETERS ---
thick = 6;         
length = 26;       
pivot_dia = 3.4;   
head_dia = 12;     
tip_dia = 10;      
slot_width = 16;   
slot_thick = 2.5;  

difference() {
    hull() {
        cylinder(h=thick, d=head_dia); 
        translate([length, 0, 0]) cylinder(h=thick, d=tip_dia); 
        translate([length + 2, 12, 0]) cylinder(h=thick, d=8); 
    }
    translate([0, 0, -1]) cylinder(h=thick+2, d=pivot_dia);
    translate([0, 0, thick - 2.5]) cylinder(h=3.5, d=6.5);
    translate([length + 2, 12, -1]) rotate([0, 0, 25]) hull() {
        translate([-slot_width/2, 0, 0]) cylinder(h=thick+2, d=slot_thick);
        translate([slot_width/2, 0, 0]) cylinder(h=thick+2, d=slot_thick);
    }
}