#!/bin/bash

# ===================================================
# Image Management & Optimization Script (imgmgmt.sh)
# ---------------------------------------------------
#
# Description:
#   This script processes JPG, JPEG, and PNG images - either a single file or all images in a directory.
#   Its a combination of Grok 3 and Whatever AI Cursor uses. Here is what it can do.
#   - Optimizes JPG/JPEG images for web (strips metadata, compresses, renames .jpeg to .jpg)
#   - Optimizes PNG images using pngquant
#   - Generates 200x200 and 500x500 thumbnails for images larger than 500px wide
#   - Skips thumbnail generation for small images
#   - Displays progress and color-coded output for clarity
#   - Saves thumbnails to ../public/images/thumbs
#   - NEW: Can convert all JPG/JPEG images to PNG format with --convert-to-png flag
#   - NEW: Can skip thumbnail generation with --no-thumbs flag
#
# Usage:
#   ./imgmgmt.sh <file_or_directory> [--convert-to-png] [--no-thumbs]
#
#   <file_or_directory> : Path to a single image file or directory containing images to process
#   --convert-to-png    : Convert all JPG/JPEG images to PNG format (optional)
#   --no-thumbs         : Skip thumbnail generation (optional)
#
# Requirements:
#   - bash
#   - ImageMagick (convert, identify)
#   - pngquant
#   - ansi (for colored output, see https://github.com/fidian/ansi)
#
# Examples:
#   ./imgmgmt.sh ./resources/images/photo.jpg
#   ./imgmgmt.sh ./resources/images
#   ./imgmgmt.sh ./resources/images --convert-to-png
#   ./imgmgmt.sh ./resources/images/photo.jpg --convert-to-png
#   ./imgmgmt.sh ./resources/images --no-thumbs
#   ./imgmgmt.sh ./resources/images --convert-to-png --no-thumbs
#
# Notes:
#   - The script will create the thumbs directory if it does not exist.
#   - Existing thumbnails are not overwritten.
#   - The script must be run from the directory where the ansi script is located, or adjust the path to ansi accordingly.
#   - When using --convert-to-png, original JPG/JPEG files are deleted after successful conversion.
#   - PNG conversion uses high quality (65-80%) to preserve image quality.
# =============================================

# Load the ANSI library
source ./ansi  # Adjust path to your ansi installation

# ANSI color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Nice divider
DIVIDER=$(ansi --bold --bg-blue --white "==========================================")

# ASCII Art Banner
echo -e "${GREEN}"
cat << "EOF"
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░▀█▀░█▄█░█▀▀░█▄█░█▀▀░█▄█░▀█▀░
░░█░░█░█░█░█░█░█░█░█░█░█░░█░░
░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░▀░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
echo -e "${RESET}Image Optimization Script - v1.2${RESET}"
echo -e "${BLUE}Starting at $(date '+%I:%M %p CDT, %B %d, %Y')...${RESET}"

# Parse command line arguments
CONVERT_TO_PNG=false
SKIP_THUMBS=false
INPUT_PATH=""

# Parse arguments - handle multiple flags
for arg in "$@"; do
    case $arg in
        --convert-to-png)
            CONVERT_TO_PNG=true
            echo -e "${YELLOW}PNG conversion mode enabled${RESET}"
            ;;
        --no-thumbs)
            SKIP_THUMBS=true
            echo -e "${YELLOW}Thumbnail generation disabled${RESET}"
            ;;
        *)
            if [ -z "$INPUT_PATH" ]; then
                INPUT_PATH="$arg"
            fi
            ;;
    esac
done

# Check if a file or directory is provided
if [ -z "$INPUT_PATH" ]; then
    echo -e "${RED}Usage: $0 <file_or_directory> [options]${RESET}"
    echo -e "${YELLOW}Options:${RESET}"
    echo -e "  --convert-to-png    Convert all JPG/JPEG images to PNG format"
    echo -e "  --no-thumbs         Skip thumbnail generation"
    echo -e "${YELLOW}Examples:${RESET}"
    echo -e "  $0 ./images"
    echo -e "  $0 ./images --convert-to-png"
    echo -e "  $0 ./images --no-thumbs"
    echo -e "  $0 ./images --convert-to-png --no-thumbs"
    exit 1
fi

