--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,nil,nil,nil,false)
end
function s.xyzfilter(c,xyz,sumtype,tp)
	if c:IsHasEffect(890900042) then
	return c:IsSetCard(0x3de,xyz,sumtype,tp) and c:IsLevel(7)
	else
	return (c:IsSetCard(0x3de,xyz,sumtype,tp) or c:IsHasEffect(890900042)) and c:IsLevel(7)
	end
end