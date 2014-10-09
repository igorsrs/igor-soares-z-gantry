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
  lwall=LIGHT_WALL_WIDTH,
  hsupp=HORIZONTAL_SUPPORT_WALL,
  nut_h=7,
  nut_width=14,
  screw_r=9/2,
  h=40,
  bed_screw_r=3.7/2,
  bed_screw_first=10,
  bed_screw_second=40,
  bed_screws_side_difference=40)
{
  difference() {
    union() {
      cylinder(r=(nut_width/2+wall)/cos(30), h=h, $fn=6);
    }
    translate([0,0,-1])
      #cylinder(r=nut_width/(2*cos(30)), h=nut_h +1, $fn=6);
    translate([0,0,nut_h+wall])
      #cylinder(r=nut_width/(2*cos(30)), h=h +1, $fn=6);
    translate([0,0,nut_h+hsupp])
      #cylinder(r=screw_r, h=h);
  }
}

