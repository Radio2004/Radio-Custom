--Myra Emerald, Novella Girl
local s,id=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	-- Effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2,false,REGISTER_FLAG_NOVELLA)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_series={0x1BC}
s.listed_names={444444447}
	function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev) and (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,1,nil)
	end

   function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	and rc:IsLocation(LOCATION_HAND) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)   
	end


	function s.disop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if not c:IsRelateToEffect(e) then return end
		if tc and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
   if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			end
		end 
	end

function s.setfilter(c)
	return c:IsSetCard(0x1BC) and c:IsType(TYPE_SPELL) and c:IsSSetable()
	end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND)
	local g2=Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,0,0,1,RACE_FAIRY,ATTRIBUTE_WIND) then
		local token=Duel.CreateToken(tp,id+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local c=e:GetHandler()
		local tc=g:GetFirst()
		local fid=c:GetFieldID()
		Duel.SSet(tp,tc)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		end
	end
end