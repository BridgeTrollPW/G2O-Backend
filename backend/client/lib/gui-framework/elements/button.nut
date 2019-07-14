local activeAnimationButton = null

class GUI.Button extends GUI.Texture
{
#protected:
	m_alignment = Align.Center
	m_marginPx = 0

#public:
	draw = null
	animation = true

	constructor (x, y, width, height, file, text = null, window = null)
	{
		base.constructor(x, y, width, height, file, window)

		if (text != null)
		{
			draw = GUI.Draw(0, 0, text)
			draw.setDisabled(true)

			setAlignment(getAlignment())
		}
	}

	function destroy()
	{
		if (activeAnimationButton == this)
			activeAnimationButton = null

		if (draw)
			draw = draw.destroy()

		base.destroy()
	}

	function getMarginPx()
	{
		return m_marginPx
	}

	function setMarginPx(margin)
	{
		m_marginPx = margin
		setAlignment(getAlignment())
	}

	function getMargin()
	{
		return anx(m_marginPx)
	}

	function setMargin(margin)
	{
		setMarginPx(nax(margin))
	}

	function getAlignment()
	{
		return m_alignment
	}

	function setAlignment(alignment)
	{
		if (!draw)
			return

		m_alignment = alignment

		local position = getPositionPx()
		local size = getSizePx()

		switch (alignment)
		{
			case Align.Left:
				draw.leftPx(position.x + getMarginPx(), position.y, size.width, size.height)
				break

			case Align.Center:
				draw.centerPx(position.x, position.y, size.width + getMarginPx(), size.height)
				break

			case Align.Right:
				draw.rightPx(position.x, position.y, size.width + getMarginPx(), size.height)
				break
		}
	}

	function setVisible(visible)
	{
		base.setVisible(visible)

		if (draw)
			draw.setVisible(visible)
	}

	function setAlpha(alpha)
	{
		base.setAlpha(alpha)

		if (draw)
			draw.setAlpha(alpha)
	}

	function top()
	{
		base.top()

		if (draw)
			draw.top()
	}

	function setPositionPx(x, y)
	{
		base.setPositionPx(x, y)

		if (draw)
			setAlignment(getAlignment())
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function setSizePx(width, height)
	{
		base.setSizePx(width, height)

		if (draw)
			setAlignment(getAlignment())
	}

	function setSize(x, y)
	{
		setSizePx(nax(x), nay(y))
	}

	function getText()
	{
		return draw.getText()
	}

	function setText(text)
	{
		draw.setText(text)
		setAlignment(getAlignment())
	}

	static function onAnimationStart(self, btn)
	{
		if (!(self instanceof GUI.Button))
			return

		if (btn != MOUSE_LMB)
			return

		if (!self.animation)
			return

		if (self.draw)
		{
			local position = self.draw.getPositionPx()
			self.draw.setPositionPx(position.x + 4, position.y + 4)

			activeAnimationButton = self
		}
	}

	static function onAnimationEnd(btn)
	{
		if (!activeAnimationButton)
			return

		if (btn != MOUSE_LMB)
			return

		local position = activeAnimationButton.draw.getPositionPx()
		activeAnimationButton.draw.setPositionPx(position.x - 4, position.y - 4)

		activeAnimationButton = null
	}
}

addEventHandler("GUI.onMouseDown", GUI.Button.onAnimationStart)
addEventHandler("onMouseRelease", GUI.Button.onAnimationEnd)
