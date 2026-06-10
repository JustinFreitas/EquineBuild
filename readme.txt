https://github.com/JustinFreitas/EquineBuild

Equine Build v1.3, by Justin Freitas

ReadMe and Usage Notes

The purpose of this Fantasy Grounds 5e extension is to apply an additional 2x multiplier to encumbrance limits to PCs that have 'Equine Build' listed in their Traits section of the Abilities tab of their character sheet. Equine Build works like Powerful Build, whose automation is already built into the ruleset.

Changelist:
- v1.0 - Initial version, based off of the Aspect of the Beast: Bear extension.
- v1.1 - Icon update. Load order bump.
- v1.2 - Icon update again, 42px.
- v1.3 - Fix FGU encumbrance error after ruleset update. The override now resolves a character node from either a DB node (FGC) or an rActor (FGU), since FGU's CharEncumbranceManager5E.getEncumbranceMult is passed an rActor rather than a char node.
