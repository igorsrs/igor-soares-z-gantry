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
//use <linear_bushing_housing.scad>

mirror([0,1,0])
rotate([90,0,0])
z_car($fn=64);

module z_car(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    hsupp=-0.01,
    vsupp=VERTICAL_SUPPORT_WALL,
    screw_r=3.7/2,
    screw_nut_width=6.7,
    bushing_r=LINEAR_BUSHING_DIAMETER/2,
    bushing_l=LINEAR_BUSHING_LEN,
    bushing_wall=LINEAR_BUSHING_WALL,
    total_len=100,
    bed_screw_r=3.7/2,
    bed_screws_room=6,
    threaded_rod_r=8.4/2,
    threaded_rod_room=10,
    threaded_rod_h_pos=30,
    bed_screws_separation=40)
{
  bushings_separation = total_len - 2*bushing_l - 4*bushing_wall;
  bed_base_len = wall + bed_screws_room + bed_screws_separation +
                 bed_screws_room;
  screws_pos = [
    [
      -(wall + bed_screws_room),
      bushing_r + lwall + bed_screws_room,
      0
    ], [
      -bed_screws_separation - (wall + bed_screws_room),
      bushing_r + lwall + bed_screws_room,
      0
    ]
  ];


  difference() {
    union() {
      translate([bushing_r,bushing_r - wall + lwall,0])
        rotate([0,0,-90]) rotate([0,-90,0])
      linear_bushing_housing_positive(
        wall=wall,
        lwall=lwall,
        screw_r=screw_r,
        bushing_r=bushing_r,
        bushing_l=bushing_l);

      translate([-bed_base_len, bushing_r + lwall - wall, ST])
        difference()
      {
         cube([bed_base_len, lwall, bed_base_len + wall]);
         translate([0,-1,wall + ST]) rotate([0,-45,0])
          #cube([bed_base_len*sqrt(2), lwall +2, bed_base_len*sqrt(2)]);
      }
      translate([-bed_base_len, bushing_r + lwall - wall, ST])
         cube([bed_base_len, wall + bed_screws_room, wall]);
      for (sp=screws_pos)
        translate(sp){
          cylinder(r=bed_screws_room - ST, h=wall);
      }
      translate([
              -bushing_r - lwall - threaded_rod_room,
              bushing_r + lwall - wall,
              threaded_rod_h_pos + threaded_rod_room])
        mirror([0,0,1]) difference()
      {
          cube([2*threaded_rod_room,
                lwall,
                2*threaded_rod_room +bushing_r + lwall + threaded_rod_room]);
          translate([-ST,-1,2*threaded_rod_room]) rotate([0,45,0]) mirror([1,0,0])
            #cube([2*threaded_rod_room,
                   lwall +2,
                   2*threaded_rod_room +bushing_r + lwall + threaded_rod_room]);
      }
      translate([
              -bushing_r - lwall - threaded_rod_room,
              bushing_r + lwall - wall,
              threaded_rod_h_pos])
        rotate([-90,0,0])
          cylinder(r=threaded_rod_room, h=lwall);
    }
      for (sp=screws_pos)
        translate(sp) translate([0,0,-1]){
          #cylinder(r=bed_screw_r - ST, h=wall+2);
      }
      translate([
              -bushing_r - lwall - threaded_rod_room,
              bushing_r + lwall - wall -1,
              threaded_rod_h_pos])
        rotate([-90,0,0])
          #cylinder(r=threaded_rod_r, h=wall +2);
  }
}

module linear_bushing_housing_positive(
    wall=WALL_WIDTH,
    lwall=LIGHT_WALL_WIDTH,
    bushing_r=15.0/2 -0.1,
    bushing_l=24.4,
    bushing_wall=1.0,
    total_len=100,
    screw_r=3.7/2,
    dual_bushing=true,
    support_h=30)
{

  bushings_positions = dual_bushing ? 
                           [0, total_len - 2*lwall - bushing_l] :
                           [total_len/2 - wall - bushing_l/2];
  difference() {
    union() {
      translate([0, - wall - bushing_r, 0])
        cube([total_len, 2*(wall + bushing_r), lwall + ST]);
      translate([0, - wall - bushing_r, 0])
        cube([total_len, wall, wall]);

      for(xi=bushings_positions) {
        for(yi=[0, wall + 2*bushing_r - bushing_wall]) {
          translate([xi, yi - wall - bushing_r, 0])
            cube([bushing_l + 2*lwall,
                  wall + bushing_wall,
                  lwall + (1+cos(45))*bushing_r]);
          translate([xi + lwall + bushing_l/2 - lwall - screw_r,
                     yi - wall - bushing_r,
                     0])
            cube([2*lwall + 2*screw_r,
                  wall + bushing_wall,
                  lwall + 2*bushing_r + screw_r]);
          translate([xi + lwall + bushing_l/2,
                     yi - wall - bushing_r,
                     lwall + 2*bushing_r + screw_r])
           rotate([-90,0,0]){
             cylinder(r=screw_r + lwall, h=wall+bushing_wall);
           }
        }
      }
    }

    translate([-1, 0, lwall + bushing_r]) rotate([0,90,0])
      #cylinder(r=bushing_r - bushing_wall, h=total_len +2);
    for(xi=bushings_positions)
      translate([xi + lwall, 0, lwall + bushing_r]) rotate([0,90,0])
        #cylinder(r=bushing_r, h=bushing_l);

    for(xi=bushings_positions) {
      for(yi=[0, wall + 2*bushing_r - bushing_wall]) {
          translate([xi + lwall + bushing_l/2,
                     yi - wall - bushing_r,
                     lwall + 2*bushing_r + screw_r])
           rotate([-90,0,0]){
             translate([0,0,-1])
               #cylinder(r=screw_r, h=wall+bushing_wall +2);
           }
      }
    }
  }
}

