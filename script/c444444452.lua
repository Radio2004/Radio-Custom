--Novella: Madness
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to DARK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(s.tg)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1BC))
	c:RegisterEffect(e3)
	--attack up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
	--effects
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.spcon)
	e1:SetCost(s.cost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	end 
	function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*300
	end


	function s.tg(e,c,tp)
	if not c:IsSetCard(0x1BC) then return false end
	if c:GetFlagEffect(1)==0 then
		c:RegisterFlagEffect(1,0,0,0)
		local eff
		if c:IsLocation(LOCATION_MZONE) then
			eff={Duel.GetPlayerEffect(c:GetControler(),EFFECT_NECRO_VALLEY)}
		else
			eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
		end
		c:ResetFlagEffect(1)
		for _,te in ipairs(eff) do
			local op=te:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	return true
end


function s.filter1(c)
	return c:IsFaceup()and c:IsSetCard(0x1BC)
	end
	function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil)
end

	function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	return true
end


function s.filter2(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged(true)
end
function s.cfilter(c,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)
	if c:IsControler(tp) and c:GetSequence()<5 then ft=ft+1 end
	return ft>0 and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,c)
end
	
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(aux.disfilter3,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=nil 
	if e:GetLabel()==9 then
		  b2=Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,tp)
	else
		  b2=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
			and Duel.IsExistingTarget(s.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
	if chk==0 then e:SetLabel(0) return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
	 e:SetCategory(CATEGORY_DISABLE)
	 e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	 local g=Duel.SelectTarget(tp,aux.disfilter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	 Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	else 
		if e:GetLabel()==9 then
		local rg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,tp)
			Duel.Release(rg,REASON_COST)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
	e:SetLabel(op)
end


function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
	if tc and aux.disfilter3(tc) and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		tc:RegisterEffect(e3)
		end
	end
	else 
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end