# Check if the file or directory exists
if [ ! -e "$INPUT_PATH" ]; then
    echo -e "${RED}Error: '$INPUT_PATH' not found.${RESET}"
    exit 1
fi

# Check if pngquant is installed
if ! command -v pngquant &> /dev/null; then
    echo -e "${RED}Error: pngquant is not installed. Please install it first.${RESET}"
    exit 1
fi

# Get the script's directory and calculate the repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Thumbs directory variable - always relative to repo root
THUMBS_DIR="$REPO_ROOT/public/images/thumbs"

# Only create thumbs directory if we're going to use it
if [ "$SKIP_THUMBS" = false ]; then
    mkdir -p "$THUMBS_DIR"  # Create thumbs directory if it doesn't exist
    echo -e "${BLUE}Thumbnails will be saved to: $THUMBS_DIR${RESET}"
else
    echo -e "${YELLOW}Thumbnail generation is disabled${RESET}"
fi

# Function to convert JPG/JPEG to PNG
convert_to_png() {
    local src=$1
    local dest=$2
    
    # Convert JPG/JPEG to PNG with high quality
    magick "$src" -quality 95 "$dest"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Converted to PNG: $dest${RESET}"
        return 0
    else
        echo -e "${RED}Failed to convert to PNG: $src${RESET}"
        return 1
    fi
}

# Function to calculate aspect ratio and resize
resize_image() {
    local src=$1
    local dest=$2
    local size=$3
    local quality=$4
    local width=$(identify -format "%w" "$src")
    local height=$(identify -format "%h" "$src")
    local ratio=$(echo "scale=2; $width / $height" | bc)

    if [ "$size" -eq 200 ]; then
        local new_height=$(echo "scale=0; $size / $ratio" | bc)
        magick "$src" -resize "${size}x${new_height}^" -gravity center -extent "${size}x${new_height}" -quality "$quality" "$dest"
    elif [ "$size" -eq 500 ]; then
        local new_height=$(echo "scale=0; $size / $ratio" | bc)
        magick "$src" -resize "${size}x${new_height}^" -gravity center -extent "${size}x${new_height}" -quality "$quality" "$dest"
    fi
    
    # Check if the thumbnail was actually created
    if [ $? -eq 0 ] && [ -f "$dest" ]; then
        return 0
    else
        echo -e "${RED}ERROR: Failed to create thumbnail: $dest${RESET}"
        return 1
    fi
}

