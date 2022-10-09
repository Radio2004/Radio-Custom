--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.xyzfilter),7,2,nil,nil,nil,nil,false,s.xyzcheck)
end
function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(Card.IsHasEffect,nil,890900042)
	return #mg<=1
end

function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsSetCard(0x3de,xyz,sumtype,tp)
end