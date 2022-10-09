--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,7,2,nil,nil,nil,nil,false)
end
function s.xyzfilter(c,xyz,sumtype,tp,d,re)
	return (c:IsSetCard(0x3de,xyz,sumtype,tp) or c:IsHasEffect(890900042))
end