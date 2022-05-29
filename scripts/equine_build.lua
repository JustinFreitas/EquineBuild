local getEncumbranceMult_orig
local bFGU

function onInit()
	local featureNamePath = "charsheet.*.traitlist.*.name"
	DB.addHandler(featureNamePath, "onAdd", onTraitNameAddOrUpdate)
	DB.addHandler(featureNamePath, "onUpdate", onTraitNameAddOrUpdate)
	bFGU = checkFGU()

	if bFGU then
		getEncumbranceMult_orig = CharEncumbranceManager5E.getEncumbranceMult
		CharEncumbranceManager5E.getEncumbranceMult = getEncumbranceMultOverride
	else
		getEncumbranceMult_orig = CharManager.getEncumbranceMult
		CharManager.getEncumbranceMult = getEncumbranceMultOverride
	end
end

function checkFGU()
	local nMajor, nMinor, nPatch = Interface.getVersion()
	if nMajor >= 5 then return true end
	if nMajor == 4 and nMinor >= 2 then return true end
	return nMajor == 4 and nMinor == 1 and nPatch >= 14
end

-- This is entered on strength change or trait change (not feature)
-- due to the way record_char_inventory.xml works.
-- See: <number_linked name="encumbrancebase" source="encumbrance.encumbered">
function getEncumbranceMultOverride(nodeChar)
	local mult = getEncumbranceMult_orig(nodeChar)
	local nStackCount = 0
	if hasQualifyingEquineBuildTrait(nodeChar) then
		nStackCount = nStackCount + 1
	end

	if nStackCount > 0 then
		mult = mult * (2 * nStackCount)
	end

	return mult
end

function hasQualifyingEquineBuildTrait(nodeChar)
	local bEquineBuild
	for _, nodeTrait in pairs(DB.getChildren(nodeChar, "traitlist")) do
		local name = DB.getValue(nodeTrait, "name", ""):lower()
		if string.match(name, "^%W*equine%W+build%W*$") then
			bEquineBuild = true;
		end
	end

	return bEquineBuild
end

function onTraitNameAddOrUpdate(nodeFeatureName)
	-- Node hierarchy to character sheet: charsheet.featurelist.feature.name
	local nodeChar = nodeFeatureName.getParent().getParent().getParent()

	if bFGU then
		CharEncumbranceManager5E.updateEncumbranceLimit(nodeChar)
	else
		local windowCharsheet = Interface.findWindow("charsheet", nodeChar)
		updateInventoryPaneEncumbranceBaseIfLoaded(windowCharsheet)
	end
end

function updateInventoryPaneEncumbranceBaseIfLoaded(w)
	if not (w and w.inventory
			  and w.inventory.subwindow
			  and w.inventory.subwindow.contents
			  and w.inventory.subwindow.contents.subwindow
			  and w.inventory.subwindow.contents.subwindow.encumbrancebase
			  and w.inventory.subwindow.contents.subwindow.encumbrancebase.onTraitsUpdated) then
		return
	end

	-- See: <number_linked name="encumbrancebase" source="encumbrance.encumbered">
	w.inventory.subwindow.contents.subwindow.encumbrancebase.onTraitsUpdated()
end
