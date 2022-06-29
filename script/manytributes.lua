if not aux.XyzProcedure then
	aux.XyzProcedure = {}
	Xyz = aux.XyzProcedure
end
if not Xyz then
	Xyz = aux.XyzProcedure
end
function Xyz.CheckValidMultiXyzMaterial(c,xyz)
	if not c:IsHasEffect(890900113) then return false end
	local eff={c:GetCardEffect(c890900113)}
	for i=1,#eff do
		local te=eff[i]
		local tgf=te:GetOperation()
		if not tgf or tgf(te,xyz) then return true end
	end
	return false
end