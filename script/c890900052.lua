--Ancient Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,7,2,nil,nil,nil,nil,false,s.xyzcheck)
end
function s.xyzcheck(g,tp,xyz)
	local ct1=g:FilterCount(Card.IsSetCard,nil,0x3de)
	local ct2=g:FilterCount(Card.IsHasEffect,nil,890900042)
	return ct1>0 and ct2<=1
end