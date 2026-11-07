---
name: Playful Mastery
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#464555'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4d44e3'
  primary: '#3525cd'
  on-primary: '#ffffff'
  primary-container: '#4f46e5'
  on-primary-container: '#dad7ff'
  inverse-primary: '#c3c0ff'
  secondary: '#006e2f'
  on-secondary: '#ffffff'
  secondary-container: '#6bff8f'
  on-secondary-container: '#007432'
  tertiary: '#684000'
  on-tertiary: '#ffffff'
  tertiary-container: '#885500'
  on-tertiary-container: '#ffd4a4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#3323cc'
  secondary-fixed: '#6bff8f'
  secondary-fixed-dim: '#4ae176'
  on-secondary-fixed: '#002109'
  on-secondary-fixed-variant: '#005321'
  tertiary-fixed: '#ffddb8'
  tertiary-fixed-dim: '#ffb95f'
  on-tertiary-fixed: '#2a1700'
  on-tertiary-fixed-variant: '#653e00'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-lg:
    fontFamily: Nunito Sans
    fontSize: 24px
    fontWeight: '800'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Nunito Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 26px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Nunito Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
  body-lg:
    fontFamily: Nunito Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Nunito Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-lg:
    fontFamily: Nunito Sans
    fontSize: 16px
    fontWeight: '800'
    lineHeight: 20px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Nunito Sans
    fontSize: 13px
    fontWeight: '700'
    lineHeight: 18px
  label-sm:
    fontFamily: Nunito Sans
    fontSize: 11px
    fontWeight: '700'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.5rem
---

## Brand & Style

This design system is tailored for an engaging, gamified mobile language learning experience on modern touch displays. The design language merges contemporary tactile elements with crisp, structured digital surfaces—evoking curiosity, safety to fail, and rewarding achievement. 

Visual attributes draw inspiration from modern micro-tactile education products: punchy status hues, plump interaction surfaces, expressive reward mechanics, and generous touch targets. The experience balances playful delight with educational clarity, ensuring users remain in a frictionless state of flow while navigating exercises, retaining streaks, and reviewing grammar pathways.

## Colors

The palette balances focused instructional clarity with vivid gamification cues:

- **Primary (`#4F46E5` - Indigo):** Drives the primary interface tone, focus states, lesson start triggers, and brand touchpoints.
- **Primary Tint (`#EEF2FF`):** Used for selected states in multi-choice answer tiles, secondary chip fills, and subtle focus glows.
- **Success (`#22C55E` - Emerald/Green):** Reserved strictly for correct submission states, mastered skill indicators, and positive progression.
- **Danger (`#EF4444` - Crimson/Red):** Signals failed validation states, depleted lives, and session errors.
- **Accent & Reward (`#F59E0B` - Amber/Orange):** Denotes active streaks, earned XP badges, unlockable chests, and mastery rings.
- **Background (`#F8FAFC` - Slate 50):** A warm, soft off-white surface that mitigates glare during intensive reading sessions.
- **Surface / Cards (`#FFFFFF`):** High-clarity white cards creating distinct interactive panels.
- **Text Palette:** Deep Slate (`#0F172A`) ensures AAA contrast against cards; Muted Slate (`#64748B`) establishes clean auxiliary hierarchy.
- **Border / Stroke (`#E2E8F0`):** Defines boundaries for non-selected interactive elements and divider lines.

## Typography

The type scale relies on Nunito Sans to blend structural geometry with friendly rounded terminals. 

- **Headlines:** Use heavy weights (`700` and `800`) to provide instant instructional hierarchy during rapid drill exercises.
- **Body Text:** Scaled at `16px` with medium weights (`500`) to maximize scan-speed and legibility during audio-prompt reading and translation exercises.
- **Action & Labels:** Buttons leverage an explicit `800` weight with subtle tracking (`0.02em`) to command clear visual priority on confirmation surfaces. Numbers inside streak counters and status badges utilize strict tabular figure characteristics where applicable.

## Layout & Spacing

Designed primarily around mobile viewport baselines (standardized on 390x844 with flexible auto-scaling):

