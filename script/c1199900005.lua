--Attackers and Blockers - Fire Warrior
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,aux.FilterBoolFunctionEx(Card.IsSetCard,0x14f1),1,s.ffilter,1)
	--Special Summon 1 "0x14f1" from your Deck, hand, or GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.atktg2)
	e2:SetOperation(s.atkop2)
	c:RegisterEffect(e2)
end
s.listed_series={0x14f1}
s.material_setcode={0x14f1}
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:GetBaseAttack()~=c:GetAttack()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x14f1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		--Increase ATK/DEF
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_UPDATE_ATTACK)
		 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)		 e1:SetValue(1000)
		 tc:RegisterEffect(e1)
		 local e2=e1:Clone()
		 e2:SetCode(EFFECT_UPDATE_DEFENSE)
		 tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()~=c:GetAttack()
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack()//1000)
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local mtgc=tc:GetFirst():GetAttack()//1000
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Damage(1-tp,mtgc,REASON_EFFECT)
	end
end