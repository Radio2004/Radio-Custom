--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 2 Rank 4 "Exorsister" Xyz Monsters
	Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,nil,nil,nil,false)
	-- Must be Xyz Summoned using the correct materials
end
function s.xyzfilter(c,xyz,sumtype,tp)
	return (c:IsSetCard(0x3de,xyz,sumtype,tp) or c:IsHasEffect(890900042)==1) and c:IsLevel(7)
end