- **Grid & Margins:** Fluid single-column stack framed by a constant `20px` (`1.25rem`) outer screen margin. Content cards and active lesson modules stretch edge-to-margin to maintain maximum horizontal tap area.
- **Rhythm:** An 8pt spatial baseline governs all inter-element vertical distribution. Compact micro-gaps leverage `4px` (`space-xs`) or `8px` (`space-sm`), while standard stack divisions use `16px` (`space-md`) and `24px` (`space-xl`).
- **Interactive Bounds:** All interactive touch surfaces strictly adhere to minimum touch dimensions of 48×48px, expanding to 56px heights on persistent action buttons to ensure single-thumb reachability.

## Elevation & Depth

This design system avoids dark or heavy drop shadows in favor of soft, tinted ambient illumination and pseudo-3D tactile press behaviors:

- **Level 0 (Flat):** Baseline canvas background (`#F8FAFC`).
- **Level 1 (Cards & Modules):** Raised above the canvas using a soft ambient shadow (`0 4px 12px rgba(15, 23, 42, 0.06)`) paired with an interior structural `1px` border (`#E2E8F0`).
- **Level 2 (Floating Action Panels & Bottom Sheets):** Elevated using `0 8px 24px rgba(15, 23, 42, 0.10)`.
- **Level 3 (Tactile Push States):** Interactive elements such as primary buttons and choice tiles utilize a physical base edge—modeled via a bottom border or shadow inset of 3–4px darker tone (`#3730A3` for Indigo, `#16A34A` for Emerald). On active press (`:active`), the element visually translates downward 2–3px to create a satisfying, springy mechanical response.

## Shapes

The design system embraces an ultra-approachable, rounded geometry that softens technical language learning:

- **Standard Cards & Module Panels:** Styled with an explicit `20px` corner radius.
- **Interactive Action Buttons & Large Inputs:** Standardized with a `16px` corner radius.
- **Progress Trackers, Chips, and Badges:** Fully rounded capsule/pill contours (`rounded-full` / `9999px`) to frame streaks, level markers, and prompt tags cleanly.

## Components

### Buttons
- **Primary Action Button:** Full-width fixed 56px height, `16px` radius, background `#4F46E5`, text `#FFFFFF`, Nunito Sans Bold 16px. Includes a tactile 4px bottom extrusion (`#3730A3`). Strictly limited to one primary button per active exercise view.
- **Secondary / Ghost Button:** 56px height, transparent or white background with a 2px `#E2E8F0` border and `#4F46E5` text.
- **Validation Feedback Button:** Switches dynamically to `#22C55E` (Correct) or `#EF4444` (Incorrect) on verification screens.

### Cards & Option Tiles
- **Exercise Choice Card:** White surface, `20px` radius, `16px` padding, 2px border `#E2E8F0`. When selected, transitions to border `#4F46E5` and background `#EEF2FF`. When checked, morphs to Success (`#22C55E` border, `#F0FDF4` surface) or Danger (`#EF4444` border, `#FEF2F2` surface).
- **Audio / Prompt Card:** Raised white container with prominent speaker icon button and bold text.

### Lesson Top Navigation Bar
- Horizontal flex container with `16px` padding. Houses a standard dismiss button (left), a flexible dynamic progress bar (center) with an 8px height, rounded-full track (`#E2E8F0`), active fill (`#22C55E`), and a live Hearts Counter (right) displaying a red heart glyph alongside remaining lives.

### Gamification Chips & Badges
- **Streak Pill:** Amber pill (`#FEF3C7` background, `#F59E0B` icon and text), showing an active flame glyph and numerical count.
- **XP / Level Indicator:** Amber badge showcasing current lesson point yield (`+10 XP`).

### Bottom Navigation Bar
- 64px height bar anchored over a `#FFFFFF` surface with top border (`#E2E8F0`). Distributes 4 destinations evenly: Home, Practice, Progress, and Profile. Active tabs display an indigo icon accompanied by a subtle tinted pill indicator (`#EEF2FF`).

### Mascot Display ('Lingo')
- Flat-vector, expressive illustration instances positioned above feedback sheets and empty states, reacting dynamically to success streaks and lesson wrap-ups.