// GLOBAL
$fn = 128; // number of segments
font_size = 10;
font = "ChakraPetch-Bold";
part = "all"; // all | base | border | text

module round_rect(width, height, thickness, radius){
    linear_extrude(thickness)
    offset(r = radius)
    square([width - 2 * radius, height - 2 * radius], center = true);
}

// TEXT

function calculate_width(my_text = "สวัสดี") =
    let (
        metrics = textmetrics(text=my_text, size=font_size, font),
        text_width = round(metrics.advance[0])
        
    )
//    echo(str(metrics))
    echo(str("The total text width is: ", text_width))
    text_width;

module text_extrude(my_text = "สวัสดี", thickness, height, h_pad) {
    if (part == "text" || part == "all") {
        text_width = calculate_width(print_text);
        translate([text_width/2 + h_pad, 0, height + thickness*.5])
        linear_extrude(thickness) {
            text(my_text, size = font_size, font, halign = "center", valign = "center");
        }
    }
}


// TAG

module tag(width = 40, height = 10, thickness = 2, h_pad){

    key_hole_space = 10;
    key_radius = 2.5;
    border_thickness = 2;
    corner_radius = 4;
    width = width + h_pad*2;
    rect_center_x = (-key_hole_space + width)/2;

   
    difference() {
        
        union() {
        
            // base
            if (part == "base" || part == "all") {
                color("green")
                translate([rect_center_x,0,1])
                round_rect(width + key_hole_space, height, thickness, corner_radius);
            }
            
            // border
            if (part == "border" || part == "all") {
                color("white")
                difference(){
                
                    translate([rect_center_x,0,thickness * 1.5])
                    round_rect(width + key_hole_space, height, thickness, corner_radius);
            
                    // remove inner
                    translate([width/2 - border_thickness/2,0,thickness * 1.5-0.01]) 
                    round_rect(width-border_thickness, height - border_thickness*2, thickness*4, corner_radius - border_thickness);
                    
                }
            }
        }
        
        // keyhole
        translate([-key_hole_space/2, 0,0])
        cylinder(30, key_radius);
    }
}

print_text = "hello";
h_pad = 15;
height = 25;
text_width = calculate_width(print_text);
tag(text_width, height, 2, h_pad);
text_extrude(print_text, thickness = 2, height = 2, h_pad);