# Function to process a single image
process_image() {
    local file="$1"
    local current="$2"
    local total="$3"
    
    if [ -n "$total" ]; then
        PERCENT=$(echo "scale=2; ($current * 100) / $total" | bc)
        echo -ne "${YELLOW}Progress: ${PERCENT}% [${current}/${total}]${RESET}\r"
    fi
    
    echo -e "${DIVIDER}"
    echo -e "${GREEN}Processing: $file${RESET}"

    # Handle PNG conversion mode
    if [ "$CONVERT_TO_PNG" = true ]; then
        if [[ "$file" =~ \.(jpg|jpeg)$ ]]; then
            # Convert JPG/JPEG to PNG
            png_file="${file%.*}.png"
            if convert_to_png "$file" "$png_file"; then
                # Remove original JPG file
                rm "$file"
                echo -e "${YELLOW}Removed original: $file${RESET}"
                file="$png_file"
                echo -e "${GREEN}Now processing as PNG: $file${RESET}"
            fi
        fi
    else
        # Normal mode: Rename JPEG to JPG if needed
        if [[ "$file" =~ \.jpeg$ ]]; then
            new_file="${file%.jpeg}.jpg"
            mv "$file" "$new_file"
            file="$new_file"
            echo -e "${YELLOW}Renamed: $file${RESET}"
        fi
    fi

    # Get file size for quality decisions
    filesize=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file")

    # Optimize based on file type
    if [[ "$file" =~ \.jpg$ ]]; then
        # Optimize JPG (strip metadata, compress)
        if [ "$filesize" -gt 102400 ]; then  # 100KB in bytes
            magick "$file" -strip -interlace Plane -quality 75 "$file"
            echo -e "${BLUE}Optimized $file (quality 75%, >100KB)${RESET}"
        else
            magick "$file" -strip -interlace Plane -quality 60 "$file"
            echo -e "${BLUE}Optimized $file (quality 60%, <=100KB)${RESET}"
        fi
    elif [[ "$file" =~ \.png$ ]]; then
        # Optimize PNG with pngquant
        echo -e "${BLUE}Optimizing PNG with pngquant: $file${RESET}"
        pngquant --ext .png --force --quality 65-80 "$file"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Successfully optimized: $file${RESET}"
        else
            echo -e "${RED}Failed to optimize: $file${RESET}"
        fi
    fi

    # Generate thumbnails for BOTH JPG and PNG files (if large enough and not disabled)
    if [ "$SKIP_THUMBS" = false ]; then
        dimensions=$(identify -format "%w %h" "$file")
        read width height <<< "$dimensions"
        
        if [ "$width" -gt 500 ]; then
            # Determine quality based on original file size
            quality_200=$([ "$filesize" -gt 102400 ] && echo 60 || echo 50)
            quality_500=$([ "$filesize" -gt 102400 ] && echo 80 || echo 70)

            # Determine thumbnail extension based on file type
            if [[ "$file" =~ \.png$ ]]; then
                thumb_ext="png"
            else
                thumb_ext="jpg"
            fi
            
            # Create 200x200 thumbnail
            thumb_200="${THUMBS_DIR}/${file##*/}-200.$thumb_ext"
            if [ ! -f "$thumb_200" ]; then
                echo -e "${GREEN}-[ 200 ]-${RESET}"
                if resize_image "$file" "$thumb_200" 200 "$quality_200"; then
                    echo -e "${BLUE}Created 200x200 thumbnail: $thumb_200 (quality $quality_200%)${RESET}"
                fi
            else
                echo -e "${YELLOW}200x200 thumbnail already exists: $thumb_200${RESET}"
            fi

            # Create 500x500 thumbnail
            thumb_500="${THUMBS_DIR}/${file##*/}-500.$thumb_ext"
            if [ ! -f "$thumb_500" ]; then
                echo -e "${GREEN}-[ 500 ]-${RESET}"
                if resize_image "$file" "$thumb_500" 500 "$quality_500"; then
                    echo -e "${BLUE}Created 500x500 thumbnail: $thumb_500 (quality $quality_500%)${RESET}"
                fi
            else
                echo -e "${YELLOW}500x500 thumbnail already exists: $thumb_500${RESET}"
            fi
        else
            echo -e "${YELLOW}Image $file is smaller than 500px wide, skipping thumbnails${RESET}"
        fi
    else
        echo -e "${YELLOW}Thumbnail generation skipped (--no-thumbs enabled)${RESET}"
    fi
}

# Determine if input is a file or directory
if [ -f "$INPUT_PATH" ]; then
    # Single file mode
    echo -e "${GREEN}Single file mode: Processing $INPUT_PATH${RESET}"
    process_image "$INPUT_PATH"
    TOTAL_IMAGES=1
    IS_DIRECTORY=false
elif [ -d "$INPUT_PATH" ]; then
    # Directory mode
    echo -e "${GREEN}Directory mode: Processing all images in $INPUT_PATH${RESET}"
    
    # Count total images to process
    TOTAL_IMAGES=$(find "$INPUT_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)
    CURRENT=0
    echo -e "${GREEN}Total images to process: $TOTAL_IMAGES${RESET}"

    # Process images
    find "$INPUT_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        ((CURRENT++))
        process_image "$file" "$CURRENT" "$TOTAL_IMAGES"
    done
    IS_DIRECTORY=true
else
    echo -e "${RED}Error: '$INPUT_PATH' is neither a file nor a directory.${RESET}"
    exit 1
fi

echo -e "${DIVIDER}"
echo -e "${GREEN}Processing complete!${RESET}"
if [ "$IS_DIRECTORY" = true ]; then
    echo -e "${GREEN}Processed $TOTAL_IMAGES images from directory.${RESET}"
else
    echo -e "${GREEN}Processed $TOTAL_IMAGES image file.${RESET}"
fi
if [ "$CONVERT_TO_PNG" = true ]; then
    echo -e "${YELLOW}PNG conversion mode was enabled.${RESET}"
fi
if [ "$SKIP_THUMBS" = true ]; then
    echo -e "${YELLOW}Thumbnail generation was disabled.${RESET}"
else
    echo -e "${BLUE}Thumbnails saved in $THUMBS_DIR${RESET}"
fi
echo -e "${DIVIDER}"

exit 0
