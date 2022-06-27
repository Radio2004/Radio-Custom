--Mentor of Melirria - Ghost Azrail
	local s,id=GetID()
	function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--revive limit
	c:EnableUnsummonable()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_REVIVE_LIMIT)
	e0:SetCondition(s.rvlimit)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.psplimit)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(s.splimit)
	c:RegisterEffect(e3)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
	--unaffected by opponent card effects
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(s.tgcon)
	e5:SetValue(s.efilter)
	c:RegisterEffect(e5)
	-- Search 1 "Mentor of Melirria" Monster
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.thtg1)
	e6:SetOperation(s.thop1)
	c:RegisterEffect(e6)
end
	function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
	function s.rvlimit(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND) or e:GetHandler():IsLocation(LOCATION_EXTRA)
end
	function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x3dd) and c:IsAttribute(ATTRIBUTE_DARK)
end
	function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.filter1,LOCATION_MZONE,0,nil)
end
	function s.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x3dd) and (sumtp&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
	function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
	function s.rfilter(c)
	return c:IsSetCard(0x3dd) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
	end
	function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),s.rfilter,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),s.rfilter,1,1,nil)
	if Duel.Release(g,REASON_COST) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x3dd+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
		Duel.SpecialSummonComplete()
end
	end
	function s.th1filter(c)
	return c:IsSetCard(0x22c3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
	function s.desfilter(c)
	return c:IsSetCard(0x22c3)
end
	function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.desfilter,tp,LOCATION_PZONE,0,1,nil) and Duel.IsExistingMatchingCard(s.th1filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
	function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_PZONE,0,1,1,nil)
	if #dg==0 then return end
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.th1filter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
	function s.filter(c)
	return c:IsSetCard(0x2704) and c:IsAbleToHand()
end
	function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
	end