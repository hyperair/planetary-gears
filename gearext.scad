use <MCAD/gears/involute_gears.scad>
use <ruler.scad>

function convert_circular_pitch (circular_pitch) = circular_pitch * 180 / PI;

module herringbone_gear (
    number_of_teeth=15,
    circular_pitch=false, diametral_pitch=false,
    pressure_angle=28,
    clearance = 0.2,
    gear_thickness=5,
    rim_thickness=8,
    rim_width=5,
    hub_thickness=10,
    hub_diameter=15,
    bore_diameter=5,
    circles=0,
    backlash=0,
    twist=0,
    involute_facets=0,
    flat=false,
    roundsize=1,
    internal=false)
{
    module helical_gear()
    {
        gear (
            number_of_teeth = number_of_teeth,
            circular_pitch = circular_pitch,
            pressure_angle = pressure_angle,
            clearance = clearance,
            gear_thickness = gear_thickness / 2,
            rim_thickness = rim_thickness / 2,
            rim_width = rim_width,
            hub_thickness = hub_thickness / 2,
            hub_diameter = hub_diameter,
            bore_diameter = bore_diameter,
            circles = circles,
            backlash = backlash,
            twist = twist / 2,
            involute_facets = involute_facets,
            flat = flat,
            roundsize = roundsize,
            internal = internal);
    }

    helical_gear ();
    mirror ([0, 0, 1])
    helical_gear ();
}

herringbone_gear (
    number_of_teeth = 30,
    circular_pitch = convert_circular_pitch(7),
    hub_thickness = 10,
    rim_thickness = 10,
    twist = 20,
    $fn = 100
);

%cylinder (
    r = ((7 * 30) / (2 * PI)),
    h = 20);

xyzruler ();
