class GUI.Bar extends classes(GUI.Texture, GUI.Orientable)
{
#private:
	m_alignment = null

	m_marginPx = null
	m_stretching = true

	m_value = 0
	m_minimum = 0
	m_maximum = 100

#public:
	progress = null

	constructor(x, y, width, height, marginX, marginY, background, progress, orientation = Orientation.Horizontal, alignment = Align.Left, window = null)
	{
		base.constructor(x, y, width, height, background, window)
		setDisabled(true)

		m_orientation = orientation
		m_alignment = alignment

		m_marginPx = {x = nax(marginX), y = nay(marginY)}

		this.progress = GUI.Texture(0, 0, 0, 0, progress)

		setPosition(x, y)
		setSize(width, height)
	}

	function getPercentage()
	{
		return fabs(m_value - m_minimum) / fabs(m_maximum - m_minimum)
	}

	function getValue()
	{
		return m_value
	}

	function setValue(value)
	{
		if (value > m_maximum)
			value = m_maximum
		else if (value < m_minimum)
			value = m_minimum

		m_value = value

		local maxSize = getSizePx()
		setSizePx(maxSize.width, maxSize.height)
	}

	function getMinimum()
	{
		return m_minimum
	}

	function setMinimum(minimum)
	{
		m_minimum = minimum
		setValue(m_minimum)
	}

	function getMaximum()
	{
		return m_maximum
	}

	function setMaximum(maximum)
	{
		m_maximum = maximum
		setValue(m_minimum)
	}

	function top()
	{
		base.top()
		progress.top()
	}

	function destroy()
	{
		base.destroy()
		progress.destroy()
	}

	function getStreching()
	{
		return m_stretching
	}

	function setStretching(stretching)
	{
		m_stretching = stretching
	}

	function getAlignment()
	{
		return m_alignment
	}

	function setAlignment(alignment)
	{
		m_alignment = alignment

		local position = getPositionPx()
		setPositionPx(position.x, position.y)

		setValue(getValue())
	}

	function setVisible(visible)
	{
		base.setVisible(visible)
		progress.setVisible(visible)
	}

	function setAlpha(alpha)
	{
		base.setAlpha(alpha)
		progress.setAlpha(alpha)
	}

	function setPositionPx(x, y)
	{
		base.setPositionPx(x, y)

		local size = getSizePx()

		if (m_orientation == Orientation.Horizontal)
		{
			local percentage = ((size.width - m_marginPx.x * 2) * getPercentage()).tointeger()

			switch (m_alignment)
			{
				case Align.Left:
					progress.setPositionPx(x + m_marginPx.x, y + m_marginPx.y)
					break

				case Align.Right:
					progress.setPositionPx(x + size.width - percentage - m_marginPx.x, y + m_marginPx.y)
					break

				case Align.Center:
					progress.setPositionPx(x + (size.width - percentage) / 2, y + m_marginPx.y)
					break
			}
		}
		else if (m_orientation == Orientation.Vertical)
		{
			local percentage = ((size.height - m_marginPx.y * 2) * getPercentage()).tointeger()

			switch (m_alignment)
			{
				case Align.Left:
					progress.setPositionPx(x + m_marginPx.x, y + m_marginPx.y)
					break

				case Align.Right:
					progress.setPositionPx(x + m_marginPx.x, y + size.height - percentage - m_marginPx.y)
					break

				case Align.Center:
					progress.setPositionPx(x + m_marginPx.x, y + (size.height - percentage) / 2)
					break
			}
		}
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function changeProgress(rectX, rectY, rectWidth, rectHeight)
	{
		if (!m_stretching)
		{
			local size = getSizePx()

			progress.setSizePx((size.width - m_marginPx.x * 2), size.height - m_marginPx.y * 2)
			progress.setRectPx(rectX, rectY, rectWidth, rectHeight)
		}

		progress.setSizePx(rectWidth, rectHeight)
	}

	function setSizePx(width, height)
	{
		base.setSizePx(width, height)

		local position = getPositionPx()

		if (m_orientation == Orientation.Horizontal)
		{
			local percentage = ((width - m_marginPx.x * 2) * getPercentage()).tointeger()

			switch (m_alignment)
			{
				case Align.Left:
					changeProgress(0, 0, percentage, height - m_marginPx.y * 2)
					break

				case Align.Right:
					changeProgress(width - percentage - m_marginPx.x * 2, 0, percentage, height - m_marginPx.y * 2)
					setPositionPx(position.x, position.y)
					break

				case Align.Center:
					changeProgress((width - percentage - m_marginPx.x * 2) / 2, 0, percentage, height - m_marginPx.y * 2)
					setPositionPx(position.x, position.y)
					break
			}
		}
		else if (m_orientation == Orientation.Vertical)
		{
			local percentage = ((height - m_marginPx.y * 2) * getPercentage()).tointeger()

			switch (m_alignment)
			{
				case Align.Left:
					changeProgress(0, 0, width - m_marginPx.x * 2, percentage)
					break

				case Align.Right:
					changeProgress(0, height - percentage - m_marginPx.y * 2, width - m_marginPx.x * 2, percentage)
					setPositionPx(position.x, position.y)
					break

				case Align.Center:
					changeProgress(0, (height - percentage - m_marginPx.y * 2) / 2, width - m_marginPx.x * 2, percentage)
					setPositionPx(position.x, position.y)
					break
			}
		}
	}

	function setSize(width, height)
	{
		setSizePx(nax(width), nay(height))
	}

	function getMarginPx()
	{
		return m_marginPx
	}

	function setMarginPx(x, y)
	{
		local position = getPositionPx()
		local size = getSizePx()

		m_marginPx.x = x
		m_marginPx.y = y

		setPositionPx(position.x, position.y)
		setSizePx(size.width, size.height)
	}

	function getMargin()
	{
		return {x = anx(m_marginPx.x), y = any(m_marginPx.y)}
	}

	function setMargin(x, y)
	{
		setMarginPx(nax(x), nay(y))
	}
}
