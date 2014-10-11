/*
 * Igor Soares' parallel kinematic XY
 * Linear bushing housing
 * (C) 2014 by Ígor Bruno Pereira Soares
 *
 * This project is free: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This project is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this project.  If not, see <http://www.gnu.org/licenses/>.
 */

include <configuration.scad>

z_nut_cage($fn=64);

module z_nut_cage(
  wall=WALL_WIDTH,
  lwall=3,
  hsupp=HORIZONTAL_SUPPORT_WALL,
  nut_h=7,
  nut_width=14,
  screw_r=9/2,
  h=40,
  bed_screw_r=3.7/2,
  bed_screw_first=6,
  bed_screw_second=40,
  bed_screw_streching=10,
  bed_screws_side_difference=45)
{
  w = bed_screws_side_difference + 2*wall + 2*bed_screw_r;
  l = bed_screw_second + bed_screw_r + wall + bed_screw_streching/2;
  nut_housing_r=(nut_width/2 + lwall)/cos(30);
  a = 45;
  difference() {
    union() {
      cylinder(r=nut_housing_r, h=h, $fn=6);
      translate([-w/2,-bed_screw_streching/2,0])
        cube([w, l + bed_screw_streching/2, lwall]);
      difference() {
        union() for(i=[-nut_housing_r, nut_housing_r - lwall])
          translate([i, 0, 0])
            cube([lwall, l, h]);
       translate([-nut_housing_r - 1, l, wall]) rotate([45,0,0])
        #cube([2*nut_housing_r +2, l/cos(a), h/cos(a)]);
      }
    }
    translate([0,0,-1])
      #cylinder(r=nut_width/(2*cos(30)), h=h - wall -nut_h +1, $fn=6);
    translate([0,0,h -nut_h])
      #cylinder(r=nut_width/(2*cos(30)), h=h +1, $fn=6);
    translate([0,0,h -nut_h - wall +hsupp])
      #cylinder(r=screw_r, h=h);
    for (i=[1,-1])
      translate([i*bed_screws_side_difference/2, bed_screw_first, -1])
        rotate([0,0,90])
          #streched_cylinder(r=bed_screw_r, strech=bed_screw_streching, h=h+2);
    for (i=[1,-1])
      translate([i*bed_screws_side_difference/2, bed_screw_second, -1])
        rotate([0,0,90])
          #streched_cylinder(r=bed_screw_r, strech=bed_screw_streching, h=h+2);
  }
}

module streched_cylinder(r=10, h=10, strech=0) {
  union() {
    translate([-strech/2, 0, 0])
      cylinder(r=r, h=h);
    translate([-strech/2, -r, 0])
      cube([strech, 2*r, h]);
    translate([strech/2, 0, 0])
      cylinder(r=r, h=h);
  }
}

