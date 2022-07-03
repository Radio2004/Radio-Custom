--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,1)
	c:EnableReviveLimit()
		--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetDescription(aux.Stringid(id,1))
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(s.op)
		Duel.RegisterEffect(ge1,0)
	end)
end
	s.listed_series={0x3dd}
	function s.rfilter(c,tp)
	return c:IsCode(890900113) and c:GetOverlayGroup()>=2  and (c:IsControler(tp) or c:IsFaceup())
end
	function s.filter(c)
	return c:IsCode(890900018)
end
	function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter,0,LOCATION_HAND,LOCATION_HAND,nil)
	local tc=g1:GetFirst()
	while tc do
			if tc:GetFlagEffect(id)==0 then
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SPSUMMON_PROC)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e2:SetRange(LOCATION_HAND)
			if tc:IsCode(890900018) then
				e2:SetValue(1)
				e2:SetCondition(s.sumcon)
				e2:SetTarget(s.sumtg)
				e2:SetOperation(s.sumop)
			end
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=g1:GetNext()
	end
end
function s.sumcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	return aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	local mg=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg==1 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end