import os
import random
import math
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance

def create_glassy_sketch_logo(output_path, size=1024):
    # Colors
    bg_color_top = (255, 255, 255, 255)
    bg_color_bottom = (240, 240, 245, 255)
    
    # Sketch Theme Colors
    pencil_graphite = (45, 45, 45, 255)
    highlighter_pink = (255, 107, 107, 200) # Semi-transparent pink
    margin_pink = (255, 182, 193, 255)
    
    # Create image
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # 1. Background Shape (Squircle-ish)
    # macOS icons are rounded squares. We'll draw a large rounded rectangle.
    # Actually, for AppIcon.icns, we should just fill the square if it's for the iconset, 
    # but macOS usually handles the masking. 
    # HOWEVER, to make it look good as a standalone image, let's draw the shape.
    # For the actual .icns, Apple recommends filling the canvas and letting the OS mask it,
    # BUT for the "document" icon style or custom shape, we can draw the shape.
    # Let's draw a full-size square and let the OS clip it, 
    # BUT since we want "Glassy" effect, we need the borders visible within the mask.
    # So we will draw a shape slightly smaller than full size or just full size with effects.
    # Let's target the full square and apply effects.
    
    # Gradient Background
    for y in range(size):
        r = int(bg_color_top[0] + (bg_color_bottom[0] - bg_color_top[0]) * y / size)
        g = int(bg_color_top[1] + (bg_color_bottom[1] - bg_color_top[1]) * y / size)
        b = int(bg_color_top[2] + (bg_color_bottom[2] - bg_color_top[2]) * y / size)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))
        
    # Add Paper Texture (Noise)
    noise = Image.effect_noise((size, size), 10) # 10 is sigma
    # Blend noise
    # Since Image.effect_noise returns grayscale, convert to RGBA
    noise = noise.convert("RGBA")
    noise.putalpha(20) # Very subtle
    img = Image.alpha_composite(img, noise)
    draw = ImageDraw.Draw(img)
    
    # 2. Etched Grid Lines (Notebook style)
    line_spacing = int(size / 8)
    for y in range(line_spacing, size, line_spacing):
        # Wobbly line
        points = []
        for x in range(0, size, 10):
            offset_y = random.randint(-1, 1)
            points.append((x, y + offset_y))
        draw.line(points, fill=(200, 200, 210, 150), width=2)

    # Margin Line
    margin_x = int(size * 0.15)
    margin_points = []
    for y in range(0, size, 10):
        offset_x = random.randint(-1, 1)
        margin_points.append((margin_x + offset_x, y))
    draw.line(margin_points, fill=margin_pink, width=3)
    
    # 3. Main Symbol: Checkmark (Sketch style)
    # Coordinates for a checkmark
    # Start: (0.25, 0.55), Mid: (0.45, 0.75), End: (0.8, 0.25)
    p1 = (size * 0.25, size * 0.55)
    p2 = (size * 0.42, size * 0.72)
    p3 = (size * 0.75, size * 0.25)
    
    def wobble_line(start, end, width, color, wobble_intensity=3):
        # Draw multiple thin lines to simulate pencil sketch
        num_strokes = 5
        for _ in range(num_strokes):
            points = []
            steps = 20
            dx = (end[0] - start[0]) / steps
            dy = (end[1] - start[1]) / steps
            
            current_x, current_y = start
            points.append((current_x, current_y))
            
            for i in range(steps):
                current_x += dx
                current_y += dy
                # Add wobble
                wx = random.uniform(-wobble_intensity, wobble_intensity)
                wy = random.uniform(-wobble_intensity, wobble_intensity)
                points.append((current_x + wx, current_y + wy))
            
            # Vary opacity and width slightly
            stroke_color = list(color)
            stroke_color[3] = random.randint(150, 255)
            w = random.randint(width-2, width+2)
            draw.line(points, fill=tuple(stroke_color), width=w)

    # Draw Highlighter background for Checkmark
    # Thick pink stroke behind
    draw.line([p1, p2, p3], fill=highlighter_pink, width=int(size * 0.12), joint='curve')
    
    # Draw Pencil Checkmark on top
    wobble_line(p1, p2, width=int(size * 0.02), color=pencil_graphite)
    wobble_line(p2, p3, width=int(size * 0.02), color=pencil_graphite)
    
    # 4. Glass Gloss Effect
    # Draw a diagonal gradient overlay for "shine"
    # This is hard with basic PIL, but we can simulate with a polygon
    gloss_layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    gloss_draw = ImageDraw.Draw(gloss_layer)
    
    # Top-left shine
    gloss_points = [(0, 0), (size, 0), (0, size)]
    # Use a gradient here would be better, but solid semi-transparent white is ok for simple glass
    gloss_draw.polygon(gloss_points, fill=(255, 255, 255, 40))
    
    # Composite gloss
    img = Image.alpha_composite(img, gloss_layer)
    
    # 5. Inner Shadow / Border (Etched Glass Look)
    border_layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    border_draw = ImageDraw.Draw(border_layer)
    border_width = int(size * 0.03)
    # Draw white border
    border_draw.rectangle([0, 0, size, size], outline=(255, 255, 255, 180), width=border_width)
    img = Image.alpha_composite(img, border_layer)
    
    # Save
    if not os.path.exists(os.path.dirname(output_path)):
        os.makedirs(os.path.dirname(output_path))
    
    img.save(output_path)
    print(f"Generated logo at {output_path}")

def generate_iconset():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(base_dir) # .../MacToDo
    iconset_dir = os.path.join(project_root, "Resources", "MacToDo.iconset")
    
    if not os.path.exists(iconset_dir):
        os.makedirs(iconset_dir)
    
    # Generate master image
    master_size = 1024
    master_path = os.path.join(iconset_dir, "icon_512x512@2x.png")
    create_glassy_sketch_logo(master_path, size=master_size)
    
    # Resize for other sizes
    sizes = [
        (16, 1, "icon_16x16.png"),
        (16, 2, "icon_16x16@2x.png"),
        (32, 1, "icon_32x32.png"),
        (32, 2, "icon_32x32@2x.png"),
        (128, 1, "icon_128x128.png"),
        (128, 2, "icon_128x128@2x.png"),
        (256, 1, "icon_256x256.png"),
        (256, 2, "icon_256x256@2x.png"),
        (512, 1, "icon_512x512.png"),
    ]
    
    master_img = Image.open(master_path)
    
    for size, scale, filename in sizes:
        target_size = size * scale
        if target_size == 1024:
            continue # Already generated
            
        resized_img = master_img.resize((target_size, target_size), Image.Resampling.LANCZOS)
        resized_img.save(os.path.join(iconset_dir, filename))
        print(f"Generated {filename}")

if __name__ == "__main__":
    generate_iconset()
