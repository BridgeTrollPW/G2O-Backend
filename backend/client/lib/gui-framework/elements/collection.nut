class GUI.Collection
{
#private:
	m_positionPx = null

#public:
	childs = null

	constructor(x, y)
	{
		m_positionPx = { x = nax(x), y = nay(y) }
		childs = []
	}

	function insert(pointer)
	{
		local bodyPos = getPositionPx()
		local childPos = pointer.getPositionPx()
		childs.append({element = pointer, offset = GUI.Vector2D(childPos.x, childPos.y)})
		pointer.setPositionPx(bodyPos.x + childPos.x, bodyPos.y + childPos.y)
	}

	function remove(pointer)
	{
		foreach(index, item in childs)
		{
			if (pointer == item.element)
				childs.remove(index)
		}
	}

	function getPositionPx()
	{
        return m_positionPx
	}

	function getPosition()
	{
        return { x = nax(m_positionPx.x), y = nay(m_positionPx.y) }
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function setPositionPx(x, y)
	{
		m_positionPx.x = x
		m_positionPx.y = y

		foreach(item in childs)
			item.element.setPositionPx(item.offset.x + x, item.offset.y + y)
	}

	function setVisible(visible)
	{
		foreach (item in childs)
			item.element.setVisible(visible)
	}

	function top()
	{
		foreach (item in childs)
			item.element.top()
	}

	function destroy()
	{
		foreach (item in childs)
			item.element.destroy()
	}
}
