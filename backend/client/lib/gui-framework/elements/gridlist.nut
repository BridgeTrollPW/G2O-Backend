class GUI.GridListCell extends GUI.Button
{
	m_value = null

	constructor(x, y, width, height, file, value)
	{
		base.constructor(x, y, width, height, file, value)
		setValue(value)
	}

	function getValue()
	{
		return (m_value != null) ? m_value : getText()
	}

	function setValue(value)
	{
		m_value = value
		setText(value)
	}
}

class GUI.GridListRow
{
#private:
	m_visible = false

#public:
	id = -1

	parent = null
	cells = null

	function destroy()
	{
		foreach (index, _ in cells)
		{
			if (cells[index])
				cells[index] = cells[index].destroy()
		}
	}

	function insertCell(cellId, text)
	{
		if (cells[cellId])
			return

		local cell = GUI.GridListCell(0, 0, parent.columns[cellId].width, parent.columns[0].draw.getSize().height, "", text)
		cell.parent = this

		cell.setAlignment(parent.columns[cellId].getAlignment())
		cell.setMarginPx(parent.columns[cellId].getMarginPx())

		cells[cellId] = cell

		if (m_visible)
		{
			cell.setVisible(true)

			if (cellId >= parent.m_currentPosition && cellId < parent.m_currentPosition + parent.getMaximumVisibleRows())
				parent.refreshList()
		}

		return cell
	}

	function removeCell(cellId)
	{
		if (!cells[cellId])
			return

		cells[cellId] = cells[cellId].destroy()
	}

	function setPositionPx(x, y)
	{
		local width = 0

		for (local i = 0; i < parent.columns.len(); ++i)
		{
			if (cells[i])
				cells[i].setPositionPx(x + nax(width), y)

			width += parent.columns[i].width
		}
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function getVisible()
	{
		return m_visible
	}

	function setVisible(visible)
	{
		m_visible = visible

		foreach (cell in cells)
		{
			if (cell)
				cell.setVisible(visible)
		}
	}
}

class GUI.GridListColumn extends GUI.Button
{
#public:
	id = -1
	width = 0

	constructor (x, y, width, height, text = null)
	{
		base.constructor(x, y, 0, 0, "", text)

		local drawSize = draw.getSize()

		if (!width)
			width = drawSize.width

		if (!height)
			height = drawSize.height

		this.width = width

		setSize(width, height)
	}

	function destroy()
	{
		base.destroy()

		foreach (index, _ in parent.rows)
		{
			parent.rows[index].removeCell(id)
			parent.rows[index].cells.remove(id)
		}
	}

	function setAlignment(alignment)
	{
		base.setAlignment(alignment)

		if (!parent)
			return

		foreach (row in parent.rows)
		{
			if (row.cells[id])
				row.cells[id].setAlignment(alignment)
		}
	}

	function setMarginPx(margin)
	{
		base.setMarginPx(margin)

		if (!parent)
			return

		foreach (row in parent.rows)
		{
			if (row.cells[id])
				row.cells[id].setMarginPx(margin)
		}
	}

	function setMargin(margin)
	{
		setMarginPx(nax(margin))
	}
}

class GUI.GridList extends GUI.Texture
{
#private:
	m_currentPosition = 0
	m_marginPx = null

#public:
	columns = null
	rows = null

	scrollbar = null

	constructor(x, y, w, h, bodyBg, scrollBg, scrollIndicator, scrollIncreaseBtn, scrollDecreaseBtn, window = null)
	{
		columns = []
		rows = []

		m_marginPx = {x = 0, y = 0}

		scrollbar = GUI.ScrollBar(x + w - anx(GRIDLIST_SCROLLBAR_SIZE), y, anx(GRIDLIST_SCROLLBAR_SIZE), h, scrollBg, scrollIndicator, scrollIncreaseBtn, scrollDecreaseBtn, Orientation.Vertical)
		base.constructor(x, y, w, h, bodyBg, window)

		scrollbar.parent = this
		scrollbar.setMinimum(0)
		scrollbar.setMaximum(0)
		scrollbar.top()
	}

	function destroy()
	{
		foreach(index, _ in columns)
			columns[index] = columns[index].destroy()

		foreach (index, _ in rows)
			rows[index] = rows[index].destroy()

		scrollbar = scrollbar.destroy()
		base.destroy()
	}

	function setPositionPx(x, y)
	{
		base.setPositionPx(x, y)
		scrollbar.setPositionPx(x + getSizePx().width - GRIDLIST_SCROLLBAR_SIZE, y)

		refreshColumns()
		refreshList()
	}

