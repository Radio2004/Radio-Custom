--G.E.C. Magician EX
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,5,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
end
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,1512300000)
end
