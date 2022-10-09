--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(s.xyzfilter),7,2)
end
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsSetCard(0x3de,xyz,sumtype,tp)<=1 and c:IsCode(46986415,xyz,sumtype,tp)<=1
end