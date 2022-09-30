--Gaiden Melirria - Kaede & Naoki
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,s.tfilter,1,1,s.tfilter1,1,1)
	c:EnableReviveLimit()
end
s.material={890900035,890900036}
s.listed_names={890900035,890900036}
s.material_setcode=0x3dd
function s.tfilter(c,scard,sumtype,tp)
	return c:IsSummonCode(scard,sumtype,tp,890900035) or c:IsHasEffect(890900032)
end
function s.tfilter1(c,scard,sumtype,tp)
	return c:IsSummonCode(scard,sumtype,tp,890900036) or c:IsHasEffect(890900032)
end
