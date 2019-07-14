// This script was made with a help of Calysto Canem

addEvent("GUI.onChange")

local activeRange = null

class GUI.Range extends classes(GUI.Texture, GUI.Orientable)
{
#private:
	m_step = 1
	m_value = 0
	m_minimum = 0
	m_maximum = 100

	m_marginPx = 0

#public:
	indicator = null

   constructor(x, y, width, height, file, indicatorFile, orientation = Orientation.Horizontal, window = null)
	{
		local indicatorWidth
		local indicatorHeight

		if (orientation == Orientation.Horizontal)
		{
			indicatorWidth = anx(RANGE_INDICATOR_SIZE)
			indicatorHeight = height
		}
		else if (orientation == Orientation.Vertical)
		{
			indicatorWidth = width
			indicatorHeight = any(RANGE_INDICATOR_SIZE)
		}

		indicator = GUI.Texture(x, y, indicatorWidth, indicatorHeight, indicatorFile)
		indicator.parent = this

		m_orientation = orientation

		base.constructor(x, y, width, height, file, window)
		indicator.top()
	}

	function destroy()
	{
		if (activeRange == this)
			activeRange = null

		indicator = indicator.destroy()
		base.destroy()
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
		local min = m_minimum, max = m_maximum

		if (min > max)
		{
			min = m_maximum
			max = m_minimum
		}

		if (value < min)
			value = min
		else if (value > max)
			value = max

		local oldValue = m_value
		m_value = value

		local position = base.getPositionPx()
		local size = base.getSizePx()

		local indicatorPosition = indicator.getPositionPx()
		local indicatorSize = indicator.getSizePx()

		if (m_orientation == Orientation.Horizontal)
		{
			position.x += m_marginPx
			size.width -= m_marginPx * 2

			indicator.setPositionPx(position.x + (size.width - indicatorSize.width) * getPercentage(), indicatorPosition.y)
		}
		else if (m_orientation == Orientation.Vertical)
		{
			position.y += m_marginPx
			size.height -= m_marginPx * 2

			indicator.setPositionPx(indicatorPosition.x, position.y + (size.height - indicatorSize.height) * getPercentage())
		}

		if (value != oldValue)
			callEvent("GUI.onChange", this)
	}

	function getMinimum()
	{
		return m_minimum
	}

	function setMinimum(minimum)
	{
		m_minimum = minimum
		setValue(m_value)
	}

	function getMaximum()
	{
		return m_maximum
	}

	function setMaximum(maximum)
	{
		m_maximum = maximum
		setValue(m_value)
	}

	function getStep()
	{
		return m_step
	}

	function setStep(step)
	{
		m_step = step
	}

	function changeSection(cursorPositionX, cursorPositionY)
	{
		local position = base.getPositionPx()
		local size = base.getSizePx()

		local indicatorSize = indicator.getSizePx()

		// calculating distance and make it positive number
		local distance = m_maximum - m_minimum

		if (distance < 0)
			distance = -distance

		// normalizing distance
		distance -= distance % m_step

		// setting margin, calculating percentage cursor location on slider, center the percentageLocation
		local percentageLocation

		if (m_orientation == Orientation.Horizontal)
		{
			position.x += m_marginPx
			size.width -= m_marginPx * 2

			percentageLocation = (cursorPositionX - position.x).tofloat() / (size.width - indicatorSize.width)
			percentageLocation -= (indicatorSize.width / 2).tofloat() / size.width
		}
		else
		{
			position.y += m_marginPx
			size.height -= m_marginPx * 2

			percentageLocation = (cursorPositionY - position.y).tofloat() / (size.height - indicatorSize.height)
			percentageLocation -= (indicatorSize.height / 2).tofloat() / size.height
		}

		// inverting percentage if max < min, calculating newValue, adding distance between ranges
		local isMaxLessThanMin = (m_maximum < m_minimum)

		if (isMaxLessThanMin)
			percentageLocation = 1.0 - percentageLocation

		local newValue = percentageLocation * distance

		if (isMaxLessThanMin)
			newValue += (m_minimum - distance)
		else
 			newValue += (m_maximum - distance)

		// normalizing newValue
		newValue -= newValue % m_step

		setValue(newValue)
	}

	function setAlpha(alpha)
	{
		base.setAlpha(alpha)
		indicator.setAlpha(alpha)
	}

	function top()
	{
		base.top()
		indicator.top()
	}

	function setVisible(visible)
	{
		base.setVisible(visible)
		indicator.setVisible(visible)
	}

	function setPositionPx(x, y)
	{
		local position = base.getPositionPx()
		local indicatorPosition = indicator.getPositionPx()

		base.setPositionPx(x, y)
		indicator.setPositionPx(x + (indicatorPosition.x - position.x), y + (indicatorPosition.y - position.y))
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function setSizePx(width, height)
	{
		base.setSizePx(width, height)
		setValue(m_value)
	}

	function setSize(width, height)
	{
		setSizePx(nax(width), nay(height))
	}

	function getMarginPx()
	{
		return m_marginPx
	}

	function setMarginPx(margin)
	{
		m_marginPx = margin
		setValue(m_value)
	}

	function getMargin()
	{
		if (orientation == Orientation.Horizontal)
			return anx(m_marginPx)
		else if (orientation == Orientation.Vertical)
			return any(m_marginPx)
	}

	function setMargin(margin)
	{
		if (orientation == Orientation.Horizontal)
			setMarginPx(nax(margin))
		else if (orientation == Orientation.Vertical)
			setMarginPx(nay(margin))
	}

	static function getActiveElement()
	{
		return activeRange
	}

	static function setActiveElement(element)
	{
		activeRange = element
	}

	static function onMouseDown(self, button)
	{
		if (button != MOUSE_LMB)
			return

		if (activeRange)
			return

		if (self instanceof GUI.Range)
		{
			if (self.indicator.isMouseAt())
				return

			local cursorPosition = getCursorPositionPx()

			self.changeSection(cursorPosition.x, cursorPositionY)
			activeRange = self
		}
		else if (self instanceof GUI.Texture)
		{
			if (!(self.parent instanceof GUI.Range))
				return

			if (self != self.parent.indicator)
				return

			activeRange = self.parent
		}
	}

	static function onMouseRelease(button)
	{
		if (button != MOUSE_LMB)
			return

		if (!activeRange)
			return

		activeRange = null
	}

	static function onMouseMove(newCursorX, newCursorY, oldCursorX, oldCursorY)
	{
		if (!activeRange)
			return

		activeRange.changeSection(newCursorX, newCursorY)
	}
}

addEventHandler("GUI.onMouseDown", GUI.Range.onMouseDown)
addEventHandler("onMouseRelease", GUI.Range.onMouseRelease)
addEventHandler("onMouseMove", GUI.Range.onMouseMove)
