using TEntityId = unsigned int;

class CActor
{
public:
	virtual ~CActor()
	{
	}

	virtual void Tick() = 0;
};

class CHudPanel final : public CActor
{
public:
	explicit CHudPanel(TEntityId EntityId)
		: m_EntityId(EntityId)
		, m_pTarget(nullptr)
	{
	}

	void Tick() override
	{
	}

	void SetTarget(CActor* pTarget)
	{
		m_pTarget = pTarget;
	}

private:
	TEntityId m_EntityId;
	CActor* m_pTarget;
};
