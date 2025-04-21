# Dialog System

## Overview
The NPC dialog box starts as a small dot in the center of the screen.
It then:
1. Stretches vertically into a line
2. Expands horizontally into a full-width dialog box
3. Types out the NPC message letter by letter
4. Slides down to reveal 4 dialog options, which fade in one by one

## Buttons
- `PickaxeButton`: Opens the pickaxe shop UI
- `BackpackButton`: Intended to open backpack shop (coming soon)
- `GoodbyeButton`: Ends conversation, fades out dialog UI
- `TempButton`: Placeholder for future feature

## Scripting Notes
- DialogFrame uses `AnchorPoint = {0.5, 0}` for smooth scaling
- Buttons are under `DialogOptionsFrame`, which is a sibling of `DialogOptions`
- Dialog should only animate once after pressing E

## To Fix or Add
- Remove "hey" text appearing during animation
- Prevent player from pressing E again while dialog is active
- Ensure dialog options don’t instantly appear before box finishes typing