	function setPosition(x, y)
	{
		setPositionPx(nax(x), nay(y))
	}

	function insertColumn(index, text, width = null, align = Align.Center)
	{
		local position = getPosition()
		local margin = getMargin()

		for (local i = 0; i < index; ++i)
			margin.x += columns[i].getSize().width

		local column = GUI.GridListColumn(position.x + margin.x, position.y + margin.y, width, null, text)

		column.setAlignment(align)
		column.setVisible(visible)

		column.id = index
		column.parent = this

		columns.insert(index, column)

		foreach (row in rows)
		{
			if (!(index in row))
				row.cells.insert(index, null)
		}

		return column
	}

	function addColumn(text, width = null, align = Align.Center)
	{
		return insertColumn(columns.len(), text, width, align)
	}

	function removeColumn(columnId)
	{
		for (local i = columns.len() - 1; i > columnId; --i)
			--columns[i].id

		columns[columnId].destroy()
		columns.remove(columnId)

		if (!columns.len())
			scrollbar.setMaximum(0)
		else
		{
			refreshColumns()
			refreshList()
		}
	}

	function insertRow(rowId, ...)
	{
		local row = GUI.GridListRow()

		row.id = rowId
		row.parent = this

		row.cells = array(columns.len(), null)

		rows.insert(rowId, row)

		for (local i = columns.len() - 1; i >= 0; --i)
			rows[rowId].insertCell(i, vargv[i])

		local maximumVisibleRows = getMaximumVisibleRows()

		if (rows.len() > maximumVisibleRows)
			scrollbar.setMaximum(scrollbar.getMaximum() + 1)

		if (rowId < m_currentPosition + maximumVisibleRows)
			refreshList()

		return row
	}

	function addRow(...)
	{
		vargv.insert(0, this)
		vargv.insert(1, rows.len())

		return insertRow.acall(vargv)
	}

	function removeRow(rowId)
	{
		for (local i = rows.len() - 1; i > rowId; --i)
			--rows[i].id

		rows[rowId].destroy()
		rows.remove(rowId)

		local maximumVisibleRows = getMaximumVisibleRows()

		if (rows.len() >= maximumVisibleRows)
			scrollbar.setMaximum(scrollbar.getMaximum() - 1)

		if (rowId >= m_currentPosition && rowId < m_currentPosition + maximumVisibleRows)
			refreshList()
	}

	function setVisible(visible)
	{
		base.setVisible(visible)
		scrollbar.setVisible(visible)

		foreach (column in columns)
			column.setVisible(visible)

		refreshList()
	}

	function getMarginPx()
	{
		return m_marginPx
	}

	function setMarginPx(x, y)
	{
		m_marginPx.x = x
		m_marginPx.y = y

		refreshList()
	}

	function getMargin()
	{
		return {x = anx(m_marginPx.x), y = any(m_marginPx.y)}
	}

	function setMargin(x, y)
	{
		setMarginPx(nax(x), nay(y))
	}

	function sort(func)
	{
		hideOldRows()
		rows.sort(func)
		showNewRows()
	}

	function getMaximumVisibleRows()
	{
		local columnSize = columns[0].getSizePx().height
		return (getSizePx().height - columnSize - m_marginPx.y * 2) / columnSize
	}

	function hideOldRows()
	{
		for (local i = m_currentPosition, end = m_currentPosition + getMaximumVisibleRows(); i < end && (i in rows); ++i)
			rows[i].setVisible(false)
	}

	function showNewRows()
	{
		if (!visible)
			return

		local cellSize = columns[0].getSizePx()
		local position = getPositionPx()

		position.x += m_marginPx.x
		position.y += m_marginPx.y

		m_currentPosition = scrollbar.getValue()

		for (local i = m_currentPosition, end = m_currentPosition + getMaximumVisibleRows(); i < end && (i in rows); ++i)
		{
			position.y += cellSize.height

			rows[i].setPositionPx(position.x, position.y)
			rows[i].setVisible(true)
		}
	}

	function refreshList()
	{
		if (!columns.len())
			return

		hideOldRows()
		showNewRows()
	}

	function refreshColumns()
	{
		local position = getPositionPx()

		position.x += m_marginPx.x
		position.y += m_marginPx.y

		foreach (column in columns)
		{
			column.setPositionPx(position.x, position.y)
			position.x += nax(column.width)
		}
	}

	static function onChange(self)
	{
		if (!(self instanceof GUI.ScrollBar))
			return

		if (!(self.parent instanceof GUI.GridList))
			return

		self.parent.refreshList()
	}
}

addEventHandler("GUI.onChange", GUI.GridList.onChange)
