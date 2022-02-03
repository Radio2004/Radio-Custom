--Likanari, The Observer of Toxic Chimeras
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
			--Copy Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
			--Cannot Destroyed
	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetCondition(s.tdcon)
		e2:SetCountLimit(1)
		e2:SetValue(s.valcon)
		c:RegisterEffect(e2)
end
s.material_setcode=0x22B
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x22B,fc,sumtype,tp) and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,sumtype,tp))
end
function s.fusfilter(c,code,fc,sumtype,tp)
	return c:IsSummonCode(fc,sumtype,tp,code) and not c:IsHasEffect(511002961)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
	function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4 
end
function s.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function s.filter(c)
	return c:IsSetCard(0x22B) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil and c:CheckActivateEffect(false,true,false):GetOperation()~=nil
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chain=Duel.GetCurrentChain()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,chk,chain) end
	chain=chain-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chk,chain)
	local te,teg,tep,tev,tre,tr,trp=g:GetFirst():CheckActivateEffect(false,true,true)
	if not te then te=g:GetFirst():GetActivateEffect() end
	if te:GetCode()==EVENT_CHAINING then
		if chain<=0 then return false end
		local te2,p=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te2:GetHandler()
		local g=Group.FromCards(tc)
		teg,tep,tev,tre,tr,trp=g,p,chain,te2,REASON_EFFECT,p
	end
	s[Duel.GetCurrentChain()]=te
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetTarget(s.targetchk(teg,tep,tev,tre,tr,trp))
	e:SetOperation(s.operationchk(teg,tep,tev,tre,tr,trp))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_CHAIN)
	e1:SetLabelObject(e)
	e1:SetOperation(s.resetop)
	Duel.RegisterEffect(e1,tp)
end
function s.targetchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local te=s[Duel.GetCurrentChain()]
				if chkc then
					local tg=te:GetTarget()
					return tg(e,tp,teg,tep,tev,tre,tr,trp,0,true)
				end
				if chk==0 then return true end
				if not te then return end
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				local tg=te:GetTarget()
				if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
			end
end
function s.operationchk(teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local te=s[Duel.GetCurrentChain()]
				if not te then return end
				local op=te:GetOperation()
				if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
			end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		te:SetTarget(s.target)
		te:SetOperation(s.operation)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local te=s[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=s[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

