--Naoki Tiba & Kaede Aoki, Novella Girl
Duel.LoadScript("link2.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Add attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)
	-- Effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2,false,REGISTER_FLAG_NOVELLA)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
s.listed_series={0x1BC}
s.listed_names={444444461}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1bc) and not c:IsType(TYPE_LINK)
end


	function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(9)
	return true
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=nil
	if e:GetLabel()==9 then
		g1=e:GetHandler():IsReleasable() and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	else
		g1=Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
	local g2=true
	local b1=g1
	local b2=g2
	if chk==0 then e:SetLabel(0) return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		if e:GetLabel()==9 then
			Duel.Release(e:GetHandler(),REASON_COST)
end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
	e:SetLabel(op)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3201)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
end
	else
		 local e2=Effect.CreateEffect(c)
		 e2:SetType(EFFECT_TYPE_SINGLE)
		 e2:SetCode(id)
		 e2:SetLabelObject({s.tgval})
		 e2:SetValue(2)
		 e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		 c:RegisterEffect(e2)
	end
end

function s.tgval(c)
	return c:IsCode(444444461)
end