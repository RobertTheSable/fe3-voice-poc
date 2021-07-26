# Mystery of the Emblem Voice Acting Proof of Concept
Repository for code for proof of concepts related to voice acting via MSU1 in FE3.

No sound files are stored here. You will also need to create your own .msu file.

This is just a proof of concept and not a final product. It is not indended for usage by a general audience.

## How it works

Currently only normal dialogue between characters/in villages is implemented. I may implement more later if there is interest or I feel like it.

For each text event/conversation, a base track index is stored. The file trackindexes.asm holds the index for each event. 
* The offset in the table corresponds to the index number the game uses to load the text. 
* So for text event #1 (the dialogue between Jeigan, Marth, and Caeda at the start of Book 1), the track index is also #$0001.
* After each pause in the text, the track index is incremented and a new file is played.
* If the track index is 0 or the file is missing, the POC reverts to normal sound effects.

## Applying to code

Patch a revision 1.1 rom with `msutest.asm` using asar. Revision 1.0 may work but I have not tested it.

## Adding sounds/voice files.

* Convert whatever sound files you want to the MSU1 PCM format, then place them alongside the rom.
* Sort the files in the order you want them played in a conversation, then name them starting at the base index of that conversation minus 1.
** e.g. "romname-0.pcm" for index 1, "romname-1.pcm" for index 2, etc.
* Set the base index for the conversation you want to have voice acting for in `trackindexes.asm`.
