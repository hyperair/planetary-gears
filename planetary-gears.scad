use <gearext.scad>
use <ruler.scad>

$fa = 5;
$fs = 1;

module planetary_gears (
    circular_pitch = 7,
    hub_thickness = 10,
    rim_thickness = 10,
    rim_width = 999,
    gear_thickness = 5,
    twist = 200,
    bore_diameter = 30,
    clearance = 0.4,
    backlash = 0.4,

    number_of_planets = 5,

    sun_teeth = 20,
    ring_teeth = 30,
    ring_outer_diameter = 80)
{
    planet_teeth = (ring_teeth - sun_teeth) / 2;

    if (floor (planet_teeth) != planet_teeth) {
        echo (
            "ERROR: planet_teeth == ", planet_teeth,
            " which is not a round number!");
    }

    if ((sun_teeth + ring_teeth) % number_of_planets != 0) {
        echo (
            "ERROR: sun_teeth + ring_teeth is not divisible by ",
            "number_of_planets.");
        echo ("ERROR: Planet gear will not mesh with the ring.");
    }

    module single_gear (
        bore_diameter = 0,
        circular_pitch = circular_pitch,
        hub_thickness = hub_thickness,
        rim_thickness = rim_thickness,
        rim_width = rim_width,
        gear_thickness = gear_thickness,
        twist = twist,
        clearance = clearance,
        backlash = backlash,
        number_of_teeth = 0)
    {
        herringbone_gear (
            bore_diameter = bore_diameter,
            circular_pitch = convert_circular_pitch (circular_pitch),
            hub_thickness = hub_thickness,
            rim_thickness = rim_thickness,
            rim_width = rim_width,
            gear_thickness = gear_thickness,
            twist = twist / number_of_teeth,
            number_of_teeth = number_of_teeth,
            clearance = clearance,
            backlash = backlash
        );
    }

    module sun ()
    {
        single_gear (
            number_of_teeth = sun_teeth,
            hub_thickness = 0,
            bore_diameter = bore_diameter);
    }

    module planet ()
    {
        single_gear (
            number_of_teeth = planet_teeth,
            twist = -twist,
            hub_thickness = 0,
            bore_diameter = 0);
    }

    function pitch_radius (circular_pitch, number_of_teeth) = (
        (circular_pitch * number_of_teeth) /
        (2 * PI));

    module all_planets ()
    {
        sun_pitch_radius = pitch_radius (circular_pitch, sun_teeth);
        planet_pitch_radius = pitch_radius (circular_pitch, planet_teeth);

        echo ("Sun pitch radius: ", sun_pitch_radius);
        echo ("Planet pitch radius: ", planet_pitch_radius);
        echo ("Ring pitch radius: ", pitch_radius (circular_pitch, ring_teeth));

        // 0th tooth is at 0° from the X-axis, and we're translating along X.
        // This allows us to match the first trough with the sun gear's 0th
        // tooth.
        first_trough_angle = 180 + 360 / planet_pitch_radius / 2;

        for (orbit_angle = [0:360/number_of_planets:359.99]) {
            rotate ([0, 0, orbit_angle])
            translate ([sun_pitch_radius + planet_pitch_radius, 0, 0])
            rotate ([0, 0, (first_trough_angle +
                        orbit_angle / planet_teeth * sun_teeth)])
            planet ();
        }
    }

    module ring ()
    {
        render () {
            difference () {
                cylinder (
                    d = ring_outer_diameter,
                    h = rim_thickness,
                    center = true);

                single_gear (
                    hub_thickness = rim_thickness,
                    rim_thickness = rim_thickness,
                    gear_thickness = rim_thickness,
                    number_of_teeth = ring_teeth,
                    bore_diameter = 0,
                    twist = -twist,
                    clearance = -clearance,
                    backlash = -backlash
                );
            }
        }
    }

    sun ();
    ring ();
    all_planets ();
}

planetary_gears ();
