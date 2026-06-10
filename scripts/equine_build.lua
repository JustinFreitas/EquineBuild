local getEncumbranceMult_orig

function onInit()
	if checkNewEncumbranceFGU() then
		getEncumbranceMult_orig = CharEncumbranceManager5E.getEncumbranceMult
		CharEncumbranceManager5E.getEncumbranceMult = getEncumbranceMultOverride
	else
		getEncumbranceMult_orig = CharManager.getEncumbranceMult
		CharManager.getEncumbranceMult = getEncumbranceMultOverride
	end
end

function checkNewEncumbranceFGU()
	local nMajor, nMinor, nPatch = Interface.getVersion()
	if nMajor >= 5 then return true end
	if nMajor == 4 and nMinor >= 2 then return true end
	return nMajor == 4 and nMinor == 1 and nPatch >= 14
end

-- This is entered on strength change or trait change (not feature)
-- due to the way record_char_inventory.xml works.
-- See: <number_linked name="encumbrancebase" source="encumbrance.encumbered">
-- Note: FGC's CharManager.getEncumbranceMult is passed a char DB node, while
-- FGU's CharEncumbranceManager5E.getEncumbranceMult is passed an rActor. Pass
-- the original argument straight through to the wrapped function, but resolve a
-- real char node (works for either input) before checking traits.
function getEncumbranceMultOverride(vActor)
	local mult = getEncumbranceMult_orig(vActor)
	local nodeChar = ActorManager.getCreatureNode(vActor)
	if nodeChar and hasEquineBuildTrait(nodeChar) then
		mult = mult * 2
	end

	return mult
end

function hasEquineBuildTrait(nodeChar)
	local bEquineBuild
	for _, nodeTrait in pairs(DB.getChildren(nodeChar, "traitlist")) do
		local name = DB.getValue(nodeTrait, "name", ""):lower()
		if string.match(name, "^%W*equine%W+build%W*$") or string.match(name, "^%W*beast%W+of%W+burden%W*$") then -- TODO: Make Beast of Burden optional.
			bEquineBuild = true;
		end
	end

	return bEquineBuild
end
