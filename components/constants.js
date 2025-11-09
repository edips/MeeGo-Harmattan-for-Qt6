/****************************************************************************
**
** Originally part of the MeeGo Harmattan Qt Components project
** © 2011 Nokia Corporation and/or its subsidiary(-ies). All rights reserved.
**
** Licensed under the BSD License.
** See the original license text for redistribution and use conditions.
**
** Ported from MeeGo Harmattan (Qt 4.7) to Qt 6 by Edip Ahmet Taskin, 2025.
**
****************************************************************************/




// Base unit for scaling, can be adjusted for screen density
const dp = 1;

// --- MATERIAL DESIGN SIZING FOR LISTS & MENU ITEMS ---

// HEIGHTS
const LIST_ITEM_ONE_LINE_HEIGHT = 48 * dp;
const LIST_ITEM_TWO_LINE_HEIGHT = 72 * dp;

// PADDING & SPACING
const LIST_ITEM_PADDING_HORIZONTAL = 16 * dp; // Padding from screen edge
const LIST_ITEM_ICON_TEXT_SPACING = 32 * dp;  // Gap between icon and text to align text to the 72dp keyline

// ICON SIZE
const LIST_ICON_SIZE = 24 * dp;

// FONT SIZES (sp is the unit, but pixelSize is the property in QML)
const LIST_TITLE_FONT_SIZE = 16 * dp;
const LIST_SUBTITLE_FONT_SIZE = 14 * dp;

// --- MATERIAL DESIGN SIZING FOR BUTTONS ---
const BUTTON_HEIGHT = 48 * dp;
const BUTTON_ICON_TEXT_SPACING = 8 * dp; // Standard gap between an icon and text in a button

// --- MATERIAL DESIGN SIZING FOR MENUS ---
const MENU_VERTICAL_PADDING = 8 * dp; // Padding at the top and bottom of a menu list

/* Margins */
var INDENT_DEFAULT = 16;
var CORNER_MARGINS = 25;
var MARGIN_DEFAULT = 0;
var MARGIN_XLARGE = 16;

// ListDelegate
var LIST_ITEM_MARGIN = 16
var LIST_ITEM_SPACING = 16
var LIST_ITEM_HEIGHT = 80
var LIST_TILE_SIZE = 26
var LIST_TITLE_COLOR = "#282828"
var LIST_TITLE_COLOR_PRESSED = "#797979"
var LIST_TITLE_COLOR_INVERTED = "#ffffff"
var LIST_TITLE_COLOR_PRESSED_INVERTED = "#797979"
var LIST_SUBTILE_SIZE = 22
var LIST_SUBTITLE_COLOR = "#505050"
var LIST_SUBTITLE_COLOR_PRESSED = "#797979"
var LIST_SUBTITLE_COLOR_INVERTED = "#C8C8C8"
var LIST_SUBTITLE_COLOR_PRESSED_INVERTED = "#797979"

/* Font properties */
var FONT_FAMILY = "Nokia Pure Text";
var FONT_FAMILY_BOLD = "Nokia Pure Text Bold";
var FONT_FAMILY_LIGHT = "Nokia Pure Text Light";
var FONT_DEFAULT_SIZE = 24;
var FONT_LIGHT_SIZE = 22;

/* TUMBLER properties */
var TUMBLER_COLOR_TEXT = "#FFFFFF";
var TUMBLER_COLOR_LABEL = "#8C8C8C";
var TUMBLER_COLOR = "#000000";
var TUMBLER_OPACITY_FULL = 1.0;
var TUMBLER_OPACITY = 0.4;
var TUMBLER_OPACITY_LOW = 0.1;
var TUMBLER_FLICK_VELOCITY = 700;
var TUMBLER_ROW_HEIGHT = 64;
var TUMBLER_LABEL_HEIGHT = 54;
var TUMBLER_MARGIN = 16;
var TUMBLER_BORDER_MARGIN = 1;
var TUMBLER_WIDTH = 344;
var TUMBLER_HEIGHT_PORTRAIT = 256;
var TUMBLER_HEIGHT_LANDSCAPE = 192;

/* Button styles */
// Normal
var COLOR_BUTTON_FOREGROUND = "#191919"; // Text color
var COLOR_BUTTON_SECONDARY_FOREGROUND = "#8c8c8c"; // Pressed
var COLOR_BUTTON_DISABLED_FOREGROUND = "#b2b2b4"; // Disabled
// Inverted
var COLOR_BUTTON_INVERTED_FOREGROUND = "#FFFFFF";
var COLOR_BUTTON_INVERTED_SECONDARY_FOREGROUND = "#8c8c8c"; // Pressed
var COLOR_BUTTON_INVERTED_DISABLED_FOREGROUND = "#f5f5f5"; // Disabled

var SIZE_BUTTON = 40;
var SIZE_SMALL_BUTTON = 43;
var WIDTH_SMALL_BUTTON = 122;
var WIDTH_TUMBLER_BUTTON = 120;

var FONT_BOLD_BUTTON = true;

var INFO_BANNER_OPACITY = 0.9
var INFO_BANNER_LETTER_SPACING = -1.2
