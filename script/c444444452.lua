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
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1bc))
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
	e5:SetCost(s.cost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	end
s.listed_series={0x1BC}
	function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0x1BC),e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*300
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

	
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(aux.disfilter3,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=nil 
	if e:GetLabel()==9 then
		  b2=Duel.CheckReleaseGroupCost(tp,Card.IsSetCard,1,false,nil,nil,0x1bc)
	end
	if chk==0 then e:SetLabel(0) return b1 or b2 end
	local op=Duel.SelectEffect(tp,
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
		local sg=Duel.SelectReleaseGroupCost(tp,Card.IsSetCard,1,1,false,nil,nil,0x1bc)
		Duel.Release(sg,REASON_COST)
		end
	end
	e:SetLabel(op)
end


function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
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
		--cannot be target
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(id,5))
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1bc))
		e4:SetValue(aux.tgoval)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end